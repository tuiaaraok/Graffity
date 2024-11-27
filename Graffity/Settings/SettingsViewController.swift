//
//  SettingsViewController.swift
//  Graffity
//
//  Created by Karen Khachatryan on 27.11.24.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var settingButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviagtionBackButton(title: "Back")
        settingButtons.forEach({ $0.titleLabel?.font = .regularBarse(size: 38)})
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
    }
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
    }
    @IBAction func clickedRateUs(_ sender: UIButton) {
    }
    
}
