//
//  AnalyticsViewModel.swift
//  Graffity
//
//  Created by Karen Khachatryan on 27.11.24.
//

import Foundation

class AnalyticsViewModel {
    static let shared = AnalyticsViewModel()
    @Published var analyticsModel = AnalyticsModel()
    private var orders: [OrderModel] = []
    private var shoppings: [ShoppingModel] = []
    private var period = 0
    private init() {}
    
    func fetchData() {
        var count = 0
        CoreDataManager.shared.fetchOrders { [weak self] data, _ in
            guard let self = self else { return }
            let orders = data.filter({ $0.isCompleted })
            analyticsModel.orders = orders.count
            analyticsModel.income = orders.reduce(0.0, { partialResult, order in
                partialResult + (order.price ?? 0)
            })
            self.orders = orders
            count += 1
            if count == 2 {
                self.filterByPeriod(period: self.period)
//                completion(analyticsModel)
            }
        }
        
        CoreDataManager.shared.fetchShoppings { [weak self] data, _ in
            guard let self = self else { return }
            let shoppings = data.filter({ $0.isCompleted })
            analyticsModel.expenditure = shoppings.reduce(0.0, { $0 + ($1.price ?? 0)})
            self.shoppings = shoppings
            count += 1
            if count == 2 {
                self.filterByPeriod(period: self.period)
//                completion(analyticsModel)
            }
        }
    }
    
    func filterByPeriod(period: Int) {
        self.period = period
        var orders: [OrderModel] = []
        var shoppings: [ShoppingModel] = []
        
        if period == 0 {
            orders = filterOrdersByMonth()
            shoppings = filterShoppingsByMonth()
        } else {
            orders = filterOrdersByYear()
            shoppings = filterShoppingsByYear()
        }
        let income = orders.reduce(0.0, { partialResult, order in
            partialResult + (order.price ?? 0)
        })
        
        let expenditure = shoppings.reduce(0.0, { $0 + ($1.price ?? 0)})
        self.analyticsModel = AnalyticsModel(orders: orders.count, income: income, expenditure: expenditure)
    }
    
    func filterOrdersByMonth() -> [OrderModel] {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let rangeOfMonth = calendar.range(of: .day, in: .month, for: now)!
        let endOfMonth = calendar.date(byAdding: .day, value: rangeOfMonth.count - 1, to: startOfMonth)!
        return orders.filter { order in
            if let orderDate = order.date {
                return orderDate >= startOfMonth && orderDate <= endOfMonth
            }
            return false
        }
    }
    
    func filterShoppingsByMonth() -> [ShoppingModel] {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let rangeOfMonth = calendar.range(of: .day, in: .month, for: now)!
        let endOfMonth = calendar.date(byAdding: .day, value: rangeOfMonth.count - 1, to: startOfMonth)!
        return shoppings.filter { shopping in
            return shopping.date >= startOfMonth && shopping.date <= endOfMonth
        }
    }
    
    func filterOrdersByYear() -> [OrderModel] {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        return orders.filter { order in
            if let orderDate = order.date {
                let orderYear = calendar.component(.year, from: orderDate)
                return orderYear == currentYear
            }
            return false
        }
    }
    
    func filterShoppingsByYear() -> [ShoppingModel] {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        return shoppings.filter { shopping in
            let shoppingYear = calendar.component(.year, from: shopping.date)
            return shoppingYear == currentYear
        }
    }
    
    func clear() {
        analyticsModel = AnalyticsModel()
        period = 0
        orders = []
        shoppings = []
    }
}
