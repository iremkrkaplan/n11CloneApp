//
//  CustomSearchBar.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 3.07.2025.
//

import UIKit

class CustomSearchBar: UISearchBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchBar()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSearchBar()
    }

    private func setupSearchBar() {
        placeholder = "Ürün, kategori, marka ara"
        searchBarStyle = .minimal
        translatesAutoresizingMaskIntoConstraints = false

        let borderColor = UIColor(red: 0.5, green: 0.1, blue: 0.9, alpha: 1.0).cgColor
        layer.borderColor = borderColor
        layer.borderWidth = 1.5
        layer.cornerRadius = 20
        clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.05
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        if let textField = value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.layer.cornerRadius = 18
            textField.clipsToBounds = true
            textField.textColor = .black
            textField.textAlignment = .left

            textField.attributedPlaceholder = NSAttributedString(
                string: "Ürün, kategori, marka ara",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.gray,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)
                ]
            )

            if let glassIconView = textField.leftView as? UIImageView {
                glassIconView.tintColor = UIColor(red: 0.5, green: 0.1, blue: 0.9, alpha: 1.0)
            }
        }
        tintColor = UIColor(red: 0.5, green: 0.1, blue: 0.9, alpha: 1.0)
    }
}
