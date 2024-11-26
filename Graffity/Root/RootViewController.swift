//
//  ViewController.swift
//  Graffity
//
//  Created by Karen Khachatryan on 25.11.24.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.viewControllers = [MenuViewController(nibName: "MenuViewController", bundle: nil)]
//        self.pushViewController(MenuViewController.self)
    }
}

