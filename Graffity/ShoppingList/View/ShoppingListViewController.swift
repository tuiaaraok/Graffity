//
//  ShoppingListViewController.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import UIKit
import Combine

class ShoppingListViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shoppingListTableView: UITableView!
    private let viewModel = ShoppingListViewModel.shared
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
        shoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingListTableViewCell")
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$shoppings
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shoppings in
                guard let self = self else { return }
                self.shoppingListTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func openShoppingFormVC() {
        let shoppingFormVC = ShoppingFormViewController(nibName: "ShoppingFormViewController", bundle: nil)
        shoppingFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchData()
            }
        }
        self.navigationController?.pushViewController(shoppingFormVC, animated: true)
    }
    
    @IBAction func clickedAdd(_ sender: UIButton) {
        openShoppingFormVC()
    }
}

extension ShoppingListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.shoppings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListTableViewCell", for: indexPath) as! ShoppingListTableViewCell
        cell.configure(shopping: viewModel.shoppings[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        24
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
}

extension ShoppingListViewController: ShoppingListTableViewCellDelegate {
    func confirmShopping(id: UUID, isCompleted: Bool) {
        viewModel.confirmShopping(id: id, isCompleted: isCompleted) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.viewModel.fetchData()
            }
        }
    }
}
