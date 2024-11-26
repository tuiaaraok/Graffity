//
//  ShoppingListTableViewCell.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import UIKit

protocol ShoppingListTableViewCellDelegate: AnyObject {
    func confirmShopping(id: UUID, isCompleted: Bool)
}

class ShoppingListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var checkButton: CheckBoxButton!
    private var shopping: ShoppingModel?
    weak var delegate: ShoppingListTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        nameLabel.font = .bold(size: 26)
        priceLabel.font = .bold(size: 26)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        shopping = nil
    }
    
    func configure(shopping: ShoppingModel) {
        self.shopping = shopping
        nameLabel.text = shopping.name
        priceLabel.text = "\(shopping.price?.formattedToString() ?? "")$"
        self.checkButton.isSelected = shopping.isCompleted
    }
    
    @IBAction func clickedConfirm(_ sender: CheckBoxButton) {
        if let shopping = shopping {
            delegate?.confirmShopping(id: shopping.id, isCompleted: !shopping.isCompleted)
        }
    }
}
