//
//  SettingsViewController.swift
//  Graffity
//
//  Created by Karen Khachatryan on 27.11.24.
//

import UIKit
import MessageUI

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
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["surbekbabun@outlook.com"])
            present(mailComposeVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Mail Not Available",
                message: "Please configure a Mail account in your settings.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
        let privacyVC = PrivacyViewController()
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(privacyVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    @IBAction func clickedRateUs(_ sender: UIButton) {
        let appID = "6738993009"
        if let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Unable to open App Store URL")
            }
        }
    }
    
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
