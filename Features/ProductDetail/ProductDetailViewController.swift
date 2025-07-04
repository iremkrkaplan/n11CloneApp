// Features/ProductDetail/ProductDetailViewController.swift

import UIKit
import Kingfisher

class ProductDetailViewController: UIViewController {

    var product: Product? {
        didSet {
            if isViewLoaded {
                configureWithProduct()
            }
        }
    }
    
    private var isFavorited: Bool = false
    private let favoritesManager = FavoritesManager.shared
    
    private let scrollView = UIScrollView()
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        return stack
    }()
    
    private let imageContainerView = UIView()
    private lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .systemBackground
        cv.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .systemPurple
        pc.pageIndicatorTintColor = .systemGray4
        return pc
    }()

    private let n11BadgeView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "n11BadgeView"))
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    private let ratingView = RatingInfoView()
    
    private let bottomActionBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let priceInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sepete Ekle", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        return button
    }()

    private lazy var favoriteBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoriteButtonTapped))
    private lazy var shareBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
    private lazy var cartBarButtonItem: UIBarButtonItem = {
        let button = BadgedButton(type: .system)
        button.setImage(UIImage(systemName: "cart"), for: .normal)
        button.badgeValue = "2"
        return UIBarButtonItem(customView: button)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupUI()
        
        if product != nil {
            configureWithProduct()
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .darkGray

        navigationItem.rightBarButtonItems = [favoriteBarButtonItem, shareBarButtonItem, cartBarButtonItem]
    }
    
    private func setupUI() {
        [scrollView, contentStackView, imageContainerView, imagesCollectionView, pageControl, n11BadgeView, titleLabel, ratingView, bottomActionBar, priceInfoLabel, addToCartButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        view.addSubview(scrollView)
        view.addSubview(bottomActionBar)
        scrollView.addSubview(contentStackView)

        bottomActionBar.addSubview(priceInfoLabel)
        bottomActionBar.addSubview(addToCartButton)
        
        imageContainerView.addSubview(imagesCollectionView)
        imageContainerView.addSubview(pageControl)
        imageContainerView.addSubview(n11BadgeView)

        contentStackView.addArrangedSubview(imageContainerView)
        let infoContainerView = UIView() // Başlık ve rating için padding view'i
        infoContainerView.addSubview(titleLabel)
        infoContainerView.addSubview(ratingView)
        contentStackView.addArrangedSubview(infoContainerView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomActionBar.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            bottomActionBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomActionBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomActionBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomActionBar.heightAnchor.constraint(equalToConstant: 90),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            imageContainerView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.1),
            imagesCollectionView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imagesCollectionView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            imagesCollectionView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            
            pageControl.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -8),
            pageControl.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            
            n11BadgeView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 16),
            n11BadgeView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 16),
            n11BadgeView.widthAnchor.constraint(equalToConstant: 60),
            n11BadgeView.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.topAnchor.constraint(equalTo: infoContainerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            
            ratingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            ratingView.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            ratingView.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor),
            
            priceInfoLabel.leadingAnchor.constraint(equalTo: bottomActionBar.leadingAnchor, constant: 16),
            priceInfoLabel.centerYAnchor.constraint(equalTo: bottomActionBar.centerYAnchor),
            
            addToCartButton.trailingAnchor.constraint(equalTo: bottomActionBar.trailingAnchor, constant: -16),
            addToCartButton.centerYAnchor.constraint(equalTo: bottomActionBar.centerYAnchor),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50),
            addToCartButton.leadingAnchor.constraint(equalTo: priceInfoLabel.trailingAnchor, constant: 16),
            addToCartButton.widthAnchor.constraint(equalTo: bottomActionBar.widthAnchor, multiplier: 0.4),
        ])
    }
    
    private func configureWithProduct() {
        guard let product = product else {
            self.titleLabel.text = "Ürün bilgisi bulunamadı."
            return
        }
        
        self.navigationItem.title = product.title
        
        self.titleLabel.text = product.title
        ratingView.configure(rating: product.rating, reviewCount: product.reviewCount)
        
        configureBottomPriceLabel(for: product)

        n11BadgeView.isHidden = !(product.hasN11Badge ?? false)

        imagesCollectionView.reloadData()
    
        pageControl.numberOfPages = 1
        pageControl.isHidden = pageControl.numberOfPages <= 1

        checkFavoriteStatus()
    }
    
    private func configureBottomPriceLabel(for product: Product) {
        let finalPriceString = String(format: "%.2f TL", product.price ?? 0.0)
        let attributedText = NSMutableAttributedString()

        if let originalPrice = product.originalPrice, let currentPrice = product.price, originalPrice > currentPrice {
            let oldPriceString = String(format: "%.2f TL", originalPrice)
            let sepetText = NSAttributedString(
                string: "SEPETTE\n",
                attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.systemGray]
            )
            let oldPriceAttributed = NSAttributedString(
                string: oldPriceString,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14),
                    .foregroundColor: UIColor.systemGray,
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ]
            )
            attributedText.append(sepetText)
            attributedText.append(oldPriceAttributed)
            attributedText.append(NSAttributedString(string: "\n"))
        }
        
        let finalPriceAttributed = NSAttributedString(
            string: finalPriceString,
            attributes: [.font: UIFont.systemFont(ofSize: 22, weight: .bold), .foregroundColor: UIColor.label]
        )
        attributedText.append(finalPriceAttributed)
        
        priceInfoLabel.attributedText = attributedText
    }

    
    private func checkFavoriteStatus() {
        guard let productId = product?.id else { return }
        updateFavoriteButtonAppearance()
    }
    
    @objc private func favoriteButtonTapped() {
        guard let product = product else { return }
        isFavorited.toggle()
        
        let completion: (Error?) -> Void = { [weak self] error in
            if error != nil {
                self?.isFavorited.toggle()
            }
        }
        
        if isFavorited {
            favoritesManager.add(product: product, completion: completion)
        } else {
            favoritesManager.remove(productID: product.id, completion: completion)
        }
        updateFavoriteButtonAppearance()
    }
    
    private func updateFavoriteButtonAppearance() {
        let imageName = isFavorited ? "heart.fill" : "heart"
        let color: UIColor = isFavorited ? .systemRed : .darkGray
        favoriteBarButtonItem.image = UIImage(systemName: imageName)
        favoriteBarButtonItem.tintColor = color
    }
    
    @objc private func shareButtonTapped() {
        print("Paylaş butonu tıklandı")
    }
}

extension ProductDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.imageUrl != nil ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.identifier, for: indexPath) as? ProductImageCell else {
            return UICollectionViewCell()
        }
        if let urlString = product?.imageUrl, let url = URL(string: urlString) {
            cell.configure(with: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == imagesCollectionView {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl.currentPage = page
        }
    }
}

fileprivate class ProductImageCell: UICollectionViewCell {
    static let identifier = "ProductImageCell"
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with url: URL) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
    }
}

fileprivate class RatingInfoView: UIView {
    private let starStack = UIStackView()
    private let ratingLabel = UILabel()
    private let reviewCountButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(rating: Double?, reviewCount: Int?) {
    }
}

fileprivate class BadgedButton: UIButton {
    var badgeValue: String? {
        didSet {
        }
    }
}
