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
    }
    @IBAction func clickedShoppingList(_ sender: UIButton) {
    }
    @IBAction func clickedAnalytics(_ sender: UIButton) {
    }
    @IBAction func clickedSettings(_ sender: UIButton) {
    }
}
