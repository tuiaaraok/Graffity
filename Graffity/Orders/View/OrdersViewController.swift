//
//  OrdersViewController.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import UIKit

class OrdersViewController: UIViewController {

    @IBOutlet weak var ordersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        setNavigationTitle(title: "Orders")
        setNaviagtionBackButton(title: "BACK")
    }
    @IBAction func clickedAdd(_ sender: UIButton) {
    }
}
