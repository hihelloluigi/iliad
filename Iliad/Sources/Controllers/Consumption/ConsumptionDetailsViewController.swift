//
//  ConsumptionDetailsViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 29/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import SwiftyJSON

class ConsumptionDetailsViewController: UIViewController {

    // Mark - Outlets
        // Views
    @IBOutlet weak var tableView: UITableView!

        // Buttons
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!

    // Mark - Variables
    var sections = [Section]()

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupTableView()
        configurationText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Mark - Setup
    private func setup() {
        getDetails()
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    private func configurationText() {
        cancelBarButton.title = "Commons" ~> "BACK"
    }

    // Mark - Helpers
    private func parseData(_ json: JSON) {
        for element in json["iliad"] where element.0 != "title" {
            var details = [ConsumptionDetail]()
            for item in element.1 {
                details.append(ConsumptionDetail(json: item.1))
            }
            self.sections.append(Section(name: json["iliad"]["title"][element.0].string, items: details))
        }
    }

    // Mark - APIs
    private func getDetails() {
        CustomActivityIndicator.progress()
        API.ConsumptionClass.getConsumptionDetails { (json) in
            CustomActivityIndicator.hide()
            guard let json = json else {
                return
            }

            self.parseData(json)
            self.tableView.reloadData()
        }
    }

    // Mark - Actions
    @IBAction func cancelDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// Mark - Table View Data Source
extension ConsumptionDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 1 : (1 + sections[section].items.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard
                indexPath.section < sections.count,
                let cell = tableView.dequeueReusableCell(withIdentifier: "pseudo header cell", for: indexPath) as? PseudoHeaderTableViewCell
            else {
                return UITableViewCell()
            }

            sections[indexPath.section].collapsed ? cell.setCollapsed() : cell.setExpanded()
            cell.titleLabel.text = sections[indexPath.section].name

            return cell
        } else {
            guard
                indexPath.row < sections[indexPath.section].items.count + 1,
                let cell = tableView.dequeueReusableCell(withIdentifier: "details cell", for: indexPath) as? DetailsCell
            else {
                return UITableViewCell()
            }

            let detail = sections[indexPath.section].items[indexPath.row - 1]

            cell.setup(country: detail.country, type: detail.type, phoneNumber: detail.phoneNumber, date: detail.date, volume: detail.volume)

            return cell
        }
    }
}

// Mark - Table View Delegate
extension ConsumptionDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 0 else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        sections[indexPath.section].collapsed = !sections[indexPath.section].collapsed
        tableView.reloadSections([indexPath.section], with: .automatic)
    }
}
