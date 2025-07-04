import UIKit
import Kingfisher

class ProductDetailViewController: UIViewController {

    var product: Product?
    private var currentImageIndex = 0

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let productImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .white
        return scrollView
    }()

    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = UIColor.n11Purple
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.numberOfPages = 0
        return pageControl
    }()

    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    private let starsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        return label
    }()

    private let reviewCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .n11Purple
        return label
    }()

    private let heartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .systemGray
        return button
    }()

    private let specsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let specsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    private let pointsLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .n11Purple
        label.text = "Bu üründen 30 UçUç Puan kazanabilirsin!"
        label.backgroundColor = UIColor.n11LightPurple.withAlphaComponent(0.1)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        return label
    }()

    private let sellerInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .n11LightPurple
        view.layer.cornerRadius = 8
        return view
    }()

    private let sellerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        return label
    }()

    private let sellerBadgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.backgroundColor = .n11Purple
        label.text = "10"
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.widthAnchor.constraint(equalToConstant: 20).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private let officialStoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .n11Purple
        label.text = "Resmi Mağaza"
        return label
    }()

    private let freeShippingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .n11Purple
        label.text = "📦 Ücretsiz Kargo"
        return label
    }()

    private let bottomBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 4
        return view
    }()

    private let priceDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        return stackView
    }()

    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        return label
    }()

    private let sepetteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .n11Purple
        label.text = "Sepette"
        return label
    }()

    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()

    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+ Sepete Ekle", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.n11Purple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupNavigationBar()
        setupProductImageScrollView()
        updateUI()
        checkIfFavorite()
        setupNotificationObserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfFavorite()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoritesDidChange),
            name: .favoritesDidChange,
            object: nil
        )
    }

    @objc private func favoritesDidChange() {
        checkIfFavorite()
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(productImageScrollView)
        productImageScrollView.addSubview(imageStackView)
        contentView.addSubview(pageControl)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(heartButton)

        contentView.addSubview(specsScrollView)
        specsScrollView.addSubview(specsStackView)

        contentView.addSubview(pointsLabel)
        contentView.addSubview(sellerInfoView)
        contentView.addSubview(freeShippingLabel)

        ratingStackView.addArrangedSubview(starsStackView)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(reviewCountLabel)

        sellerInfoView.addSubview(sellerNameLabel)
        sellerInfoView.addSubview(sellerBadgeLabel)
        sellerInfoView.addSubview(officialStoreLabel)

        view.addSubview(bottomBarView)
        bottomBarView.addSubview(priceDetailsStackView)
        priceDetailsStackView.addArrangedSubview(originalPriceLabel)
        priceDetailsStackView.addArrangedSubview(sepetteLabel)
        priceDetailsStackView.addArrangedSubview(discountedPriceLabel)
        bottomBarView.addSubview(addToCartButton)

        setupStarRatingViews()

        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            productImageScrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageScrollView.heightAnchor.constraint(equalToConstant: 400),

            imageStackView.topAnchor.constraint(equalTo: productImageScrollView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: productImageScrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: productImageScrollView.trailingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: productImageScrollView.bottomAnchor),
            imageStackView.heightAnchor.constraint(equalTo: productImageScrollView.heightAnchor),

            pageControl.topAnchor.constraint(equalTo: productImageScrollView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            productNameLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 16),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productNameLabel.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor, constant: -8),

            heartButton.centerYAnchor.constraint(equalTo: productNameLabel.centerYAnchor),
            heartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            heartButton.widthAnchor.constraint(equalToConstant: 24),
            heartButton.heightAnchor.constraint(equalToConstant: 24),

            ratingStackView.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ratingStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),

            specsScrollView.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 16),
            specsScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            specsScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            specsScrollView.heightAnchor.constraint(equalToConstant: 55),

            specsStackView.topAnchor.constraint(equalTo: specsScrollView.topAnchor),
            specsStackView.bottomAnchor.constraint(equalTo: specsScrollView.bottomAnchor),
            specsStackView.leadingAnchor.constraint(equalTo: specsScrollView.leadingAnchor, constant: 16),
            specsStackView.trailingAnchor.constraint(equalTo: specsScrollView.trailingAnchor, constant: -16),
            specsStackView.heightAnchor.constraint(equalTo: specsScrollView.heightAnchor),

            pointsLabel.topAnchor.constraint(equalTo: specsScrollView.bottomAnchor, constant: 16),
            pointsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pointsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            pointsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),

            sellerInfoView.topAnchor.constraint(equalTo: pointsLabel.bottomAnchor, constant: 16),
            sellerInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sellerInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            sellerInfoView.heightAnchor.constraint(equalToConstant: 60),

            sellerNameLabel.leadingAnchor.constraint(equalTo: sellerInfoView.leadingAnchor, constant: 16),
            sellerNameLabel.topAnchor.constraint(equalTo: sellerInfoView.topAnchor, constant: 12),
            sellerBadgeLabel.leadingAnchor.constraint(equalTo: sellerNameLabel.trailingAnchor, constant: 8),
            sellerBadgeLabel.centerYAnchor.constraint(equalTo: sellerNameLabel.centerYAnchor),
            officialStoreLabel.leadingAnchor.constraint(equalTo: sellerInfoView.leadingAnchor, constant: 16),
            officialStoreLabel.topAnchor.constraint(equalTo: sellerNameLabel.bottomAnchor, constant: 4),

            freeShippingLabel.topAnchor.constraint(equalTo: sellerInfoView.bottomAnchor, constant: 16),
            freeShippingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            freeShippingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),

            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 70),

            priceDetailsStackView.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: 16),
            priceDetailsStackView.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            priceDetailsStackView.trailingAnchor.constraint(lessThanOrEqualTo: addToCartButton.leadingAnchor, constant: -16),

            addToCartButton.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -16),
            addToCartButton.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            addToCartButton.widthAnchor.constraint(equalToConstant: 150),
            addToCartButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton

        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(cartButtonTapped))
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(menuButtonTapped))

        navigationItem.rightBarButtonItems = [menuButton, cartButton, shareButton]
    }

    private func setupProductImageScrollView() {
        productImageScrollView.delegate = self
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
    }

    private func setupStarRatingViews() {
        starsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.image = UIImage(systemName: "star")
            starImageView.tintColor = .systemYellow
            starImageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
            starsStackView.addArrangedSubview(starImageView)
        }
    }

    private func createSpecBadgeView(text: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        containerView.setContentHuggingPriority(.required, for: .horizontal)
        containerView.setContentCompressionResistancePriority(.required, for: .horizontal)
        containerView.setContentCompressionResistancePriority(.required, for: .vertical)
        containerView.setContentHuggingPriority(.required, for: .vertical)
        containerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true


        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 1

        containerView.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4),
        ])

        return containerView
    }

    private func updateUI() {
        guard let product = product else {
            print("Product data not available.")
            return
        }

        productNameLabel.text = product.title
        ratingLabel.text = product.ratingText
        reviewCountLabel.text = product.reviewCountText + " 📸"

        discountedPriceLabel.text = product.formattedPrice

        if let originalPrice = product.originalPrice,
           let currentPrice = product.price,
           originalPrice > currentPrice
        {
            let formattedOriginalPriceString = String(format: "%.0f TL", originalPrice)
            let attributeString = NSAttributedString(
                string: formattedOriginalPriceString,
                attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            originalPriceLabel.attributedText = attributeString
            originalPriceLabel.isHidden = false

            sepetteLabel.isHidden = !(product.hasSepettePrice == true)

        } else {
            originalPriceLabel.attributedText = nil
            originalPriceLabel.isHidden = true
            sepetteLabel.isHidden = true
        }

        updateStarRating(with: product.rating)

        setupProductImages(imageURLs: product.imageURL)

        sellerNameLabel.text = product.seller ?? "Satıcı Bilgisi Yok"

        freeShippingLabel.isHidden = !(product.isFreeShipping == true)

        specsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let specTitles = ["Marka: Xiaomi", "Distribütör Garantili", "Ekran Boyutu 11.2\"", "Batarya Kapasitesi 8850 mAh", "Ön Kamera Çözünürlüğü 12 MP", "Şarj Tipi: USB-C", "Çözünürlük: 2560x1600"]

        for spec in specTitles {
            let badgeView = createSpecBadgeView(text: spec)
            specsStackView.addArrangedSubview(badgeView)
        }

        specsScrollView.isHidden = specsStackView.arrangedSubviews.isEmpty
    }

    private func updateStarRating(with rating: Double?) {
        let ratingValue = rating ?? 0.0
        let fullStars = floor(ratingValue)
        let halfStar = ratingValue.truncatingRemainder(dividingBy: 1) >= 0.5
        let totalStars = 5

        for (index, view) in starsStackView.arrangedSubviews.enumerated() {
            guard let starImageView = view as? UIImageView else { continue }

            if Double(index) < fullStars {
                starImageView.image = UIImage(systemName: "star.fill")
            } else if Double(index) == fullStars && halfStar {
                starImageView.image = UIImage(systemName: "star.leadinghalf.fill")
            } else {
                starImageView.image = UIImage(systemName: "star")
            }
        }
        ratingStackView.isHidden = rating == nil || rating == 0.0
    }

    private func setupProductImages(imageURLs: [String]?) {
        imageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard let urls = imageURLs, !urls.isEmpty else {
            let placeholderImageView = UIImageView()
            placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
            placeholderImageView.contentMode = .scaleAspectFit
            placeholderImageView.backgroundColor = .white
            placeholderImageView.image = UIImage(named: "placeHolder")
            placeholderImageView.tintColor = .systemGray3

            imageStackView.addArrangedSubview(placeholderImageView)

            let placeholderConstraints = [
                placeholderImageView.widthAnchor.constraint(equalTo: productImageScrollView.widthAnchor),
                placeholderImageView.heightAnchor.constraint(equalTo: productImageScrollView.heightAnchor)
            ]
            NSLayoutConstraint.activate(placeholderConstraints)

            pageControl.numberOfPages = 1
            pageControl.currentPage = 0
            return
        }

        for urlString in urls {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = .white
            imageStackView.addArrangedSubview(imageView)

            let imageConstraints = [
                 imageView.widthAnchor.constraint(equalTo: productImageScrollView.widthAnchor),
                 imageView.heightAnchor.constraint(equalTo: productImageScrollView.heightAnchor)
            ]
            NSLayoutConstraint.activate(imageConstraints)

            if let url = URL(string: urlString) {
                imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeHolder"))
            } else {
                imageView.image = UIImage(named: "placeHolder")
                imageView.tintColor = .n11Purple
            }
        }

        pageControl.numberOfPages = urls.count
        pageControl.currentPage = 0
    }

    private func checkIfFavorite() {
        guard let product = product else { return }

        FavoritesManager.shared.getFavoriteIds { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let favoriteIds):
                    let isFavorite = favoriteIds.contains(product.id)
                    self?.heartButton.isSelected = isFavorite
                    self?.heartButton.tintColor = isFavorite ? .n11Purple : .systemGray
                case .failure(let error):
                    print("Error checking favorites: \(error)")
                    self?.heartButton.isSelected = false
                    self?.heartButton.tintColor = .systemGray
                }
            }
        }
    }

    @objc private func heartButtonTapped() {
        guard let product = product else { return }

        if heartButton.isSelected {
            FavoritesManager.shared.remove(productID: product.id) { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error removing from favorites: \(error)")
                        let alert = UIAlertController(title: "Hata", message: "Favorilerden kaldırılırken bir hata oluştu.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                        self?.present(alert, animated: true)
                    } else {
                        self?.heartButton.isSelected = false
                        self?.heartButton.tintColor = .systemGray
                        self?.animateHeartButton()
                    }
                }
            }
        } else {
            FavoritesManager.shared.add(product: product) { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error adding to favorites: \(error)")
                        let alert = UIAlertController(title: "Hata", message: "Favorilere eklenirken bir hata oluştu.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                        self?.present(alert, animated: true)
                    } else {
                        self?.heartButton.isSelected = true
                        self?.heartButton.tintColor = .n11Purple
                        self?.animateHeartButton()
                    }
                }
            }
        }
    }

    private func animateHeartButton() {
        UIView.animate(withDuration: 0.1, animations: {
            self.heartButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.heartButton.transform = CGAffineTransform.identity
            }
        }
    }

    @objc private func addToCartButtonTapped() {
        let alert = UIAlertController(title: "Sepete Eklendi", message: "Ürün sepetinize eklendi.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func cartButtonTapped() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 2
        }
    }

    @objc private func shareButtonTapped() {
        guard let product = product, let shareText = product.title else {
             let alert = UIAlertController(title: "Hata", message: "Paylaşılacak ürün bilgisi yok.", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Tamam", style: .default))
             present(alert, animated: true)
             return
         }

        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
         activityViewController.popoverPresentationController?.sourceView = self.view
         present(activityViewController, animated: true)
    }

    @objc private func menuButtonTapped() {
        print("Menu button tapped")
    }

    @objc private func pageControlValueChanged() {
        let pageWidth = productImageScrollView.frame.width
        let currentPage = pageControl.currentPage
        let offsetX = CGFloat(currentPage) * pageWidth
        productImageScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        currentImageIndex = currentPage
    }
}

extension ProductDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == productImageScrollView {
            let pageWidth = scrollView.frame.width
            let fractionalPage = scrollView.contentOffset.x / pageWidth
            let currentPage = Int((fractionalPage + 0.5))
            if pageControl.currentPage != currentPage {
                 pageControl.currentPage = currentPage
                 currentImageIndex = currentPage
            }
        }
    }
}
