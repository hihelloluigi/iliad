//
//  ProfileViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 13/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ProfileRowType {
    case header
    case row
}

struct ProfileRow {
    let order: Int
    let type: ProfileRowType
    let firstValue: String?
    var secondValue: String?
    let thirdValue: String?
    let icon: UIImage?
    let editIcon: UIImage?
    let handler: VoidHandler?
}

class ProfileViewController: UIViewController {

    // Mark - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Mark - Variables
    var user: User?
    var rows = [ProfileRow]()

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupData()
        setupTableView()
        configurationUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Mark - Setup
    private func setup() {
        getGeneralInformations()
    }
    private func setupData() {
        guard let user = user else { return }
        self.rows.append(ProfileRow(order: 0, type: .header, firstValue: user.name, secondValue: user.phoneNumber, thirdValue: user.id, icon: #imageLiteral(resourceName: "ic_profile"), editIcon: nil, handler: nil))
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    private func configurationUI() {
        self.navigationController?.navigationBar.hideShadowBar()
    }

    // Mark - Helpers
    private func retriveData(json: JSON) {
        for element in json {
            switch element.0 {
            case "0": // Address
                self.rows.append(ProfileRow(order: 1,
                                            type: .row,
                                            firstValue: element.1["0"].string,
                                            secondValue: element.1["1"].string,
                                            thirdValue: element.1["2"].string,
                                            icon: #imageLiteral(resourceName: "ic_home"), editIcon: nil,
                                            handler: nil))
            case "1": // Payment
                self.rows.append(ProfileRow(order: 2,
                                            type: .row,
                                            firstValue: element.1["0"].string,
                                            secondValue: element.1["1"].string,
                                            thirdValue: element.1["2"].string,
                                            icon: #imageLiteral(resourceName: "ic_credit_card"), editIcon: nil,
                                            handler: nil))
            case "2": // Email
                self.rows.append(ProfileRow(order: 3, type: .row, firstValue: element.1["0"].string, secondValue: element.1["1"].string, thirdValue: nil, icon: #imageLiteral(resourceName: "ic_email"), editIcon: #imageLiteral(resourceName: "ic_edit"), handler: {
                    guard let changeEmailVC = "Profile" <%> "ChangeEmailViewController" as? ChangeEmailViewController else {
                        return
                    }

                    changeEmailVC.delegate = self
                    changeEmailVC.modalTransitionStyle = .crossDissolve
                    self.present(changeEmailVC, animated: true, completion: nil)
                }))
            case "3": // Password
                self.rows.append(ProfileRow(order: 4, type: .row, firstValue: element.1["0"].string, secondValue: element.1["1"].string, thirdValue: nil, icon: #imageLiteral(resourceName: "ic_recoverPassword"), editIcon: #imageLiteral(resourceName: "ic_edit"), handler: {
                    guard let changePasswordVC = "Profile" <%> "ChangePasswordViewController" as? ChangePasswordViewController else {
                        return
                    }

                    changePasswordVC.delegate = self
                    changePasswordVC.modalTransitionStyle = .crossDissolve
                    self.present(changePasswordVC, animated: true, completion: nil)
                }))
            case "4": // PUK
                self.rows.append(ProfileRow(order: 5, type: .row, firstValue: element.1["0"].string, secondValue: element.1["1"].string, thirdValue: nil, icon: #imageLiteral(resourceName: "ic_recoverPassword"), editIcon: #imageLiteral(resourceName: "ic_showPassowrd"), handler: {
                    guard let showPukVC = "Profile" <%> "ShowPukViewController" as? ShowPukViewController else {
                        return
                    }

                    showPukVC.modalTransitionStyle = .crossDissolve
                    self.present(showPukVC, animated: true, completion: nil)
                }))
            default:
                break
            }
        }
    }

    // Mark - APIs
    private func getGeneralInformations() {
        API.InformationClass.getGeneralInformations { (json) in
            guard let json = json else {
                return
            }

            self.retriveData(json: json["iliad"])

            self.rows = self.rows.sorted(by: { $0.order < $1.order })
            self.tableView.reloadData()
        }
    }
    private func logout() {
        API.LoginClass.logout { (success) in
            guard
                success,
                let window = UIApplication.shared.windows.first,
                let loginVC = "Login" <%> "LoginViewController" as? LoginViewController
            else {
                print("Impossible to do logout")
                return
            }

            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = loginVC
            }, completion: { (success) in
                print(success)
            })
        }
    }

    // Mark - Actions
    @IBAction func settingsDidTap(_ sender: Any) {
        guard let settingsVC = "Settings" <%> "SettingsViewController" as? SettingsViewController else {
            return
        }

        self.navigationController?.pushViewController(settingsVC, animated: true)
    }

    @IBAction func logoutDidTap(_ sender: Any) {
        logout()
    }
}

// Mark - Table View Data Source
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < rows.count else {
            return UITableViewCell()
        }

        let row = rows[indexPath.row]

        switch row.type {
        case .header:
            return cellForHeaderAt(indexPath: indexPath, row: row)
        case .row:
            return cellForRowAt(indexPath: indexPath, row: row)
        }
    }

    private func cellForHeaderAt(indexPath: IndexPath, row: ProfileRow) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "header cell", for: indexPath) as? HeaderCell else {
            return UITableViewCell()
        }
        cell.setup(name: row.firstValue, phoneNumber: row.secondValue, idCode: row.thirdValue)

        return cell
    }

    private func cellForRowAt(indexPath: IndexPath, row: ProfileRow) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "row cell", for: indexPath) as? RowCell else {
            return UITableViewCell()
        }

        cell.setup(row: row)

        return cell
    }
}

// Mark - Change Email View Controller Delegate
extension ProfileViewController: ChangeEmailDelegate {
    func changeEmailSucess(_ email: String) {
        self.rows[3].secondValue = email
        self.tableView.reloadData()
        self.showSuccessMessage(title: "Commons" ~> "SUCCESS", message: "ChangeEmail" ~> "CHANGE_EMAIL_SUCCESS_MESSAGE")
    }
}

// Mark - Change Password View Controller Delegate
extension ProfileViewController: ChangePasswordDelegate {
    func changePasswordSucess() {
        self.showSuccessMessage(title: "Commons" ~> "SUCCESS", message: "ChangePassword" ~> "CHANGE_PASSWORD_SUCCESS_MESSAGE")
    }
}
