//
//  OptionsViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 13/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

struct OptionsRow {
    let key: String?
    var isActive: Bool
    let description: String?
}

class OptionsViewController: UIViewController {

    // Mark - Outlets
    @IBOutlet weak var tableView: UITableView!

    // Mark - Variables
    var rows = [OptionsRow]()

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Mark - Setup
    private func setup() {
        getOptions()
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // Mark - Helpers
    private func showMessage(isActive: Bool, text: String?) {
        guard let text = text else {
            return
        }

        showSuccessMessage(title: "Successo", message: "\(text) \((isActive ? "attivato" : "disattivato"))")
    }

    // Mark - APIs
    private func getOptions() {
        CustomActivityIndicator.progress()
        API.OptionClass.getOptions { (json) in
            CustomActivityIndicator.hide()
            guard let json = json else {
                return
            }
            for element in json["iliad"] {
                if let key = element.1["3"].string, let isActive = element.1["2"].string, let description = element.1["0"].string {
                    self.rows.append(OptionsRow(key: key, isActive: isActive.toBool() ?? false, description: description))
                }
            }

            self.tableView.reloadData()
        }
    }
    private func changeOption(key: String?, isOn: Bool, indexPath: IndexPath) {
        guard let key = key else { return }
        API.OptionClass.changeOption(activate: isOn, option: key) { (success) in
            guard success else {
                self.rows[indexPath.row].isActive = !isOn
                self.tableView.reloadRows(at: [indexPath], with: .none)
                self.showErrorMessage(message: "Impossibile \((self.rows[indexPath.row].isActive ? "attivare" : "disattivare")) l'opzione")
                return
            }
            self.rows[indexPath.row].isActive = isOn
            self.showMessage(isActive: self.rows[indexPath.row].isActive, text: self.rows[indexPath.row].description)
        }
    }
}

// Mark - Table View Data Source
extension OptionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            indexPath.row < rows.count,
            let cell = tableView.dequeueReusableCell(withIdentifier: "option cell", for: indexPath) as? OptionCell
        else {
            return UITableViewCell()
        }

        let row = rows[indexPath.row]

        cell.setup(key: row.key, isOn: row.isActive, description: row.description) { (key, isOn) in
            self.changeOption(key: key, isOn: isOn, indexPath: indexPath)
        }
        
        return cell
    }
}
