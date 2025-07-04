//
//  SponsoredProductsHeaderView.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 3.07.2025.
//
// Features/Home/Cells/SponsoredProductsHeaderView.swift
// Features/Home/Cells/SponsoredProductsHeaderView.swift

import UIKit

class SponsoredProductsHeaderView: UICollectionReusableView {
    static let identifier = "SponsoredProductsHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Bu ürünleri gördünüz mü?"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    private let infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, infoButton])
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            infoButton.widthAnchor.constraint(equalToConstant: 22),
            infoButton.heightAnchor.constraint(equalToConstant: 22),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
