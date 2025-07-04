// Features/Home/Cells/SponsoredProductCell.swift

import UIKit
import Kingfisher

class SponsoredProductCell: UICollectionViewCell {
    
    static let identifier = "SponsoredProductCell"

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .white
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()

    private let discountBadge: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 4
        
        let label = UILabel()
        label.tag = 1
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 2),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4)
        ])
        return view
    }()
    
    private let oldPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .lightGray
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        return stack
    }()

    private let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        return stack
    }()

    private let ratingCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .gray
        return label
    }()

    private let fullRatingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let extraDiscountLabel: UILabel = {
        let label = UILabel()
        let boltImage = UIImage(systemName: "bolt.fill")
        let attachment = NSTextAttachment(image: boltImage!)
        attachment.bounds = CGRect(x: 0, y: -2, width: 10, height: 12)
        
        let attributedString = NSMutableAttributedString(attachment: attachment)
        attributedString.append(NSAttributedString(string: " Sepette Ek İndirim", attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .medium),
            .foregroundColor: UIColor.systemBlue
        ]))
        
        label.attributedText = attributedString
        return label
    }()
    
    private let freeShippingLabel: UILabel = {
        let label = UILabel()
        label.text = "Ücretsiz Kargo"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .darkGray
        return label
    }()

    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        return stack
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .top
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

    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        priceStackView.addArrangedSubview(discountBadge)
        priceStackView.addArrangedSubview(oldPriceLabel)
        priceStackView.addArrangedSubview(priceLabel)
        
        fullRatingStackView.addArrangedSubview(ratingStackView)
        fullRatingStackView.addArrangedSubview(ratingCountLabel)
        
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(priceStackView)
        infoStackView.addArrangedSubview(extraDiscountLabel)
        infoStackView.addArrangedSubview(fullRatingStackView)
        infoStackView.addArrangedSubview(freeShippingLabel)
        
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(infoStackView)
        
        contentView.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            imageView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.35),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.2)
        ])
    }

    func configure(with product: Product) {
        titleLabel.text = product.title
        
        if let urlString = product.imageUrl, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        }
        
        configurePrice(for: product)
        configureRating(for: product)
        
        freeShippingLabel.isHidden = !(product.isFreeShipping ?? false)
        extraDiscountLabel.isHidden = !(product.hasSepettePrice ?? false)
    }
    
    private func configurePrice(for product: Product) {
        [discountBadge, oldPriceLabel, priceLabel].forEach { $0.isHidden = true }
        
        guard let currentPrice = product.price else { return }
        
        priceLabel.text = String(format: "%.2f TL", currentPrice)
        priceLabel.isHidden = false
        
        if let original = product.originalPrice, original > currentPrice {
            oldPriceLabel.isHidden = false
            let attributedString = NSAttributedString(
                string: String(format: "%.2f TL", original),
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            oldPriceLabel.attributedText = attributedString
            
            discountBadge.isHidden = false
            if let label = discountBadge.viewWithTag(1) as? UILabel {
                let percentage = Int(((original - currentPrice) / original) * 100)
                label.text = "%\(percentage)"
            }
        }
    }
    
    private func configureRating(for product: Product) {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        fullRatingStackView.isHidden = true
        
        guard let rate = product.rating, rate > 0, let reviewCount = product.reviewCount, reviewCount > 0 else {
            return
        }
        fullRatingStackView.isHidden = false
        ratingCountLabel.text = "(\(reviewCount))"
        
        let fullStars = Int(rate)
        for _ in 0..<fullStars { addStar(systemName: "star.fill") }
        let remaining = 5 - fullStars
        if remaining > 0 {
            for _ in 0..<remaining { addStar(systemName: "star") }
        }
    }
    
    private func addStar(systemName: String) {
        let starImageView = UIImageView(image: UIImage(systemName: systemName))
        starImageView.tintColor = .systemYellow
        ratingStackView.addArrangedSubview(starImageView)
        NSLayoutConstraint.activate([
            starImageView.widthAnchor.constraint(equalToConstant: 14),
            starImageView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        titleLabel.text = nil
        oldPriceLabel.attributedText = nil
        priceLabel.text = nil
        ratingCountLabel.text = nil
        
        [discountBadge, oldPriceLabel, priceLabel, fullRatingStackView, extraDiscountLabel, freeShippingLabel].forEach { $0.isHidden = true }
    }
}
