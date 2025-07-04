//
//  AccountViewController.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 2.07.2025.
//
import UIKit

class AccountViewController: UIViewController {

    private struct Colors {
        static let primaryPurple = AuthPopupViewController.Colors.primaryPurple
        static let lightGrayBorder = AuthPopupViewController.Colors.lightGrayBorder
        static let darkGrayIcon = UIColor.gray
    }

    private struct Padding {
        static let standard: CGFloat = 16
        static let small: CGFloat = 8
    }

    private lazy var authButtonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = Padding.small
        stack.translatesAutoresizingMaskIntoConstraints = false

        let signupButton = UIButton(type: .system)
        signupButton.setTitle("Üye Ol", for: .normal)
        signupButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        signupButton.setTitleColor(Colors.primaryPurple, for: .normal)
        signupButton.backgroundColor = .white
        signupButton.layer.cornerRadius = 8
        signupButton.layer.borderColor = Colors.primaryPurple.cgColor
        signupButton.layer.borderWidth = 1
        signupButton.clipsToBounds = true
        signupButton.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)

        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Giriş Yap", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = Colors.primaryPurple
        loginButton.layer.cornerRadius = 8
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)

        stack.addArrangedSubview(signupButton)
        stack.addArrangedSubview(loginButton)

        return stack
    }()

    private lazy var helperButtonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = Padding.standard
        stack.translatesAutoresizingMaskIntoConstraints = false

        let assistantButton = createHelperButton(title: "n11 Asistan", iconName: "person.crop.circle.fill")
        let feedbackButton = createHelperButton(title: "Geri Bildirim", iconName: "pencil.and.outline")
        let helpButton = createHelperButton(title: "Yardım", iconName: "questionmark.circle.fill")

        stack.addArrangedSubview(assistantButton)
        stack.addArrangedSubview(feedbackButton)
        stack.addArrangedSubview(helpButton)

        assistantButton.addTarget(self, action: #selector(helperButtonTapped), for: .touchUpInside)
        feedbackButton.addTarget(self, action: #selector(helperButtonTapped), for: .touchUpInside)
        helpButton.addTarget(self, action: #selector(helperButtonTapped), for: .touchUpInside)

        return stack
    }()

    private let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Versiyon: 17.7.1 (248)"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Hesabım"

        setupAccountUI()
        setupAccountConstraints()
         print("DEBUG: AccountViewController viewDidLoad tamamlandı.")
    }

    private func setupAccountUI() {
        view.addSubview(authButtonsStackView)
        view.addSubview(helperButtonsStackView)
        view.addSubview(versionLabel)
         print("DEBUG: AccountViewController UI elemanları view hiyerarşisine eklendi.")
    }

    private func setupAccountConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            authButtonsStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Padding.standard),
            authButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.standard),
            authButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.standard),
            authButtonsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            helperButtonsStackView.bottomAnchor.constraint(equalTo: versionLabel.topAnchor, constant: -Padding.standard),
            helperButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.standard),
            helperButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.standard)
        ])

        NSLayoutConstraint.activate([
             versionLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Padding.small),
             versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
         print("DEBUG: AccountViewController Constraints ayarlandı.")
    }

    @objc private func authButtonTapped() {
        print("DEBUG: Account screen auth button tapped, presenting popup")
        let authPopupVC = AuthPopupViewController()
        authPopupVC.modalPresentationStyle = .overFullScreen
        authPopupVC.modalTransitionStyle = .crossDissolve

        view.endEditing(true)

        present(authPopupVC, animated: true, completion: nil)
         print("DEBUG: AccountViewController AuthPopupViewController sunuldu.")
    }

     @objc private func helperButtonTapped() {
         print("DEBUG: AccountViewController Helper button tapped")
         showComingSoonAlert()
     }

    private func showComingSoonAlert() {
         print("DEBUG: AccountViewController: 'Yakında Gelecek' alerti gösteriliyor.")
        let alertController = UIAlertController(
            title: "Yakında Gelecek",
            message: "Bu özellik şu anda geliştirilme aşamasındadır. Anlayışınız için teşekkür ederiz.",
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }

    private func createHelperButton(title: String, iconName: String) -> UIButton {
         let button = UIButton(type: .system)
         button.translatesAutoresizingMaskIntoConstraints = false
         let stack = UIStackView()
         stack.axis = .vertical
         stack.alignment = .center
         stack.spacing = 4
         stack.isUserInteractionEnabled = false
         stack.translatesAutoresizingMaskIntoConstraints = false
         let iconImageView = UIImageView()
         iconImageView.translatesAutoresizingMaskIntoConstraints = false
         let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)
         var iconImage = UIImage(systemName: iconName, withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
          if iconImage == nil {
               if let assetImage = UIImage(named: iconName) {
                    iconImage = assetImage.withRenderingMode(.alwaysOriginal)
               } else {
                   print("UYARI: AccountViewController İkon görseli bulunamadı: \(iconName). Default fallback kullanılıyor.")
                   iconImage = UIImage(systemName: "questionmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
               }
          }

         iconImageView.image = iconImage
         iconImageView.contentMode = .scaleAspectFit

         if iconImageView.image?.renderingMode == .alwaysTemplate {
              iconImageView.tintColor = Colors.darkGrayIcon
         }

         let titleLabel = UILabel()
         titleLabel.translatesAutoresizingMaskIntoConstraints = false
         titleLabel.text = title
         titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
         titleLabel.textColor = .gray
         titleLabel.textAlignment = .center
        
         stack.addArrangedSubview(iconImageView)
         stack.addArrangedSubview(titleLabel)

         button.addSubview(stack)
         NSLayoutConstraint.activate([
             stack.centerXAnchor.constraint(equalTo: button.centerXAnchor),
             stack.centerYAnchor.constraint(equalTo: button.centerYAnchor),             stack.topAnchor.constraint(greaterThanOrEqualTo: button.topAnchor, constant: 4),
             stack.leadingAnchor.constraint(greaterThanOrEqualTo: button.leadingAnchor, constant: 4),
             stack.trailingAnchor.constraint(lessThanOrEqualTo: button.trailingAnchor, constant: -4),
             stack.bottomAnchor.constraint(lessThanOrEqualTo: button.bottomAnchor, constant: -4)
         ])

         return button
    }
}
