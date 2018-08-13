//
//  HomeViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 08/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

enum DataType {
    case data
    case call
    case sms
    case mms
    case info
}

struct DetailsRow {
    let type: DataType
    let value: String?
    let extraValue: String?
    let image: UIImage?
}

class ConsumptionViewController: UIViewController {

    // Mark - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countryConsumptionBarButton: UIBarButtonItem!

    // Mark - Variables
    var nationlConsumption: Consumption?
    var abroadConsumption: Consumption?

    var rows = [DetailsRow]()
    var isNationalConsumption: Bool = true

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupTableView()
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
    private func setup() {
        getNationalConsumption()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    // Mark - Helpers
    private func makeRows(_ consumption: Consumption?) {
        guard let consumption = consumption else {
            return
        }
        rows = [
            DetailsRow(type: .call, value: consumption.calls, extraValue: consumption.extraCalls, image: #imageLiteral(resourceName: "ic_call")),
            DetailsRow(type: .sms, value: consumption.sms, extraValue: consumption.extraSMS, image: #imageLiteral(resourceName: "ic_sms")),
            DetailsRow(type: .mms, value: consumption.mms, extraValue: consumption.extraMMS, image: #imageLiteral(resourceName: "ic_mms")),
            DetailsRow(type: .data, value: consumption.data, extraValue: consumption.extraData, image: #imageLiteral(resourceName: "ic_internet"))
        ]

        tableView.reloadData()
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        if isNationalConsumption {
            getNationalConsumption()
        } else {
            getAbroadConsumption()
        }
    }

    private func changeCountryConsumption() {
        if isNationalConsumption {
            countryConsumptionBarButton.image = #imageLiteral(resourceName: "ic_italy_filled")

            if let nationlConsumption = nationlConsumption {
                makeRows(nationlConsumption)
            } else {
                getNationalConsumption()
            }
        } else {
            countryConsumptionBarButton.image = #imageLiteral(resourceName: "ic_europe_filled")
            if let abroadConsumption = abroadConsumption {
                makeRows(abroadConsumption)
            } else {
                getAbroadConsumption()
            }
        }
    }

    // Mark - APIs
    private func getNationalConsumption() {
        API.ConsumptionClass.getNationalConsumption { (json) in
            guard let json = json else {
                return
            }

            self.nationlConsumption = Consumption(json: json)
            self.makeRows(self.nationlConsumption)
        }
    }
    private func getAbroadConsumption() {
        API.ConsumptionClass.getAbroudConsumption { (json) in
            guard let json = json else {
                return
            }
            self.abroadConsumption = Consumption(json: json)
            self.makeRows(self.abroadConsumption)
        }
    }

    // Mark - Actions
    @IBAction func changeCountryConsumptionDidTap(_ sender: Any) {
        isNationalConsumption = !isNationalConsumption
        changeCountryConsumption()
    }
}

// Mark - Table View Data Source
extension ConsumptionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            indexPath.row < rows.count,
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic cell", for: indexPath) as? BasicCell
        else {
            return UITableViewCell()
        }

        let row = rows[indexPath.row]

        cell.setup(value: row.value, extraValue: row.extraValue, image: row.image)
        return cell
    }
}
