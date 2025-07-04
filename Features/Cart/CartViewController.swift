//
//  CartViewController.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 2.07.2025.
//
// Features/Cart/CartViewController.swift

import UIKit

class CartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemTeal
        title = "Sepetim"
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Sepetim"
        placeholderLabel.textColor = .label
        placeholderLabel.textAlignment = .center
        placeholderLabel.font = .systemFont(ofSize: 24, weight: .bold)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

}
