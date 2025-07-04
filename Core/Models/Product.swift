//
//  Product.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 3.07.2025.
//
// Core/Models/Product.swift

import Foundation

struct Product: Codable, Hashable {
    let id: String
    let title: String?
    let imageUrl: String?
    let price: Double?
    let originalPrice: Double?
    let rating: Double?
    let reviewCount: Int?
    let isFreeShipping: Bool?
    let hasPriceReductionBadge: Bool?
    let hasN11Badge: Bool?
    let hasSepettePrice: Bool?
    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case title, imageUrl, price, originalPrice, rating, reviewCount
        case isFreeShipping, hasPriceReductionBadge, hasN11Badge, hasSepettePrice
    }
}
