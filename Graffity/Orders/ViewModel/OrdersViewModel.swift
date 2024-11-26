//
//  OrdersViewModel.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import Foundation

class OrdersViewModel {
    static let shared = OrdersViewModel()
    private var data: [OrderModel] = []
    @Published var orders: [OrderModel] = []
    @Published var type = 0
    private init() {}
    
    func fetchOrders() {
        CoreDataManager.shared.fetchOrders { [weak self] orders, _ in
            guard let self = self else { return }
            self.data = orders
            
        }
    }
    
    func filterByType(type: Int) {
        self.type = type
    }
}
