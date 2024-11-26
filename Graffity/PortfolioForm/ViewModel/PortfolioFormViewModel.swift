//
//  PortfolioFormViewModel.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import UIKit

class PortfolioFormViewModel {
    static let shared = PortfolioFormViewModel()
    @Published var portfolio = PortfolioModel(id: UUID(), photos: [UIImage.imagePlaceholder.pngData() ?? Data()])
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.savePortfolio(portfolioModel: portfolio, completion: completion)
    }
    
    func addImage(data: Data) {
        if portfolio.photos.first == UIImage.imagePlaceholder.pngData() {
            portfolio.photos.removeAll()
        }
        portfolio.photos.append(data)
    }
    
    func clear() {
        portfolio = PortfolioModel(id: UUID(), photos: [UIImage.imagePlaceholder.pngData() ?? Data()])
    }
}
