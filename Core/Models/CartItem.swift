//
//  CartItem.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 5.07.2025.
//

import Foundation
import FirebaseFirestore

struct CartItem: Codable, Identifiable {
    @DocumentID var id: String?

    let userId: String
    let productId: String
    var quantity: Int
    let title: String
    let price: Double
    let originalPrice: Double?
    let imageUrl: String?
    @ServerTimestamp var timestamp: Date?
     init?(product: Product, userId: String) {
         guard let price = product.price else {
             print("Warning: Product '\(product.id)' has no price, cannot create CartItem.")
             return nil
         }

         self.id = "\(userId)_\(product.id)"
         self.userId = userId
         self.productId = product.id
         self.quantity = 1
         self.title = product.title ?? "Unknown Product Title"
         self.price = price
         self.originalPrice = product.originalPrice
         self.imageUrl = product.primaryImageURL
         self.timestamp = nil
     }

}
