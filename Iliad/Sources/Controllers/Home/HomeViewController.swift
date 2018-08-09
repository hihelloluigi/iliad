//
//  HomeViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 08/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

enum DataType {
    case internet
    case call
    case sms
    case mms
    case info
}

struct Row {
    let type: DataType
    let value: String?
    let image: UIImage?
}

class HomeViewController: UIViewController {

    // Mark - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!

    // Mark - Variables
    var user: User?
    var rows = [Row]()
    
    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        fakeRows()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
    }

    // Mark - Setup
    private func setupTableView() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    // Mark - Helpers
    private func fakeRows() {
        rows = [
            Row(type: .call, value: "10 minuti", image: #imageLiteral(resourceName: "ic_call")),
            Row(type: .sms, value: "30 SMS", image: #imageLiteral(resourceName: "ic_sms")),
            Row(type: .mms, value: "2 MMS", image: #imageLiteral(resourceName: "ic_mms")),
            Row(type: .info, value: "2 MMS", image: #imageLiteral(resourceName: "ic_mms"))
        ]

        tableView.reloadData()
    }

    // Mark - APIs
    private func logout() {
        API.LoginClass.logout { (success) in
            guard success else {
                print("Impossible to do logout")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Mark - Actions
    @IBAction func settingsDidTap(_ sender: Any) {
    }
    @IBAction func logoutDidTap(_ sender: Any) {
        logout()
    }
}

extension HomeViewController: UITableViewDataSource {
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
        case .call:
            return cellForRowAt(indexPath: indexPath, row: row)
        case .sms:
            return cellForRowAt(indexPath: indexPath, row: row)
        case .mms:
            return cellForRowAt(indexPath: indexPath, row: row)
        case .internet:
            break
        case .info:
            break
//            return infoCellForRowAt(indexPath: indexPath, row: row)
        }

        return UITableViewCell()
    }

    private func cellForRowAt(indexPath: IndexPath, row: Row) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "basic cell", for: indexPath) as? BasicCell else {
            return UITableViewCell()
        }

        cell.setup(value: row.value, image: row.image)
        return cell
    }

//    private func infoCellForRowAt(indexPath: IndexPath, row: Row) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "info cell", for: indexPath) as? InfoCell else {
//            return UITableViewCell()
//        }
//
//        cell.setup(name: "Luigi Aiello", phoneNumber: "3518005008", credit: "4,50 €", deadline: "15 agosto 2018")
//
//        return cell
//    }
}
