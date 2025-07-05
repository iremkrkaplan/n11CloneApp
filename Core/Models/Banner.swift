//
//  Banner.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 5.07.2025.
//

import Foundation

struct Banner: Codable {
    let id: String
    let title: String
    let subtitle: String
    let imageUrl: String
    let backgroundColor: String
    let textColor: String
    let actionUrl: String?
}
