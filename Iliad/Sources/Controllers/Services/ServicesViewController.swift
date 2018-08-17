//
//  ServicesViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 13/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

struct ServicesRow {
    let key: String?
    let isActive: Bool?
    let description: String?
}

class ServicesViewController: UIViewController {

    // Mark - Outlets
    @IBOutlet weak var tableView: UITableView!

    // Mark - Variables
    var rows = [ServicesRow]()

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
        getServices()
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // Mark - APIs
    private func getServices() {
        API.ServiceClass.getServices { (json) in
            guard let json = json else {
                return
            }
            for element in json["iliad"] {
                if let key = element.1["3"].string, let isActive = element.1["2"].string, let description = element.1["0"].string {
                    self.rows.append(ServicesRow(key: key, isActive: isActive.toBool(), description: description))
                }
            }

            self.tableView.reloadData()
        }
    }
    private func changeService(key: String?, isOn: Bool) {
        guard let key = key else {
            return
        }
        API.ServiceClass.changeService(activate: isOn, service: key) { (success) in
            guard success else {
                return
            }
        }
    }
}

// Mark - Table View Data Source
extension ServicesViewController: UITableViewDataSource {
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
            self.changeService(key: key, isOn: isOn)
        }

        return cell
    }
}
