//
//  PortfolioViewModel.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import Foundation

class PortfolioViewModel {
    static let shared = PortfolioViewModel()
    @Published var data: [PortfolioModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchPortfolio { [weak self] portfolio, _ in
            guard let self = self else { return }
            self.data = portfolio
        }
    }
}
