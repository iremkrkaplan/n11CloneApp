import UIKit
import FirebaseAuth
import FirebaseFirestore

class FavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {


    private var favoriteProducts: [Product] = []
    private let favoritesManager = FavoritesManager.shared
    private var favoritesListener: ListenerRegistration?

    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorilerim & Listelerim"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let segmentedControl: UISegmentedControl = {
        let items = ["Favorilerim", "Listelerim"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .white
        control.selectedSegmentTintColor = .n11Purple
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.systemGray], for: .normal)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        return cv
    }()

    private let emptyStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.slash.fill")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Henüz Favori Ürününüz Yok"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emptySubLabel: UILabel = {
        let label = UILabel()
        label.text = "Beğendiğiniz ürünleri kalp ikonuna dokunarak favorilerinize ekleyebilirsiniz."
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupTargets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        startDataFetching()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            favoritesListener?.remove()
    }

    deinit {
        favoritesListener?.remove()
        print("FavoritesViewController deinitialized.")
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(pageTitleLabel)
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)

        emptyStateView.addSubview(emptyImageView)
        emptyStateView.addSubview(emptyLabel)
        emptyStateView.addSubview(emptySubLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pageTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            pageTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            segmentedControl.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 44),

            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            emptyStateView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),

            emptyImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -60),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyImageView.heightAnchor.constraint(equalToConstant: 80),

            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 24),
            emptyLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 32),
            emptyLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -32),

            emptySubLabel.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor, constant: 8),
            emptySubLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 32),
            emptySubLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -32)
        ])
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavoriteProductCell.self, forCellWithReuseIdentifier: FavoriteProductCell.identifier)
    }

    private func setupTargets() {
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    private func startDataFetching() {

        
        print("FAVORITES: Using Firebase Data.")
        favoritesListener?.remove()
        favoritesListener = favoritesManager.listenForFavorites { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.favoriteProducts = products.sorted { ($0.price ?? 0) < ($1.price ?? 0) }
                case .failure(let error):
                    print("Error listening for favorites: \(error.localizedDescription)")
                    self.favoriteProducts = []
                }
                self.updateUI()
            }
        }
    }

    private func updateUI() {
        let hasFavorites = !favoriteProducts.isEmpty
        collectionView.isHidden = !hasFavorites
        emptyStateView.isHidden = hasFavorites
        collectionView.reloadData()
    }
    
    @objc private func segmentChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            startDataFetching()
        } else {
            favoritesListener?.remove()
            self.favoriteProducts = []
            self.updateUI()
            emptyLabel.text = "Henüz Bir Listeniz Yok"
            emptySubLabel.text = "Yeni listeler oluşturarak ürünlerinizi gruplayabilirsiniz."
        }
    }

    private func removeFromFavorites(at indexPath: IndexPath) {
        guard indexPath.item < favoriteProducts.count else { return }

        let productToRemove = favoriteProducts[indexPath.item]
        favoritesManager.remove(productID: productToRemove.id) { error in
            if let error = error {
                print("Failed to remove favorite via Firebase: \(error)")
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteProductCell.identifier, for: indexPath) as? FavoriteProductCell else {
            fatalError("Unable to dequeue FavoriteProductCell")
        }

        let product = favoriteProducts[indexPath.item]
        cell.configure(with: product)

        cell.onRemoveFromFavorites = { [weak self] in
            self?.removeFromFavorites(at: indexPath)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let width = collectionView.bounds.width - (padding * 2)
        let height: CGFloat = 120
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
