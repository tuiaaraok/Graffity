//
//  PortfolioViewController.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import UIKit
import Combine

class PortfolioViewController: UIViewController {

    @IBOutlet weak var portfolioCollectionView: UICollectionView!
    private let viewModel = PortfolioViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        setNavigationTitle(title: "PORTFOLIO")
        setNaviagtionBackButton(title: "back")
        let layout = UICollectionViewFlowLayout()
        let totalSpacing: CGFloat = 16 + 14
        let itemWidth = (view.frame.size.width - totalSpacing) / 2
        layout.itemSize = CGSize(width: itemWidth, height: 203)
        layout.minimumInteritemSpacing = 14
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        portfolioCollectionView.collectionViewLayout = layout
        portfolioCollectionView.allowsMultipleSelection = false
        portfolioCollectionView.register(UINib(nibName: "PortfolioCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "PortfolioCollectionViewCell")
        portfolioCollectionView.delegate = self
        portfolioCollectionView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                self.portfolioCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func openPortfolioForm() {
        let portfolioFormVC = PortfolioFormViewController(nibName: "PortfolioFormViewController", bundle: nil)
        portfolioFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchData()
            }
        }
        self.navigationController?.pushViewController(portfolioFormVC, animated: true)
    }
    
    @IBAction func clickedAdd(_ sender: UIButton) {
        openPortfolioForm()
    }
}

extension PortfolioViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortfolioCollectionViewCell", for: indexPath) as! PortfolioCollectionViewCell
        let index = indexPath.section + 1 + indexPath.row + 1
        let color = index % 2 == 0 ? UIColor.grayBlue : .baseGray
        cell.configure(portfolio: viewModel.data[indexPath.item], color: color)
        cell.delegate = self
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        PortfolioFormViewModel.shared.portfolio = viewModel.data[indexPath.item]
//        openPortfolioForm()
//    }
}

extension PortfolioViewController: PortfolioCollectionViewCellDelegate {
    func selectItem(cell: UICollectionViewCell) {
        if let index = portfolioCollectionView.indexPath(for: cell) {
            PortfolioFormViewModel.shared.portfolio = viewModel.data[index.item]
            openPortfolioForm()
        }
    }
}
