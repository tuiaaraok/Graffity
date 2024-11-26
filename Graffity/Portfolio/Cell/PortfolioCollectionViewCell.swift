//
//  PortfolioCollectionViewCell.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import UIKit
import FSPagerView

protocol PortfolioCollectionViewCellDelegate: AnyObject {
    func selectItem(cell: UICollectionViewCell)
}

class PortfolioCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var pageControl: FSPageControl!
    private var portfolio: PortfolioModel?
    weak var delegate: PortfolioCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        pagerView.layer.cornerRadius = 8
        pagerView.layer.borderWidth = 2
        pagerView.layer.borderColor = UIColor.black.cgColor
        pagerView.layer.masksToBounds = true
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.contentMode = .scaleAspectFit
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.itemSize = pagerView.bounds.size
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pageControl.contentHorizontalAlignment = .center
        pageControl.setFillColor(.white, for: .selected)
        pageControl.setFillColor(.black, for: .normal)
    }
    
    func configure(portfolio: PortfolioModel, color: UIColor) {
        pagerView.backgroundColor = color
        self.portfolio = portfolio
        self.pageControl.numberOfPages = portfolio.photos.count
        self.pagerView.reloadData()
    }
    
}

extension PortfolioCollectionViewCell: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return portfolio?.photos.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.contentMode = .scaleAspectFill
        if let data = portfolio?.photos[index] {
            cell.imageView?.image = UIImage(data: data)
        }
        return cell
    }
        
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        delegate?.selectItem(cell: self)
    }
}
