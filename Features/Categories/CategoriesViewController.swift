//
//  CategoriesViewController.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 2.07.2025.
//
import UIKit

struct ProductCategory {
    let title: String
    let imageName: String
}

class CategoriesViewController: UIViewController {


    let headerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let n11LogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "n11Logo")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Ürün, kategori, marka ara"
        sb.searchBarStyle = .minimal
        sb.translatesAutoresizingMaskIntoConstraints = false

        let borderColor = UIColor(red: 0.5, green: 0.1, blue: 0.9, alpha: 1.0).cgColor
        sb.layer.borderColor = borderColor
        sb.layer.borderWidth = 1.5
        sb.layer.cornerRadius = 20
        sb.clipsToBounds = true

        sb.layer.shadowColor = UIColor.black.cgColor
        sb.layer.shadowOffset = CGSize(width: 0, height: 2)
        sb.layer.shadowOpacity = 0.05
        sb.layer.shadowRadius = 4
        sb.layer.masksToBounds = false
        
        if let textField = sb.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.layer.cornerRadius = 18
            textField.clipsToBounds = true
            textField.textColor = .black
            textField.textAlignment = .left
            textField.attributedPlaceholder = NSAttributedString(
                string: "Ürün, kategori, marka ara",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.gray,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)
                ]
            )
            if let glassIconView = textField.leftView as? UIImageView {
                glassIconView.tintColor = UIColor(red: 0.5, green: 0.1, blue: 0.9, alpha: 1.0)
            }
        }
        sb.tintColor = UIColor(red: 0.5, green: 0.1, blue: 0.9, alpha: 1.0)
        
        return sb
    }()
    
    let bellContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor(red: 0.5, green: 0.1, blue: 0.9, alpha: 1.0).cgColor
        view.layer.borderWidth = 1.5
        view.clipsToBounds = true
        
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bell.fill")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor(red: 0.5, green: 0.1, blue: 0.9, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(iv)
        
        NSLayoutConstraint.activate([
            iv.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iv.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iv.widthAnchor.constraint(equalToConstant: 20),
            iv.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return view
    }()

    let categoriesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Kategoriler"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    let categories: [ProductCategory] = [
        ProductCategory(title: "Moda", imageName: "moda"),
        ProductCategory(title: "Elektronik", imageName: "elektronik"),
        ProductCategory(title: "Ev & Yaşam", imageName: "ev_yasam"),
        ProductCategory(title: "Anne & Bebek", imageName: "anne_bebek"),
        ProductCategory(title: "Kozmetik &\nKişisel Bakım", imageName: "kozmetik"),
        ProductCategory(title: "Mücevher\n& Saat", imageName: "mucevher_saat"),
        ProductCategory(title: "Spor &\nOutdoor", imageName: "spor_outdoor"),
        ProductCategory(title: "Kitap, Müzik,\nFilm, Oyun", imageName: "kitap_muzik"),
        ProductCategory(title: "Otomotiv &\nMotosiklet", imageName: "otomotiv"),
        ProductCategory(title: "Yurt Dışından\nÜrünler", imageName: "yurt_disinda"),
        ProductCategory(title: "pet11", imageName: "pet11")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        applyConstraints()
    }
    
    override var overrideUserInterfaceStyle: UIUserInterfaceStyle {
        get { .light }
        set { }
    }

    private func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white

        headerContainerView.addSubview(n11LogoImageView)
        headerContainerView.addSubview(searchBar)
        headerContainerView.addSubview(bellContainerView)
        
        view.addSubview(headerContainerView)
        view.addSubview(categoriesTitleLabel)
        view.addSubview(collectionView)
        
        searchBar.delegate = self
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            headerContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainerView.heightAnchor.constraint(equalToConstant: 60),

            n11LogoImageView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 16),
            n11LogoImageView.centerYAnchor.constraint(equalTo: headerContainerView.centerYAnchor),
            n11LogoImageView.widthAnchor.constraint(equalToConstant: 48),
            n11LogoImageView.heightAnchor.constraint(equalToConstant: 30),

            bellContainerView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -16),
            bellContainerView.centerYAnchor.constraint(equalTo: headerContainerView.centerYAnchor),
            bellContainerView.widthAnchor.constraint(equalToConstant: 40),
            bellContainerView.heightAnchor.constraint(equalToConstant: 40),

            searchBar.leadingAnchor.constraint(equalTo: n11LogoImageView.trailingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: bellContainerView.leadingAnchor, constant: -8),
            searchBar.centerYAnchor.constraint(equalTo: headerContainerView.centerYAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            categoriesTitleLabel.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: 15),
            categoriesTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: categoriesTitleLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension CategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = categories[indexPath.item]
        cell.configure(with: category)
        return cell
    }
}

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }

        let itemsPerRow: CGFloat = 4
        let totalHorizontalPadding = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let totalSpacing = (itemsPerRow - 1) * flowLayout.minimumInteritemSpacing

        let availableWidth = collectionView.frame.width - totalHorizontalPadding - totalSpacing
        let itemWidth = availableWidth / itemsPerRow
        
        let itemHeight: CGFloat = itemWidth * 1.05
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.item]
        print("Seçilen kategori: \(selectedCategory.title)")
    }
}

extension CategoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Arama metni: \(searchText)")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

class CategoryCell: UICollectionViewCell {

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        backgroundColor = .white
        layer.cornerRadius = 0
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.shadowOffset = .zero

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -2)
        ])
    }

    func configure(with category: ProductCategory) {
        titleLabel.text = category.title
        imageView.image = UIImage(named: category.imageName)
    }
}
