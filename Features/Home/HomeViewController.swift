//
// HomeViewController.swift
//
// Created by İrem Karakaplan
//

import UIKit
import FirebaseAuth
import Kingfisher


class HomeViewController: UIViewController {

    var sponsoredProducts: [Product] = []
    var normalProducts: [Product] = []

    private var favoriteProductIDs = Set<String>()

    private let apiService = APIService.shared
    private let favoritesManager = FavoritesManager.shared
    private let cartManager = CartManager.shared
    
    private var headerView: HomeHeaderView!
    private var collectionView: UICollectionView!
    private var sponsoredSectionPageControl: UIPageControl?

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemGray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        addFavoritesObserver()
        authenticateAndFetchData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupUI() {
        view.backgroundColor = .lightBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        headerView = HomeHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let layout = HomeCollectionViewLayout.createLayout(dataSource: self)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alpha = 0
        collectionView.register(SponsoredProductCell.self, forCellWithReuseIdentifier: SponsoredProductCell.identifier)
        collectionView.register(NormalProductCell.self, forCellWithReuseIdentifier: NormalProductCell.identifier)
        collectionView.register(SponsoredProductsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SponsoredProductsHeaderView.identifier)
        collectionView.register(SponsoredProductsFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SponsoredProductsFooterView.identifier)

        view.addSubview(headerView)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),

            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func authenticateAndFetchData() {
        activityIndicator.startAnimating()
        Auth.auth().signInAnonymously { [weak self] (authResult, error) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                 if let error = error {
                     print("HATA: Firebase'e giriş yapılamadı: \(error)")
                     self.activityIndicator.stopAnimating()
                     let alert = UIAlertController(title: "Authentication Error", message: "Could not sign in anonymously: \(error.localizedDescription)", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                     self.present(alert, animated: true, completion: nil)
                     return
                 }

                 print("Firebase'e anonim olarak giriş yapıldı: \(authResult?.user.uid ?? "N/A")")
                 self.fetchFavorites()
                 self.fetchProducts()
             }
        }
    }

