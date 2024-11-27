//
//  ShoppingFormViewController.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import UIKit
import Combine

class ShoppingFormViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shoppingsTableView: UITableView!
    @IBOutlet weak var saveButton: BaseButton!
    private let viewModel = ShoppingFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        setNaviagtionBackButton(title: "Cancel")
        titleLabel.font = .regularBarse(size: 30)
        shoppingsTableView.register(UINib(nibName: "ShoppingFormTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingFormTableViewCell")
        shoppingsTableView.delegate = self
        shoppingsTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$shoppings
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shoppings in
                guard let self = self else { return }
                self.saveButton.isEnabled = (shoppings.contains(where: { $0.name.checkValidation() && $0.price != nil })) && !(shoppings.contains(where: { ($0.name.checkValidation()) != ($0.price != nil) }))
                if shoppings.count != viewModel.previousShoppingsCount {
                    self.shoppingsTableView.reloadData()
                    viewModel.previousShoppingsCount = shoppings.count
                }
            }
            .store(in: &cancellables)
    }
    
    @objc func addShopping() {
        viewModel.addShopping()
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func clickedSave(_ sender: BaseButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.completion?()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension ShoppingFormViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.shoppings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingFormTableViewCell", for: indexPath) as! ShoppingFormTableViewCell
        cell.configure(shopping: viewModel.shoppings[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == viewModel.shoppings.count - 1 ? 70 : 24
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != viewModel.shoppings.count - 1 { return UIView() }
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70))
        let button = UIButton(type: .custom)
        button.setTitle("+Add", for: .normal)
        button.titleLabel?.font = .bold(size: 38)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(addShopping), for: .touchUpInside)
        button.frame = CGRect(x: (footerView.frame.width - 70) / 2, y: (footerView.frame.height - 30) / 2, width: 70, height: 40)
        footerView.addSubview(button)
        return footerView
    }
}

extension ShoppingFormViewController: ShoppingFormTableViewCellDelegate {
    func changeName(cell: UITableViewCell, value: String?) {
        if let indexPath = shoppingsTableView.indexPath(for: cell) {
            viewModel.shoppings[indexPath.section].name = value
        }
    }
    
    func changePrice(cell: UITableViewCell, value: String?) {
        if let indexPath = shoppingsTableView.indexPath(for: cell) {
            if let textWithoutSpaces = value?.components(separatedBy: .whitespacesAndNewlines).joined() {
                viewModel.shoppings[indexPath.section].price = Double(textWithoutSpaces)
            }
        }
    }
}
