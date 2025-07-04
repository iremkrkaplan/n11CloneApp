//
//  FavoriteProductCell.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 3.07.2025.
//
// Features/Favorites/Cells/FavoriteProductCell.swift

import UIKit
import Kingfisher

class FavoriteProductCell: UICollectionViewCell {
    static let identifier = "FavoriteProductCell"

    var onRemoveFromFavorites: (() -> Void)?

    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()

    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        return label
    }()

    private let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        return stack
    }()

    private let ratingCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        return label
    }()

    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.borderWidth = 1
        
        let priceLineStack = UIStackView(arrangedSubviews: [priceLabel, originalPriceLabel])
        priceLineStack.spacing = 8
        priceLineStack.alignment = .lastBaseline
        
        let ratingLineStack = UIStackView(arrangedSubviews: [ratingStackView, ratingCountLabel])
        ratingLineStack.spacing = 4
        ratingLineStack.alignment = .center

        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(priceLineStack)
        infoStackView.addArrangedSubview(ratingLineStack)
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        infoStackView.addArrangedSubview(spacer)

        contentView.addSubview(productImageView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(removeButton)

        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),

            infoStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            infoStackView.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -8),
            
            removeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            removeButton.widthAnchor.constraint(equalToConstant: 30),
            removeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }


    @objc private func removeButtonTapped() {
        onRemoveFromFavorites?()
    }

    func configure(with product: Product) {
        titleLabel.text = product.title
        
        if let urlString = product.primaryImageURL, let url = URL(string: urlString) {
            productImageView.kf.indicatorType = .activity
            productImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        } else {
            productImageView.image = UIImage(systemName: "photo")
        }
        
        configurePrice(for: product)
        configureRating(for: product)
    }

    private func configurePrice(for product: Product) {
        originalPriceLabel.isHidden = true
        originalPriceLabel.attributedText = nil
        priceLabel.text = nil

        if let price = product.price {
            priceLabel.text = String(format: "%.2f TL", price)
        }
        
        if let originalPrice = product.originalPrice, let currentPrice = product.price, originalPrice > currentPrice {
            let attributedString = NSAttributedString(string: String(format: "%.2f TL", originalPrice), attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            originalPriceLabel.attributedText = attributedString
            originalPriceLabel.isHidden = false
        }
    }

    private func configureRating(for product: Product) {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        ratingCountLabel.text = nil
        ratingStackView.isHidden = true
        
        guard let rate = product.rating, rate > 0 else { return }
        
        ratingStackView.isHidden = false
        
        if let reviewCount = product.reviewCount, reviewCount > 0 {
            ratingCountLabel.text = "(\(reviewCount))"
        }
        
        let fullStars = Int(floor(rate))
        let hasHalfStar = (rate - Double(fullStars)) >= 0.5
        
        for _ in 0..<fullStars { addStar(systemName: "star.fill") }
        if hasHalfStar { addStar(systemName: "star.leadinghalf.fill") }
        let remainingStars = 5 - fullStars - (hasHalfStar ? 1 : 0)
        if remainingStars > 0 {
            for _ in 0..<remainingStars { addStar(systemName: "star") }
        }
    }
    
    private func addStar(systemName: String) {
        let iv = UIImageView(image: UIImage(systemName: systemName))
        iv.tintColor = .systemYellow
        iv.contentMode = .scaleAspectFit
        iv.heightAnchor.constraint(equalToConstant: 14).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 14).isActive = true
        ratingStackView.addArrangedSubview(iv)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.kf.cancelDownloadTask()
        productImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        originalPriceLabel.attributedText = nil
        ratingCountLabel.text = nil
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        onRemoveFromFavorites = nil
    }
}
