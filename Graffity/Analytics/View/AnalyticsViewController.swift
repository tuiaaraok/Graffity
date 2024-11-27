//
//  AnalyticsViewController.swift
//  Graffity
//
//  Created by Karen Khachatryan on 27.11.24.
//

import UIKit
import Combine

class AnalyticsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalOrdersLabel: UILabel!
    @IBOutlet weak var ordersLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var expenditureLabel: UILabel!
    @IBOutlet weak var totalExpenditureLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet var periodButtons: [BaseButton]!
    @IBOutlet weak var progressBgView: UIView!
    @IBOutlet weak var incomeProgressWidthConst: NSLayoutConstraint!
    private let viewModel = AnalyticsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        setNaviagtionBackButton(title: "Back")
        titleLabel.font = .regularBarse(size: 30)
        totalOrdersLabel.font = .bold(size: 60)
        ordersLabel.font = .bold(size: 38)
        incomeLabel.font = .bold(size: 18)
        expenditureLabel.font = .bold(size: 18)
        totalIncomeLabel.font = .bold(size: 10)
        totalExpenditureLabel.font = .bold(size: 18)
    }
    
    func subscribe() {
        viewModel.$analyticsModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                self.totalOrdersLabel.text = "\(data.orders)"
                self.totalIncomeLabel.text = "\(data.income)$"
                self.totalExpenditureLabel.text = "\(data.expenditure)$"
                if data.income != 0 {
                    let result = data.expenditure / data.income
                    if result > 0 {
                        let progress = Double(progressBgView.bounds.width) / (result + 1)
                        self.incomeProgressWidthConst.constant = progress
                    } else {
                        self.incomeProgressWidthConst.constant = progressBgView.bounds.width
                    }
                } else if data.expenditure == 0 {
                    self.incomeProgressWidthConst.constant = progressBgView.bounds.width / 2
                } else {
                    self.incomeProgressWidthConst.constant = 0
                }            }
            .store(in: &cancellables)
    }

    @IBAction func choosePeriod(_ sender: BaseButton) {
        if sender.isSelected { return }
        viewModel.filterByPeriod(period: sender.tag)
        periodButtons.forEach({ $0.isSelected = false })
        sender.isSelected = true
    }
}
