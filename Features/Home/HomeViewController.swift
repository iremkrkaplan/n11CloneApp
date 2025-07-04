//
//  HomeViewController.swift
//
//
//  Created by İrem Karakaplan
//
// Features/Home/HomeViewController.swift

import UIKit
import FirebaseAuth
import Kingfisher

class HomeViewController: UIViewController {

    // MARK: - Properties
    
    // Erişilebilirlik için 'private' kaldırıldı.
    var sponsoredProducts: [Product] = []
    var normalProducts: [Product] = []
    
    private var favoriteProductIDs = Set<String>()
    
    // API ve Favori yöneticileri
    private let apiService = APIService.shared
    private let favoritesManager = FavoritesManager.shared
    
    // MARK: - UI Elements
    private var headerView: HomeHeaderView!
    private var collectionView: UICollectionView!
    private var sponsoredSectionPageControl: UIPageControl?
    
    // Veri yüklenirken gösterilecek aktivite göstergesi
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemGray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addFavoritesObserver()
        
        // Kullanıcı girişi ve veri çekme işlemini başlat
        authenticateAndFetchData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .n11LightGray
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        headerView = HomeHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = HomeCollectionViewLayout.createLayout(dataSource: self)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alpha = 0 // Başlangıçta gizli, veri gelince görünecek
        
        // Hücreleri ve header/footer'ı kaydet
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
    
    // MARK: - Data Fetching
    
    private func authenticateAndFetchData() {
        activityIndicator.startAnimating() // Yüklemeyi başlat
        
        // Firebase'e anonim olarak giriş yap (test için)
        Auth.auth().signInAnonymously { [weak self] (authResult, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("HATA: Firebase'e giriş yapılamadı: \(error)")
                self.activityIndicator.stopAnimating()
                // TODO: Kullanıcıya bir hata mesajı göster.
                return
            }
            
            print("Firebase'e anonim olarak giriş yapıldı: \(authResult?.user.uid ?? "N/A")")
            
            // Giriş başarılı olduktan sonra favorileri ve ürünleri çek
            self.fetchFavorites()
            self.fetchProducts()
        }
    }
    
    private func fetchProducts() {
        print("Ürünler çekiliyor...")
        // DÜZELTME: APIService kullanarak veriyi çekiyoruz.
        apiService.fetchAllProducts { [weak self] result in
            guard let self = self else { return }
            
            // Yükleme göstergesini durdur
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let allProducts):
                print("\(allProducts.count) adet ürün başarıyla çekildi.")
                // Gelen veriyi sponsorlu ve normal olarak ayır
                self.distributeProducts(from: allProducts)
                
                // Ana thread üzerinde CollectionView'i yenile
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    // Animasyonla görünür yap
                    UIView.animate(withDuration: 0.3) {
                        self.collectionView.alpha = 1
                    }
                }
                
            case .failure(let error):
                print("HATA: Ürünler çekilemedi: \(error.localizedDescription)")
                // TODO: Kullanıcıya bir hata mesajı göster.
            }
        }
    }
    
    // Gelen ürünleri sponsorlu ve normal listelere dağıtan yardımcı fonksiyon
    private func distributeProducts(from products: [Product]) {
        // Örnek bir mantık: ID'si tek olanları sponsorlu yapalım
        self.sponsoredProducts = products.filter { Int($0.id) ?? 0 % 2 != 0 && (Int($0.id) ?? 0) < 5 }
        self.normalProducts = products
        
        print("Sponsorlu ürün sayısı: \(self.sponsoredProducts.count)")
        print("Normal ürün sayısı: \(self.normalProducts.count)")
    }
    
    private func fetchFavorites() {
        favoritesManager.getFavoriteIds { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let ids):
                self.favoriteProductIDs = ids
                // Favori bilgisi değiştiğinde sadece görünür hücreleri yenilemek daha verimlidir.
                // Ancak şimdilik reloadData() yeterli.
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("HATA: Favori ID'leri çekilemedi: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Favorite Management
    
    private func addFavoritesObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesDidChange), name: .favoritesDidChange, object: nil)
    }
    
    @objc private func favoritesDidChange() {
        // Favori durumu değiştiğinde listeyi yeniden çek.
        fetchFavorites()
    }
    
    private func toggleFavoriteStatus(for product: Product) {
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
}

// MARK: - UICollectionView DataSource & Delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var sectionCount = 0
        if !sponsoredProducts.isEmpty { sectionCount += 1 }
        if !normalProducts.isEmpty { sectionCount += 1 }
        print("Toplam section sayısı: \(sectionCount)")
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
            // normalProducts'ın da dolu olduğunu kontrol et
            return .normalProducts
        }
        return nil
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sectionType(for: indexPath.section) {
        case .sponsoredProducts:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SponsoredProductCell.identifier, for: indexPath) as? SponsoredProductCell else { fatalError("SponsoredProductCell bulunamadı") }
            cell.configure(with: sponsoredProducts[indexPath.item])
            return cell
            
        case .normalProducts:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalProductCell.identifier, for: indexPath) as? NormalProductCell else { fatalError("NormalProductCell bulunamadı") }
            let product = normalProducts[indexPath.item]
            cell.configure(with: product, isFavorited: favoriteProductIDs.contains(product.id))
            cell.favoriteButtonAction = { [weak self] in self?.toggleFavoriteStatus(for: product) }
            return cell
            
        case .none:
            // Bu durum normalde olmamalı ama güvenlik için boş bir hücre döndür.
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
        
        // Yatay kayan sponsorlu ürünler bölümündeki mevcut sayfayı güncelle
        let visibleCells = collectionView.visibleCells.filter { $0 is SponsoredProductCell }
        if let firstVisibleCell = visibleCells.first, let indexPath = collectionView.indexPath(for: firstVisibleCell) {
            sponsoredSectionPageControl?.currentPage = indexPath.item
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product: Product
        switch sectionType(for: indexPath.section) {
        case .sponsoredProducts:
            product = sponsoredProducts[indexPath.item]
        case .normalProducts:
            product = normalProducts[indexPath.item]
        default:
            return
        }
        
        let detailVC = ProductDetailViewController()
        detailVC.product = product
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
