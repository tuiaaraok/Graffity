//
//  ShoppingFormViewModel.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import Foundation

class ShoppingFormViewModel {
    static let shared = ShoppingFormViewModel()
    @Published var shoppings: [ShoppingModel] = [ShoppingModel(id: UUID())]
    var previousShoppingsCount: Int = 0
    private init() {}
    
    func addShopping() {
        shoppings.append(ShoppingModel(id: UUID()))
    }
    
    func save(completion: @escaping (Error?) -> Void) {
        shoppings.removeAll(where: { !$0.name.checkValidation() })
        CoreDataManager.shared.saveShoppings(shoppingsModel: shoppings, completion: completion)
    }
    
    func clear() {
        shoppings = [ShoppingModel(id: UUID())]
        previousShoppingsCount = 0
    }
}
