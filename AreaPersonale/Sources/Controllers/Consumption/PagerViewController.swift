//
//  PagerViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 29/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit
import BmoViewPager

protocol PagerDelegate: NSObjectProtocol {
    func changePage(_ number: Int, viewController: ConsumptionViewController?)
    func reloadData(_ number: Int, viewController: ConsumptionViewController?)
}

class PagerViewController: UIViewController {

    // Mark - Outlets
    @IBOutlet weak var viewPager: BmoViewPager!
    @IBOutlet weak var pageControl: UIPageControl!

    // Mark - Custom Delegate
    weak var delegate: PagerDelegate?
    
    // Mark - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configurationUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Mark - Setup
    private func setup() {
        viewPager.delegate = self
        viewPager.dataSource = self
        pageControl.numberOfPages = 2
    }
    private func configurationUI() {
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .iliadRed
    }
}

extension PagerViewController: BmoViewPagerDataSource {
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 2
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        switch page {
        case 0:
            guard let consumptionVC = "Consumption" <%> "ConsumptionViewController" as? ConsumptionViewController else {
                return UIViewController()
            }
            consumptionVC.delegate = self
            return consumptionVC
        case 1:
            guard let consumptionVC = "Consumption" <%> "ConsumptionViewController" as? ConsumptionViewController else {
                return UIViewController()
            }
            consumptionVC.delegate = self
            return consumptionVC
        default:
            return UIViewController()
        }
    }
}

// Mark - Pager Delegate
extension PagerViewController: BmoViewPagerDelegate {
    func bmoViewPagerDelegate(_ viewPager: BmoViewPager, pageChanged page: Int) {
        delegate?.changePage(page, viewController: viewPager.getReferencePageViewController(at: page) as? ConsumptionViewController)
        pageControl.currentPage = page
    }
}

// Mark - Consumption Delegate
extension PagerViewController: ConsumptionDelegate {
    func reloadData() {
        delegate?.reloadData(viewPager.pageControlIndex, viewController: viewPager.getReferencePageViewController(at: viewPager.pageControlIndex) as? ConsumptionViewController)
    }
}
