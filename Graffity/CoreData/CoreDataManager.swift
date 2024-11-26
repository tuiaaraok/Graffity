//
//  CoreDataManager.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//


import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Graffity")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveOrder(orderModel: OrderModel, completion: @escaping (Error?) -> Void) {
        let id = orderModel.id
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let order: Order
                
                if let existingOrder = results.first {
                    order = existingOrder
                } else {
                    order = Order(context: backgroundContext)
                    order.id = id
                }
                    
                order.name = orderModel.name
                order.date = orderModel.date
                order.price = orderModel.price ?? 0
                order.info = orderModel.info
                order.location = orderModel.location
                order.photos = orderModel.photos
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchOrders(completion: @escaping ([OrderModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var ordersModel: [OrderModel] = []
                for result in results {
                    let orderModel = OrderModel(id: result.id ?? UUID(), name: result.name, date: result.date, price: result.price, location: result.location, info: result.info, photos: result.photos ?? [], isCompleted: result.isCompleted)
                    ordersModel.append(orderModel)
                }
                DispatchQueue.main.async {
                    completion(ordersModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func savePortfolio(portfolioModel: PortfolioModel, completion: @escaping (Error?) -> Void) {
        let id = portfolioModel.id
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let portfolio: Portfolio
                
                if let existingPortfolio = results.first {
                    portfolio = existingPortfolio
                } else {
                    portfolio = Portfolio(context: backgroundContext)
                    portfolio.id = id
                }
                    
                portfolio.info = portfolioModel.info
                portfolio.photos = portfolioModel.photos
                
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func confirmOrder(id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let order = results.first {
                    order.isCompleted = true
                } else {
                    completion(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Order not found"]))
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchPortfolio(completion: @escaping ([PortfolioModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var portfolioModels: [PortfolioModel] = []
                for result in results {
                    let portfolioModel = PortfolioModel(id: result.id ?? UUID(), photos: result.photos ?? [], info: result.info)
                    portfolioModels.append(portfolioModel)
                }
                DispatchQueue.main.async {
                    completion(portfolioModels, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
//    func saveShopping(shoppingModel: ShoppingModel, completion: @escaping (Error?) -> Void) {
//        let id = shoppingModel.id
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Shopping> = Shopping.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                let shopping: Shopping
//                
//                if let existingShopping = results.first {
//                    shopping = existingShopping
//                } else {
//                    shopping = Shopping(context: backgroundContext)
//                    shopping.id = id
//                }
//                    
//                shopping.name = shoppingModel.name
//                shopping.price = shoppingModel.price ?? 0
//                shopping.isCompleted = shoppingModel.isCompleted
//                
//                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
    
    func saveShoppings(shoppingsModel: [ShoppingModel], completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            do {
                for shoppingModel in shoppingsModel {
                    let fetchRequest: NSFetchRequest<Shopping> = Shopping.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %@", shoppingModel.id as CVarArg)
                    
                    let results = try backgroundContext.fetch(fetchRequest)
                    let shopping: Shopping
                    
                    if let existingShopping = results.first {
                        shopping = existingShopping
                    } else {
                        shopping = Shopping(context: backgroundContext)
                        shopping.id = shoppingModel.id
                    }
                    
                    shopping.name = shoppingModel.name
                    shopping.price = shoppingModel.price ?? 0
                    shopping.isCompleted = shoppingModel.isCompleted
                }
                
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

    
    func fetchShoppings(completion: @escaping ([ShoppingModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Shopping> = Shopping.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var shoppingsModel: [ShoppingModel] = []
                for result in results {
                    let shoppingModel = ShoppingModel(id: result.id ?? UUID(), name: result.name, price: result.price, isCompleted: result.isCompleted)
                    shoppingsModel.append(shoppingModel)
                }
                DispatchQueue.main.async {
                    completion(shoppingsModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func confirmShopping(id: UUID, isCompleted: Bool, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Shopping> = Shopping.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let shopping = results.first {
                    shopping.isCompleted = isCompleted
                } else {
                    completion(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Order not found"]))
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

}

