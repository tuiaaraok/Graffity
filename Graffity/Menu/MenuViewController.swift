//
//  MenuViewController.swift
//  Graffity
//
//  Created by Karen Khachatryan on 25.11.24.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var sectionButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionButtons.forEach({ $0.titleLabel?.font = .regularBarse(size: 38) })
    }

    @IBAction func clickedOrders(_ sender: UIButton) {
        self.pushViewController(OrdersViewController.self)
    }
    
    @IBAction func clickedPortfolio(_ sender: UIButton) {
        self.pushViewController(PortfolioViewController.self)
    }
    
    @IBAction func clickedShoppingList(_ sender: UIButton) {
        self.pushViewController(ShoppingListViewController.self)
    }
    
    @IBAction func clickedAnalytics(_ sender: UIButton) {
        self.pushViewController(AnalyticsViewController.self)
    }
    
    @IBAction func clickedSettings(_ sender: UIButton) {
        self.pushViewController(SettingsViewController.self)
    }
}