    private func fetchProducts() {
        print("Ürünler çekiliyor...")
        apiService.fetchAllProducts { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                 self.activityIndicator.stopAnimating()
                 switch result {
                 case .success(let allProducts):
                     print("\(allProducts.count) adet ürün başarıyla çekildi.")
                     self.distributeProducts(from: allProducts)

                     self.collectionView.reloadData()
                     UIView.animate(withDuration: 0.3) {
                         self.collectionView.alpha = 1
                     }

                 case .failure(let error):
                     print("HATA: Ürünler çekilemedi: \(error.localizedDescription)")
                      let alert = UIAlertController(title: "Error", message: "Could not fetch products: \(error.localizedDescription)", preferredStyle: .alert)
                      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                      self.present(alert, animated: true, completion: nil)
                 }
             }
        }
    }
    private func distributeProducts(from products: [Product]) {
        self.sponsoredProducts = products.filter { Int($0.id) ?? 0 % 2 != 0 && (Int($0.id) ?? 0) < 5 }
        self.normalProducts = products.filter { !self.sponsoredProducts.contains($0) }

        print("Sponsorlu ürün sayısı: \(self.sponsoredProducts.count)")
        print("Normal ürün sayısı: \(self.normalProducts.count)")
    }

    private func fetchFavorites() {
        favoritesManager.getFavoriteIds { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                 switch result {
                 case .success(let ids):
                     self.favoriteProductIDs = ids
                     self.collectionView.reloadData()
                 case .failure(let error):
                     print("HATA: Favori ID'leri çekilemedi: \(error.localizedDescription)")
                 }
             }
        }
    }

    private func addFavoritesObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesDidChange), name: .favoritesDidChange, object: nil)
    }

    @objc private func favoritesDidChange() {
        print("Favorites did change notification received. Re-fetching favorites.")
        fetchFavorites()
    }

    private func toggleFavoriteStatus(for product: Product) {
         print("Toggling favorite status for product ID: \(product.id)")

         let isFavorited = favoriteProductIDs.contains(product.id)

         if isFavorited {
             favoritesManager.remove(productID: product.id) { error in
                 if let error = error { print("HATA: Favorilerden çıkarılamadı: \(error)") }
             }
         } else {
             favoritesManager.add(product: product) { error in
                 if let error = error { print("HATA: Favorilere eklenemedi: \(error)") }
             }
         }
    }

    private func handleAddToCartTapped(for product: Product) {
         print("Add to cart tapped for product: \(product.title ?? "Unknown Product") (ID: \(product.id))")

         cartManager.addToCart(product: product, quantity: 1) { [weak self] result in
             DispatchQueue.main.async {
                 switch result {
                 case .success:
                     print("Product added to cart successfully!")
                     self?.showAddToCartSuccessFeedback(for: product)
                 case .failure(let error):
                     print("Error adding product to cart: \(error.localizedDescription)")
                     let alert = UIAlertController(title: "Error", message: "Could not add product to cart: \(error.localizedDescription)", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                     self?.present(alert, animated: true, completion: nil)
                 }
             }
         }
    }

     private func showAddToCartSuccessFeedback(for product: Product) {
         print("Showing success feedback for adding product \(product.title ?? "")")

     }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var sectionCount = 0
        if !sponsoredProducts.isEmpty { sectionCount += 1 }
        if !normalProducts.isEmpty { sectionCount += 1 }
        print("Total section count: \(sectionCount)")
        return sectionCount
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sectionType(for: section) {
        case .sponsoredProducts:
            return sponsoredProducts.count
        case .normalProducts:
            return normalProducts.count
        case .none:
            return 0
        }
    }
    private func sectionType(for index: Int) -> HomeSectionLayoutType? {
        let hasSponsored = !sponsoredProducts.isEmpty
        if index == 0 && hasSponsored {
            return .sponsoredProducts
        } else if index == (hasSponsored ? 1 : 0) && !normalProducts.isEmpty {
            return .normalProducts
        }
        return nil
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sectionType(for: indexPath.section) {
        case .sponsoredProducts:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SponsoredProductCell.identifier, for: indexPath) as? SponsoredProductCell else { fatalError("SponsoredProductCell bulunamadı") }
            guard indexPath.item < sponsoredProducts.count else { return UICollectionViewCell() }
            let product = sponsoredProducts[indexPath.item]
            cell.configure(with: product)
            return cell

        case .normalProducts:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalProductCell.identifier, for: indexPath) as? NormalProductCell else { fatalError("NormalProductCell bulunamadı") }
            guard indexPath.item < normalProducts.count else { return UICollectionViewCell() }
            let product = normalProducts[indexPath.item]
            cell.configure(with: product, isFavorited: favoriteProductIDs.contains(product.id))
            cell.favoriteButtonAction = { [weak self] in
                 self?.toggleFavoriteStatus(for: product)
             }

            cell.onAddToCartTapped = { [weak self] tappedProduct in
                self?.handleAddToCartTapped(for: tappedProduct)
            }

            return cell

        case .none:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard sectionType(for: indexPath.section) == .sponsoredProducts else {
            return UICollectionReusableView()
        }

        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SponsoredProductsHeaderView.identifier, for: indexPath) as? SponsoredProductsHeaderView else {
                fatalError("SponsoredProductsHeaderView bulunamadı")
            }
            return header
        }

        if kind == UICollectionView.elementKindSectionFooter {
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SponsoredProductsFooterView.identifier, for: indexPath) as? SponsoredProductsFooterView else {
                fatalError("SponsoredProductsFooterView bulunamadı")
            }
            footer.configure(numberOfPages: sponsoredProducts.count)
            self.sponsoredSectionPageControl = footer.pageControl
            return footer
        }
        return UICollectionReusableView()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.collectionView else { return }
        if let sponsoredSectionIndex = (0..<collectionView.numberOfSections).first(where: { sectionType(for: $0) == .sponsoredProducts }),
           !sponsoredProducts.isEmpty {
            let visibleItemsInSection = collectionView.indexPathsForVisibleItems.filter({ $0.section == sponsoredSectionIndex })
            if let firstVisibleItem = visibleItemsInSection.sorted(by: { $0.item < $1.item }).first {
                 sponsoredSectionPageControl?.currentPage = firstVisibleItem.item
             } else {
                 
             }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product: Product?
        
        switch sectionType(for: indexPath.section) {
        case .sponsoredProducts:
            guard indexPath.item < sponsoredProducts.count else { return }
            product = sponsoredProducts[indexPath.item]
        case .normalProducts:
            guard indexPath.item < normalProducts.count else { return }
            product = normalProducts[indexPath.item]
        default:
            product = nil
        }

        if let selectedProduct = product {
             let detailVC = ProductDetailViewController()
             detailVC.product = selectedProduct
             navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
