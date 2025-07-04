
//  Product.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 3.07.2025.
//

import Foundation

struct Product: Codable {

    let id: String
    let title: String?
    let price: Double?
    let originalPrice: Double?
    let rating: Double?
    let reviewCount: Int?
    let isFreeShipping: Bool?
    let hasPriceReductionBadge: Bool?
    let hasN11Badge: Bool?
    let hasSepettePrice: Bool?

    let imageURL: [String]?
    let category: String?
    let description: String?
    let seller: String?

    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case imageURL = "imageUrl"

        case title, price, originalPrice, rating, reviewCount, isFreeShipping
        case hasPriceReductionBadge, hasN11Badge, hasSepettePrice
        case category, description, seller
    }

    var formattedPrice: String {
        guard let price = price else { return "Fiyat Bilgisi Yok" }
        return String(format: "%.0f TL", price)
    }

    var ratingText: String {
        guard let rating = rating else { return "Yorumsuz" }
        return String(format: "%.1f", rating)
    }

    var reviewCountText: String {
        guard let reviewCount = reviewCount else { return "Henüz Yorum Yok" }
        return "\(reviewCount) Yorum"
    }

    var primaryImageURL: String? {
        return imageURL?.first
    }
}

extension Product: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
