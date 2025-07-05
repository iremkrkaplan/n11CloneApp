// Features/Home/Cells/NormalProductCell.swift

import UIKit
import Kingfisher
class NormalProductCell: UICollectionViewCell {
    static let identifier = "NormalProductCell"

    var favoriteButtonAction: (() -> Void)?


    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.backgroundColor = .systemGray6
        return imageView
    }()

    let n11BadgeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightPurple
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    let n11BadgeLabel: UILabel = {
        let label = UILabel()
        label.text = "n11'in\nTEKLIFI"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 8, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()

    let freeShippingLabel: UILabel = {
        let label = UILabel()
        label.text = "ÜCRETSİZ KARGO"
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor.lightPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let ratingCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ratingInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    }()

    let priceReductionBannerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.95, green: 0.9, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        let arrowImageView = UIImageView(image: UIImage(systemName: "arrow.down"))
        arrowImageView.tintColor = UIColor.lightPurple
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "30 günün en düşük fiyatı!"
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = UIColor.lightPurple
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(arrowImageView)
        view.addSubview(label)

        NSLayoutConstraint.activate([
            arrowImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            arrowImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 12),
            arrowImageView.heightAnchor.constraint(equalToConstant: 12),

            label.leadingAnchor.constraint(equalTo: arrowImageView.trailingAnchor, constant: 4),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6)
        ])

        return view
    }()
    let oldPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    let sepetteLabel: UILabel = {
        let label = UILabel()
        label.text = "SEPETTE"
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor.lightPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = UIColor(red: 0.3, green: 0.1, blue: 0.5, alpha: 1.0)
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.lightPurple.cgColor
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fill
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func favoriteButtonTapped() {
        favoriteButtonAction?()
    }

    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 3
        layer.masksToBounds = false
        
        contentView.addSubview(imageView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(addToCartButton)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(n11BadgeView)
        n11BadgeView.addSubview(n11BadgeLabel)
        
        infoStackView.addArrangedSubview(freeShippingLabel)
        infoStackView.addArrangedSubview(titleLabel)

        ratingInfoStackView.addArrangedSubview(ratingStackView)
        ratingInfoStackView.addArrangedSubview(ratingCountLabel)
        infoStackView.addArrangedSubview(ratingInfoStackView)

        infoStackView.addArrangedSubview(priceReductionBannerView)
        infoStackView.addArrangedSubview(sepetteLabel)
        infoStackView.addArrangedSubview(oldPriceLabel)
        infoStackView.addArrangedSubview(priceLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            infoStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48),
            infoStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),

            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: titleLabel.font.lineHeight * 2),

             priceReductionBannerView.leadingAnchor.constraint(equalTo: infoStackView.leadingAnchor),             priceReductionBannerView.trailingAnchor.constraint(equalTo: infoStackView.trailingAnchor),
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            n11BadgeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            n11BadgeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            n11BadgeView.widthAnchor.constraint(equalToConstant: 40),
            n11BadgeView.heightAnchor.constraint(equalToConstant: 40),
            n11BadgeLabel.centerXAnchor.constraint(equalTo: n11BadgeView.centerXAnchor),
            n11BadgeLabel.centerYAnchor.constraint(equalTo: n11BadgeView.centerYAnchor),

            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            addToCartButton.widthAnchor.constraint(equalToConstant: 30),
            addToCartButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    func configure(with product: Product, isFavorited: Bool) {
        titleLabel.text = product.title

        let heartImage = isFavorited ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        let heartColor: UIColor = isFavorited ? .systemRed : .systemGray
        favoriteButton.setImage(heartImage, for: .normal)
        favoriteButton.tintColor = heartColor

        if let urlString = product.primaryImageURL, let url = URL(string: urlString) {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        } else {
            imageView.image = UIImage(systemName: "photo")
        }

        freeShippingLabel.isHidden = !(product.isFreeShipping ?? false)
        n11BadgeView.isHidden = !(product.hasN11Badge ?? false)
        priceReductionBannerView.isHidden = !(product.hasPriceReductionBadge ?? false)
        configurePrice(for: product)
        configureRating(for: product)

        setNeedsLayout()
        layoutIfNeeded()
    }

    private func configurePrice(for product: Product) {
        oldPriceLabel.isHidden = true
        sepetteLabel.isHidden = true
        priceLabel.isHidden = true
        oldPriceLabel.attributedText = nil

        let discountedPrice = product.price
        let originalPrice = product.originalPrice
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        let formattedOriginalPrice = originalPrice.flatMap { formatter.string(from: NSNumber(value: $0)) }
        let formattedDiscountedPrice = discountedPrice.flatMap { formatter.string(from: NSNumber(value: $0)) }

        if let discountedPriceValue = discountedPrice, let originalPriceValue = originalPrice, discountedPriceValue < originalPriceValue, let originalPriceText = formattedOriginalPrice, let discountedPriceText = formattedDiscountedPrice {

            let attributeString = NSMutableAttributedString(string: "\(originalPriceText) TL")
            attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 11, weight: .regular), range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSMakeRange(0, attributeString.length))
            
            oldPriceLabel.attributedText = attributeString
            oldPriceLabel.isHidden = false
            priceLabel.text = "\(discountedPriceText) TL"
            priceLabel.font = .systemFont(ofSize: 15, weight: .bold)
            priceLabel.textColor = .black
            priceLabel.isHidden = false
            if product.hasSepettePrice ?? false {
                 sepetteLabel.isHidden = false
             } else {
                 sepetteLabel.isHidden = true
             }


        } else if let priceValue = product.price, let priceText = formattedDiscountedPrice {
            priceLabel.text = "\(priceText) TL"
            priceLabel.font = .systemFont(ofSize: 15, weight: .bold)
            priceLabel.textColor = .black
            priceLabel.isHidden = false

            if product.hasSepettePrice ?? false {
                sepetteLabel.isHidden = false
            } else {
                sepetteLabel.isHidden = true
            }
        }
         if priceLabel.isHidden {
             sepetteLabel.isHidden = true
         }
    }
    private func configureRating(for product: Product) {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        ratingInfoStackView.isHidden = true
        guard let rate = product.rating, rate > 0, let reviewCount = product.reviewCount, reviewCount > 0 else {
            return
        }

        ratingInfoStackView.isHidden = false
        ratingCountLabel.text = "(\(reviewCount))"

        let fullStars = Int(rate)
        let hasHalfStar = (rate - Double(fullStars)) >= 0.5

        for i in 0..<5 {
            let starImageView = UIImageView()
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.contentMode = .scaleAspectFit
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true

            if i < fullStars {
                starImageView.image = UIImage(systemName: "star.fill")
                starImageView.tintColor = .systemYellow
            } else if i == fullStars && hasHalfStar {
                 starImageView.image = UIImage(systemName: "star.leadinghalf.fill")
                 starImageView.tintColor = .systemYellow
            } else {
                starImageView.image = UIImage(systemName: "star")
                starImageView.tintColor = .systemGray3
            }
             ratingStackView.addArrangedSubview(starImageView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        titleLabel.text = nil
        oldPriceLabel.attributedText = nil
        priceLabel.text = nil
        ratingCountLabel.text = nil

        [freeShippingLabel, oldPriceLabel, sepetteLabel, priceLabel, ratingInfoStackView, priceReductionBannerView, n11BadgeView].forEach { $0.isHidden = true }

        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .systemGray
    }
}
