//
//  CartViewController.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 2.07.2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CartViewController: UIViewController {

    private let cartManager = CartManager.shared
    private var cartItems: [CartItem] = []

    private var cartListener: ListenerRegistration?
    
    private let addressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.n11Purple.cgColor //????
         view.layer.borderWidth = 0.5
        return view
    }()

    private let addressTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "📍 Adresim"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()

    private let addressDetailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teslimat adresini gir"
        label.textColor = .n11Purple
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .right
        return label
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.allowsSelection = false
        return table
    }()

    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel()
        label.text = "Sepetinizde ürün bulunmamaktadır."
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        view.isHidden = true
        return view
    }()

    private let summaryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 4
        return view
    }()

    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Toplam: -- TL"
        return label
    }()

    private let checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ödemeye Geç", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .n11Purple
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if cartListener == nil {
            startCartListener()
        }
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.title = "Sepetim"
        navigationItem.titleView?.backgroundColor = UIColor.lightBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]


        //navigationController?.navigationBar.titleTextAttributes = []
    }

     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
     }

    deinit {
        stopCartListener()
    }

    private func setupUI() {
        view.backgroundColor = .lightBackground
        
        view.addSubview(addressView)
        addressView.addSubview(addressTitleLabel)
        addressView.addSubview(addressDetailLabel)

        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(summaryView)

        summaryView.addSubview(totalLabel)
        summaryView.addSubview(checkoutButton)

        NSLayoutConstraint.activate([

            addressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addressView.heightAnchor.constraint(equalToConstant: 48),
            addressTitleLabel.leadingAnchor.constraint(equalTo: addressView.leadingAnchor, constant: 16),
            addressTitleLabel.centerYAnchor.constraint(equalTo: addressView.centerYAnchor),
            addressTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: addressDetailLabel.leadingAnchor, constant: -16),

            addressTitleLabel.leadingAnchor.constraint(equalTo: addressView.leadingAnchor, constant: 16),
            addressTitleLabel.centerYAnchor.constraint(equalTo: addressView.centerYAnchor),
            addressTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: addressDetailLabel.leadingAnchor, constant: 16),
            addressDetailLabel.trailingAnchor.constraint(equalTo: addressView.trailingAnchor, constant: -16),
            addressDetailLabel.centerYAnchor.constraint(equalTo: addressView.centerYAnchor),
            
            
            tableView.topAnchor.constraint(equalTo: addressView.bottomAnchor),
                    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    tableView.bottomAnchor.constraint(equalTo: summaryView.topAnchor),
            

            emptyStateView.topAnchor.constraint(equalTo: tableView.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),


            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            summaryView.heightAnchor.constraint(equalToConstant: 80),

            totalLabel.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: 16),
            totalLabel.centerYAnchor.constraint(equalTo: summaryView.centerYAnchor),
            totalLabel.trailingAnchor.constraint(lessThanOrEqualTo: checkoutButton.leadingAnchor, constant: -16),
            
            checkoutButton.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: -16),
            checkoutButton.centerYAnchor.constraint(equalTo: summaryView.centerYAnchor),
            checkoutButton.widthAnchor.constraint(equalToConstant: 150),
            checkoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.identifier)
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func startCartListener() {
        guard cartListener == nil else { return }

        print("Starting cart items listener...")

        cartListener = cartManager.addCartItemsListener { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let items):
                    print("Cart listener received \(items.count) items.")
                    self.cartItems = items
                    self.tableView.reloadData()
                    self.updateSummary()
                    self.updateEmptyState()
                    
                case .failure(let error):
                    print("Error fetching cart items: \(error.localizedDescription)")
                    let alert = UIAlertController(title: "Error", message: "Could not fetch cart items: \(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                    self.cartItems = []
                    self.tableView.reloadData()
                    self.updateSummary()
                    self.updateEmptyState()
                }
            }
        }
    }

    private func stopCartListener() {
        cartListener?.remove()
        cartListener = nil
        print("Cart items listener stopped.")
    }

    private func updateSummary() {
        let total = cartItems.reduce(0.0) { $0 + ($1.price * Double($1.quantity)) }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let formattedTotal = formatter.string(from: NSNumber(value: total)) ?? String(format: "%.2f", total)

        totalLabel.text = "Toplam: \(formattedTotal) TL"
        checkoutButton.isEnabled = !cartItems.isEmpty
        checkoutButton.alpha = cartItems.isEmpty ? 0.5 : 1.0
    }

    private func updateEmptyState() {
        let isEmpty = cartItems.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        summaryView.isHidden = isEmpty
    }

    private func handleQuantityChange(for item: CartItem, newQuantity: Int) {
        guard newQuantity >= 0 else { return }
        if newQuantity == 0 {
            handleRemoveItem(item: item)
        } else {
            cartManager.updateItemQuantity(productID: item.productId, quantity: newQuantity) { [weak self] error in
                 DispatchQueue.main.async {
                     if let error = error {
                         print("Error updating quantity for \(item.title): \(error.localizedDescription)")
                         let alert = UIAlertController(title: "Error", message: "Could not update quantity: \(error.localizedDescription)", preferredStyle: .alert)
                         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                         self?.present(alert, animated: true, completion: nil)
                     } else {
                         print("Quantity updated successfully for \(item.title)")
                     }
                 }
            }
        }
    }

    private func handleRemoveItem(item: CartItem) {
        print("Removing item: \(item.title) with ID: \(item.id ?? "N/A")")
        cartManager.removeFromCart(productId: item.productId) { [weak self] result in
             DispatchQueue.main.async {
                 switch result {
                 case .success:
                     print("\(item.title) removed successfully.")
                 case .failure(let error):
                     print("Error removing \(item.title): \(error.localizedDescription)")
                      let alert = UIAlertController(title: "Error", message: "Could not remove item: \(error.localizedDescription)", preferredStyle: .alert)
                      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                      self?.present(alert, animated: true, completion: nil)
                 }
             }
        }
    }

    @objc private func checkoutButtonTapped() {
        print("Checkout button tapped!")
        let alert = UIAlertController(title: "Checkout", message: "Checkout functionality not implemented yet.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.identifier, for: indexPath) as? CartItemCell else {
            fatalError("Unable to dequeue CartItemCell")
        }

        guard indexPath.row < cartItems.count else { return UITableViewCell() }
        let item = cartItems[indexPath.row]
        cell.configure(with: item)


        cell.onQuantityChange = { [weak self, item] newQuantity in
             self?.handleQuantityChange(for: item, newQuantity: newQuantity)
        }

        cell.onRemove = { [weak self, item] in
            self?.handleRemoveItem(item: item)
        }

        return cell
    }
}

extension CartViewController: UITableViewDelegate {

     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             guard indexPath.row < cartItems.count else { return }
             let itemToRemove = cartItems[indexPath.row]
             handleRemoveItem(item: itemToRemove)
         }
     }
}
