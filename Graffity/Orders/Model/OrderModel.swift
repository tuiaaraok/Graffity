//
//  OrderModel.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import Foundation

struct OrderModel {
    var id: UUID
    var name: String?
    var date: Date?
    var price: Double?
    var location: String?
    var info: String?
    var photos: [Data] = []
    var isCompleted = false
}
