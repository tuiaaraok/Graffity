//
//  OrderTableViewCell.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import UIKit
import FSPagerView

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var pageControl: FSPageControl!
    private var orderModel: OrderModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pagerView.layer.cornerRadius = 8
        pagerView.layer.borderWidth = 2
        pagerView.layer.borderColor = UIColor.black.cgColor
        pagerView.layer.masksToBounds = true
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.contentMode = .center
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
//        pagerView.itemSize = CGSize(width: 79, height: 75)
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pageControl.contentHorizontalAlignment = .center
        pageControl.setFillColor(.white, for: .selected)
        pageControl.setFillColor(.baseGray, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(orderModel: OrderModel) {
        self.orderModel = orderModel
        nameLabel.text = orderModel.name
        dateLabel.text = orderModel.date?.toString()
        locationLabel.text = orderModel.location
    }
    
}

extension OrderTableViewCell: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return orderModel?.photos.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if let data = orderModel?.photos[index] {
            cell.imageView?.image = UIImage(data: data)
        }
        return cell
    }
        
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
}
