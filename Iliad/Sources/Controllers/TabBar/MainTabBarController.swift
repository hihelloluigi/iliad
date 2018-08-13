//
//  MainTabBarController.swift
//  BikeApp
//
//  Created by Francesco Colleoni on 16/01/17.
//  Copyright © 2017 Mindtek srl. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    // Mark - Variables
    let items: [Item] = [
        Item(name: "Consumi", image: #imageLiteral(resourceName: "ic_dashboard"), selectedImage: #imageLiteral(resourceName: "ic_dashboard_filled")),
        Item(name: "Opzioni", image: #imageLiteral(resourceName: "ic_list2"), selectedImage: #imageLiteral(resourceName: "ic_list2")),
        Item(name: "Servizi", image: #imageLiteral(resourceName: "ic_services"), selectedImage: #imageLiteral(resourceName: "ic_services_filled")),
        Item(name: "Profilo", image: #imageLiteral(resourceName: "ic_profile"), selectedImage: #imageLiteral(resourceName: "ic_profile_filled"))
    ]

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        configurationUI()
    }

    // Mark - Setup
    private func configurationUI() {
        self.tabBar.tintColor = .iliadRed

        guard let viewControllers = self.viewControllers else {
            print("No viewControllers found")
            return
        }
        
        for index in 0..<viewControllers.count {
            guard let navVC = viewControllers[index] as? UINavigationController else {
                continue
            }
            navVC.title = items[index].name
            navVC.tabBarItem.image = items[index].image
            navVC.tabBarItem.selectedImage = items[index].selectedImage
        }
    }
}

enum TabBarItems: Int {
    case consumption = 0
    case options = 1
    case services = 2
    case profile = 3
}

struct Item {
    let name: String
    let image: UIImage
    let selectedImage: UIImage
}
