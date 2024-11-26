//
//  ShoppingListViewModel.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import Foundation

class ShoppingListViewModel {
    static let shared = ShoppingListViewModel()
    @Published var shoppings: [ShoppingModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchShoppings { [weak self] shoppings, _ in
            guard let self = self else { return }
            self.shoppings = shoppings
        }
    }
    
    func confirmShopping(id: UUID, isCompleted: Bool, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.confirmShopping(id: id, isCompleted: isCompleted, completion: completion)
    }
}
