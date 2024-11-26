//
//  OrdersViewController.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import UIKit
import Combine

class OrdersViewController: UIViewController {

    @IBOutlet weak var ordersTableView: UITableView!
    private let viewModel = OrdersViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    @IBOutlet var sectionButtons: [BaseButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchOrders()
    }
    
    func setupUI() {
        setNavigationTitle(title: "Orders")
        setNaviagtionBackButton(title: "BACK")
        ordersTableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$orders
            .receive(on: DispatchQueue.main)
            .sink { [weak self] orders in
                guard let self = self else { return }
                self.ordersTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @IBAction func chooseType(_ sender: BaseButton) {
        sectionButtons.forEach({ $0.isSelected = false })
        sender.isSelected = true
        viewModel.filterByType(type: sender.tag)
    }
    
    @IBAction func clickedAdd(_ sender: UIButton) {
        self.pushViewController(OrderFormViewController.self)
    }
    
    deinit {
        viewModel.clear()
    }
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
        cell.configure(orderModel: viewModel.orders[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        24
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        OrderFormViewModel.shared.orderModel = viewModel.orders[indexPath.section]
        self.pushViewController(OrderFormViewController.self)
    }
}

extension OrdersViewController: OrderTableViewCellDelegate {
    func confirmOrder(by id: UUID) {
        viewModel.confirmOrder(id: id) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.viewModel.fetchOrders()
            }
        }
    }
}
