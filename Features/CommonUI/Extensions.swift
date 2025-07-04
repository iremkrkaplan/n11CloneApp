//
//  Extensions.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 3.07.2025.
//


import UIKit

extension UIView {
}

extension UIButton {
    func setFavoriteState(isFavorite: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let imageName = isFavorite ? "heart.fill" : "heart"
        setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
        tintColor = isFavorite ? .n11Purple : .systemGray
    }
}
