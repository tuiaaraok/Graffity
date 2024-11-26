//
//  ShoppingFormTableViewCell.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import UIKit

protocol ShoppingFormTableViewCellDelegate: AnyObject {
    func changeName(cell: UITableViewCell, value: String?)
    func changePrice(cell: UITableViewCell, value: String?)
}

class ShoppingFormTableViewCell: UITableViewCell {
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var priceTextField: PricesTextField!
    weak var delegate: ShoppingFormTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        nameTextField.delegate = self
        priceTextField.baseDelegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(shopping: ShoppingModel) {
        nameTextField.text = shopping.name
        priceTextField.text = (shopping.price?.formattedToString() ?? "")
    }
}

extension ShoppingFormTableViewCell: UITextFieldDelegate, PriceTextFielddDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            delegate?.changeName(cell: self, value: textField.text)
        case priceTextField:
            delegate?.changePrice(cell: self, value: textField.text)
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
    }
}
