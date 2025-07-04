//
//  HomeHeaderView.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 3.07.2025.
//
import UIKit

class HomeHeaderView: UIView {

    let n11LogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "n11Logo")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let searchBar = CustomSearchBar()

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .white
        addSubview(n11LogoImageView)
        addSubview(searchBar)
        addSubview(bellContainerView)

        NSLayoutConstraint.activate([
            n11LogoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            n11LogoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            n11LogoImageView.widthAnchor.constraint(equalToConstant: 48),
            n11LogoImageView.heightAnchor.constraint(equalToConstant: 30),

            bellContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bellContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bellContainerView.widthAnchor.constraint(equalToConstant: 40),
            bellContainerView.heightAnchor.constraint(equalToConstant: 40),

            searchBar.leadingAnchor.constraint(equalTo: n11LogoImageView.trailingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: bellContainerView.leadingAnchor, constant: -8),
            searchBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
