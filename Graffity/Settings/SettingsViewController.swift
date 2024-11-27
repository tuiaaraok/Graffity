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
        for button in settingButtons {
            button.titleLabel?.font = .regularBarse(size: 38)
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.lineBreakMode = .byClipping
        }
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
    }
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
    }
    @IBAction func clickedRateUs(_ sender: UIButton) {
    }
    
}
