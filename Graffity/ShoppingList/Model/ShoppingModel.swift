//
//  ShoppingModel.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import Foundation

struct ShoppingModel {
    var id: UUID
    var name: String?
    var price: Double?
    var isCompleted: Bool = false
}
