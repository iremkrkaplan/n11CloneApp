//
//  CartItemCell.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 5.07.2025.
//

import UIKit
import Kingfisher

class CartItemCell: UITableViewCell {
    static let identifier = "CartItemCell"

    var onQuantityChange: ((Int) -> Void)?
    var onRemove: (() -> Void)?

    private var currentCartItem: CartItem?

    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 4
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        return button
    }()

    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .n11Purple
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()

    let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return button
    }()

    // Stack view for quantity controls
    private let quantityStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(quantityStackView)
        contentView.addSubview(removeButton)

        quantityStackView.addArrangedSubview(minusButton)
        quantityStackView.addArrangedSubview(quantityLabel)
        quantityStackView.addArrangedSubview(plusButton)

        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            productImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),
            titleLabel.topAnchor.constraint(equalTo: productImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -8),

            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            quantityStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            quantityStackView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            quantityStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            quantityStackView.heightAnchor.constraint(equalToConstant: 24),

            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            removeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            removeButton.widthAnchor.constraint(equalToConstant: 30),
            removeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func configure(with cartItem: CartItem) {
        self.currentCartItem = cartItem

        titleLabel.text = cartItem.title
        priceLabel.text = "\(cartItem.price) TL"
        quantityLabel.text = "\(cartItem.quantity)"
        
        if let urlString = cartItem.imageUrl, let url = URL(string: urlString) {
            productImageView.kf.indicatorType = .activity
            productImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        } else {
            productImageView.image = UIImage(systemName: "photo")
        }

        minusButton.isEnabled = cartItem.quantity > 1
        minusButton.tintColor = cartItem.quantity > 1 ? .gray : .systemGray4
    }

    @objc private func minusButtonTapped() {
        guard let item = currentCartItem else { return }
        onQuantityChange?(item.quantity - 1)
    }

    @objc private func plusButtonTapped() {
        guard let item = currentCartItem else { return }
        onQuantityChange?(item.quantity + 1)
    }

    @objc private func removeButtonTapped() {
        onRemove?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.kf.cancelDownloadTask()
        productImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        quantityLabel.text = nil
        currentCartItem = nil
        minusButton.isEnabled = true
        minusButton.tintColor = .gray
        plusButton.isEnabled = true
        plusButton.tintColor = .n11Purple
        removeButton.isEnabled = true
        removeButton.tintColor = .systemRed
        onQuantityChange = nil
        onRemove = nil
    }
}
