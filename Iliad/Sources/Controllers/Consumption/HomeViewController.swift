//
//  Consumption2ViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 27/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import SwiftyJSON
import TransitionButton

class HomeViewController: UIViewController {

    // Mark - Outlets
        // Views
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleViewContainer: UIView!
    @IBOutlet weak var creditViewContainer: UIView!
    @IBOutlet weak var whiteSpaceViewContainer: UIView!
    @IBOutlet weak var countryViewContainer: UIView!
    @IBOutlet weak var consumptionViewContainer: UIView!
    
        // Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleDescriptionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var creditTitleLabel: UILabel!
    @IBOutlet weak var renewalLabel: UILabel!
    @IBOutlet weak var renewalTitleLabel: UILabel!

        // Buttons
    @IBOutlet weak var consumptionDetailsButton: TransitionButton!

    // Mark - Variables
    var user: User?
    var nationlConsumption: Consumption?
    var abroadConsumption: Consumption?
    var pagerVC: PagerViewController?

    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        reset()
        configurationUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.scrollView.contentSize = self.stackView.frame.size
    }

    // Mark - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pager segue" {
            if let view = segue.destination as? PagerViewController {
                pagerVC = view
                view.delegate = self
            }
        }
    }

    // Mark - Setup
    private func configurationUI() {
        guard
            let user = user,
            let name = user.name
        else {
            return
        }
        
        nameLabel.text = "\("Home" ~> "NAME_TITLE"), \(name)!"
        titleDescriptionLabel.text = "Home" ~> "TITLE"
        consumptionDetailsButton.setTitle("Home" ~> "DETAILS_BUTTON", for: .normal)
    }

    private func reset() {
        nameLabel.text = nil
        titleDescriptionLabel.text = nil
        countryLabel.text = nil
        creditLabel.text = nil
        creditTitleLabel.text = nil
        renewalLabel.text = nil
        renewalTitleLabel.text = nil
    }

    // Mark - Helpers
    private func retriveUserInformation(json: JSON) {
        guard let user = user else {
            return
        }
        let creditRenewal = json["iliad"]["0"]["0"].string?.components(separatedBy: "&")

        if let credit = creditRenewal?[0] {
            user.credit = credit
            creditLabel.text = credit
            creditTitleLabel.text = "Home" ~> "CREDIT"
        }

        if let stringDate = creditRenewal?[1], let renewal = Date.from(string: stringDate, withFormat: "dd/MM/yyyy") {
            user.renewal = renewal

            if let day = Date.differentBetweenDate(first: Date(), second: renewal, components: [.day]).day {
                renewalLabel.text = "\(day)"
                renewalTitleLabel.text = "Home" ~> "NEXT_RENEWAL"
            }
        }
    }

    // Mark - APIs
    private func getNationalConsumption(viewController: UIViewController?) {
        guard let viewController = viewController as? ConsumptionViewController else { return }
        viewController.load()
        self.countryLabel.text = "ITALIA"

        API.ConsumptionClass.getNationalConsumption { (json) in
            guard let json = json else {
                return
            }
            self.nationlConsumption = Consumption(json: json["iliad"])
            self.retriveUserInformation(json: json)
            viewController.finishLoad()
            viewController.configurionData(consumption: self.nationlConsumption)
        }
    }
    private func getAbroadConsumption(viewController: UIViewController?) {
        guard let viewController = viewController as? ConsumptionViewController else { return }
        viewController.load()
        self.countryLabel.text = "EUROPA"

        API.ConsumptionClass.getAbroudConsumption { (json) in
            guard let json = json else {
                return
            }
            self.abroadConsumption = Consumption(json: json["iliad"])
            viewController.finishLoad()
            viewController.configurionData(consumption: self.abroadConsumption)
        }
    }

    // Mark - Actions
    @IBAction func consumptionDetailsDidTap(_ sender: Any) {
        guard let consumptionDetailsVC = "Consumption" <%> "ConsumptionDetailsViewController" as? ConsumptionDetailsViewController else {
            return
        }

        consumptionDetailsVC.modalTransitionStyle = .crossDissolve
        self.present(consumptionDetailsVC, animated: true, completion: nil)
    }
}

// Mark - APIs
extension HomeViewController: PagerDelegate {
    func changePage(_ number: Int, testVC: UIViewController?) {
        switch number {
        case 0:
            getNationalConsumption(viewController: testVC)
        case 1:
            getAbroadConsumption(viewController: testVC)
        default:
            print("Nessuna pagina")
        }
    }
}
