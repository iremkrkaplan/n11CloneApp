//
//  FilterSortBarView.swift
//  Features/CommonUI/FilterSortBarView.swift

import UIKit

class FilterSortBarView: UIView {


    private let sortStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        return stack
    }()

    private let sortIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.up.arrow.down.circle.fill")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    private let sortLabel: UILabel = {
        let label = UILabel()
        label.text = "Akıllı Sıralama"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    // Sıralama bilgi ikonu (isteğe bağlı)
    private let sortInfoIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "info.circle")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    private let filterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        return stack
    }()

    private let filterIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "line.horizontal.3.decrease.circle.fill")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    private let filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filtrele"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let filterBadgeLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = .white
        label.backgroundColor = .systemRed
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 20).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.isHidden = true
        return label
    }()

    private let filterLabelBadgeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 0
        return stack
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupBorders()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented - Programmatic UI Only")
    }


    private func setupViews() {
        backgroundColor = .white

        sortStackView.addArrangedSubview(sortIconImageView)
        sortStackView.addArrangedSubview(sortLabel)
        sortStackView.addArrangedSubview(sortInfoIconImageView)

        filterLabelBadgeContainerView.addSubview(filterLabel)
        filterLabelBadgeContainerView.addSubview(filterBadgeLabel)

        NSLayoutConstraint.activate([
            filterLabel.leadingAnchor.constraint(equalTo: filterLabelBadgeContainerView.leadingAnchor),
            filterLabel.centerYAnchor.constraint(equalTo: filterLabelBadgeContainerView.centerYAnchor),
            filterLabel.trailingAnchor.constraint(lessThanOrEqualTo: filterLabelBadgeContainerView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            filterBadgeLabel.leadingAnchor.constraint(equalTo: filterLabel.trailingAnchor, constant: 4),
            filterBadgeLabel.centerYAnchor.constraint(equalTo: filterLabel.centerYAnchor),
            filterBadgeLabel.topAnchor.constraint(greaterThanOrEqualTo: filterLabelBadgeContainerView.topAnchor),
            filterBadgeLabel.bottomAnchor.constraint(lessThanOrEqualTo: filterLabelBadgeContainerView.bottomAnchor),
            filterBadgeLabel.trailingAnchor.constraint(lessThanOrEqualTo: filterLabelBadgeContainerView.trailingAnchor)
        ])

        filterStackView.addArrangedSubview(filterIconImageView)
        filterStackView.addArrangedSubview(filterLabelBadgeContainerView)

        mainStackView.addArrangedSubview(sortStackView)
        mainStackView.addArrangedSubview(separatorView)
        mainStackView.addArrangedSubview(filterStackView)

        addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func setupBorders() {
        let topBorder = CALayer()
        topBorder.backgroundColor = UIColor.systemGray5.cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0.5)
        layer.addSublayer(topBorder)

        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor.systemGray5.cgColor
        bottomBorder.frame = CGRect(x: 0, y: frame.height - 0.5, width: frame.width, height: 0.5)
        layer.addSublayer(bottomBorder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        filterBadgeLabel.layer.cornerRadius = filterBadgeLabel.bounds.width / 2
        filterBadgeLabel.layer.masksToBounds = true

        if let sublayers = layer.sublayers {
            for layer in sublayers {
                if layer.backgroundColor == UIColor.systemGray5.cgColor {
                    if layer.frame.origin.y == 0 {
                        layer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 0.5)
                    } else {
                        layer.frame = CGRect(x: 0, y: bounds.height - 0.5, width: bounds.width, height: 0.5)
                    }
                }
            }
        }
    }

    func updateFilterCount(count: Int) {
        filterBadgeLabel.text = "\(count)"
        filterBadgeLabel.isHidden = count == 0
    }

    func addSortTarget(_ target: Any?, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        sortStackView.addGestureRecognizer(tapGesture)
        sortStackView.isUserInteractionEnabled = true
    }

    func addFilterTarget(_ target: Any?, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        filterStackView.addGestureRecognizer(tapGesture)
        filterStackView.isUserInteractionEnabled = true
    }
}
