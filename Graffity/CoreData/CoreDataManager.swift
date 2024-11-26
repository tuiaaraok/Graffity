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
    
//    func removeProduct(by id: UUID, completion: @escaping (Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                if let productToDelete = results.first {
//                    backgroundContext.delete(productToDelete)
//                    try backgroundContext.save()
//                    DispatchQueue.main.async {
//                        completion(nil)
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        completion(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found"]))
//                    }
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }

}

