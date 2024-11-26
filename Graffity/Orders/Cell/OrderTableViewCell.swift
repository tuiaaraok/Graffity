//
//  OrderTableViewCell.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import UIKit
import FSPagerView

protocol OrderTableViewCellDelegate: AnyObject {
    func confirmOrder(by id: UUID)
}

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var bgView: UIView!
    private var orderModel: OrderModel?
    @IBOutlet weak var confirmView: UIView!
    weak var delegate: OrderTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        bgView.layer.cornerRadius = 8
        bgView.layer.borderWidth = 2
        bgView.layer.borderColor = UIColor.black.cgColor
        pagerView.layer.cornerRadius = 8
        pagerView.layer.borderWidth = 2
        pagerView.layer.borderColor = UIColor.black.cgColor
        pagerView.layer.masksToBounds = true
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.contentMode = .center
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.itemSize = pagerView.bounds.size
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pageControl.contentHorizontalAlignment = .center
        pageControl.setFillColor(.white, for: .selected)
        pageControl.setFillColor(.black, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        orderModel = nil
        delegate = nil
    }
    
    func configure(orderModel: OrderModel) {
        self.orderModel = orderModel
        nameLabel.text = orderModel.name
        dateLabel.text = orderModel.date?.toString()
        locationLabel.text = orderModel.location
        priceLabel.text = "\(orderModel.price?.formattedToString() ?? "")$ Order cost"
        self.pageControl.numberOfPages = orderModel.photos.count
        pagerView.reloadData()
        confirmView.isHidden = orderModel.isCompleted
    }
    
    @IBAction func clickedConfirm(_ sender: UIButton) {
        if let id = orderModel?.id {
            delegate?.confirmOrder(by: id)
        }
    }
    
}

extension OrderTableViewCell: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return orderModel?.photos.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.contentMode = .scaleAspectFill
        if let data = orderModel?.photos[index] {
            cell.imageView?.image = UIImage(data: data)
        }
        return cell
    }
        
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
}
