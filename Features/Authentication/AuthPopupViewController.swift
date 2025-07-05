//
//  AuthPopupViewController.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 3.07.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
 extension UIResponder {
     private static weak var _currentFirstResponder: UIResponder?

     public static var currentFirstResponder: UIResponder? {
         _currentFirstResponder = nil
         UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
         return _currentFirstResponder
     }

     @objc private func findFirstResponder(_ sender: Any) {
         UIResponder._currentFirstResponder = self
     }
 }
class AuthPopupViewController: UIViewController {

    public struct Colors {
        static let primaryPurple = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1.0)
        static let primaryYellow = UIColor(red: 255/255, green: 209/255, blue: 12/255, alpha: 1.0)
        static let lightGrayBorder = UIColor(white: 0.9, alpha: 1.0)
        static let darkGrayText = UIColor.darkGray
    }

    private struct Padding {
        static let standard: CGFloat = 16
        static let large: CGFloat = 24
        static let small: CGFloat = 8
        static let formSpacing: CGFloat = 12
    }

    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.primaryPurple
        view.clipsToBounds = true
        return view
    }()

    private let patternImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "authBackgroundPattern")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let scrollViewContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()

    private let n11LogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "n11Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Merhaba! Üyelere özel kupon ve fırsatlar seni bekliyor 🤗"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var loginTabButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Giriş Yap", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.primaryPurple
        button.layer.cornerRadius = 8
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(loginTabTapped), for: .touchUpInside)
        return button
    }()
    private lazy var signupTabButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Üye Ol", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(Colors.primaryPurple, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        button.layer.borderColor = Colors.primaryPurple.cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(signupTabTapped), for: .touchUpInside)
        return button
    }()

    private lazy var authTabsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(loginTabButton)
        stack.addArrangedSubview(signupTabButton)
        return stack
    }()

    private let emailPhoneTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "E-posta Adresi veya Telefon Numarası"
        textField.borderStyle = .none
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = Colors.lightGrayBorder.cgColor
        textField.layer.borderWidth = 1
        textField.clipsToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Padding.standard, height: textField.frame.height))
        textField.leftViewMode = .always
        if let placeholder = textField.placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
        }
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.autocapitalizationType = .none
        textField.textColor = Colors.darkGrayText
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Şifre"
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = Colors.lightGrayBorder.cgColor
        textField.layer.borderWidth = 1
        textField.clipsToBounds = true
        textField.textColor = Colors.darkGrayText
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Padding.standard, height: textField.frame.height))
        textField.leftViewMode = .always
         if let placeholder = textField.placeholder {
             textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
         }
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Adınız"
        textField.borderStyle = .none
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = Colors.lightGrayBorder.cgColor
        textField.layer.borderWidth = 1
        textField.clipsToBounds = true
        textField.textColor = Colors.darkGrayText
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Padding.standard, height: textField.frame.height))
        textField.leftViewMode = .always
        if let placeholder = textField.placeholder {
             textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
        }
        textField.isHidden = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()

    private let surnameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Soyadınız"
        textField.borderStyle = .none
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = Colors.lightGrayBorder.cgColor
        textField.layer.borderWidth = 1
        textField.textColor = Colors.darkGrayText
        textField.clipsToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Padding.standard, height: textField.frame.height))
        textField.leftViewMode = .always
         if let placeholder = textField.placeholder {
             textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
         }
        textField.isHidden = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()

    private lazy var formFieldsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = Padding.formSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(emailPhoneTextField)
        stack.addArrangedSubview(passwordTextField)
        stack.addArrangedSubview(nameTextField)
        stack.addArrangedSubview(surnameTextField)

        return stack
    }()

    private let mainActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Giriş Yap", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.primaryPurple
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()

    private let otherOptionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Diğer Seçenekler"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    private lazy var socialLoginStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = Padding.small
        stack.translatesAutoresizingMaskIntoConstraints = false
        let appleButton = createSocialButton(title: "Apple", iconName: "iconApple")
        let facebookButton = createSocialButton(title: "Facebook", iconName: "iconFacebook")
        let googleButton = createSocialButton(title: "Google", iconName: "iconGoogle")

        stack.addArrangedSubview(appleButton)
        stack.addArrangedSubview(facebookButton)
        stack.addArrangedSubview(googleButton)

        appleButton.addTarget(self, action: #selector(appleLoginTapped), for: .touchUpInside)
        facebookButton.addTarget(self, action: #selector(facebookLoginTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleLoginTapped), for: .touchUpInside)

        return stack
    }()

    private let needHelpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Yardıma mı ihtiyacın var?", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(Colors.primaryPurple, for: .normal)
        button.addTarget(self, action: #selector(showComingSoonAlert), for: .touchUpInside)
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = Colors.primaryPurple
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupUI()
        setupConstraints()
        setupActions()
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        loginTabTapped()

        NotificationCenter.default.addObserver(self, selector: #selector(adjustScrollViewForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustScrollViewForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)

        print("DEBUG: AuthPopupViewController viewDidLoad tamamlandı.")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("DEBUG: AuthPopupViewController deinit.")
    }

    private func setupUI() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(patternImageView)

        view.addSubview(contentView)

        contentView.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainerView)
        scrollViewContainerView.addSubview(n11LogoImageView)
        scrollViewContainerView.addSubview(welcomeLabel)
        scrollViewContainerView.addSubview(authTabsStackView)
        scrollViewContainerView.addSubview(formFieldsStackView)
        scrollViewContainerView.addSubview(mainActionButton)
        scrollViewContainerView.addSubview(otherOptionsLabel)
        scrollViewContainerView.addSubview(socialLoginStackView)
        scrollViewContainerView.addSubview(needHelpButton)
        view.addSubview(closeButton)

        view.addSubview(activityIndicator)

         print("DEBUG: AuthPopupViewController UI elemanları view hiyerarşisine eklendi.")
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ])

        NSLayoutConstraint.activate([
            patternImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            patternImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            patternImageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            patternImageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            scrollViewContainerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollViewContainerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollViewContainerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollViewContainerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollViewContainerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])


        NSLayoutConstraint.activate([
             closeButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Padding.standard),
             closeButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Padding.standard),
             closeButton.widthAnchor.constraint(equalToConstant: 40),
             closeButton.heightAnchor.constraint(equalToConstant: 40)
         ])


        NSLayoutConstraint.activate([
             n11LogoImageView.topAnchor.constraint(equalTo: scrollViewContainerView.topAnchor, constant: Padding.large),
             n11LogoImageView.centerXAnchor.constraint(equalTo: scrollViewContainerView.centerXAnchor),
             n11LogoImageView.widthAnchor.constraint(equalToConstant: 100),
             n11LogoImageView.heightAnchor.constraint(equalToConstant: 40),

            welcomeLabel.topAnchor.constraint(equalTo: n11LogoImageView.bottomAnchor, constant: Padding.small),
            welcomeLabel.leadingAnchor.constraint(equalTo: scrollViewContainerView.leadingAnchor, constant: Padding.standard),
            welcomeLabel.trailingAnchor.constraint(equalTo: scrollViewContainerView.trailingAnchor, constant: -Padding.standard),

            authTabsStackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: Padding.large),
            authTabsStackView.leadingAnchor.constraint(equalTo: scrollViewContainerView.leadingAnchor, constant: Padding.standard),
            authTabsStackView.trailingAnchor.constraint(equalTo: scrollViewContainerView.trailingAnchor, constant: -Padding.standard),
            authTabsStackView.heightAnchor.constraint(equalToConstant: 44),
            formFieldsStackView.topAnchor.constraint(equalTo: authTabsStackView.bottomAnchor, constant: Padding.large),
            formFieldsStackView.leadingAnchor.constraint(equalTo: scrollViewContainerView.leadingAnchor, constant: Padding.standard),
            formFieldsStackView.trailingAnchor.constraint(equalTo: scrollViewContainerView.trailingAnchor, constant: -Padding.standard),
            mainActionButton.topAnchor.constraint(equalTo: formFieldsStackView.bottomAnchor, constant: Padding.standard),
            mainActionButton.leadingAnchor.constraint(equalTo: scrollViewContainerView.leadingAnchor, constant: Padding.standard),
            mainActionButton.trailingAnchor.constraint(equalTo: scrollViewContainerView.trailingAnchor, constant: -Padding.standard),
            mainActionButton.heightAnchor.constraint(equalToConstant: 50),

            otherOptionsLabel.topAnchor.constraint(equalTo: mainActionButton.bottomAnchor, constant: Padding.large),
            otherOptionsLabel.centerXAnchor.constraint(equalTo: scrollViewContainerView.centerXAnchor),

            socialLoginStackView.topAnchor.constraint(equalTo: otherOptionsLabel.bottomAnchor, constant: Padding.standard),
            socialLoginStackView.leadingAnchor.constraint(equalTo: scrollViewContainerView.leadingAnchor, constant: Padding.standard),
            socialLoginStackView.trailingAnchor.constraint(equalTo: scrollViewContainerView.trailingAnchor, constant: -Padding.standard),
            socialLoginStackView.heightAnchor.constraint(equalToConstant: 60),
            needHelpButton.topAnchor.constraint(equalTo: socialLoginStackView.bottomAnchor, constant: Padding.large),
            needHelpButton.centerXAnchor.constraint(equalTo: scrollViewContainerView.centerXAnchor),
            needHelpButton.bottomAnchor.constraint(equalTo: scrollViewContainerView.bottomAnchor, constant: -Padding.large)
        ])

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
         print("DEBUG: AuthPopupViewController Constraints ayarlandı.")
    }

     private func setupActions() {
         closeButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
         mainActionButton.addTarget(self, action: #selector(mainActionButtonTapped), for: .touchUpInside)
          print("DEBUG: AuthPopupViewController Buton action'ları bağlandı.")
     }

    @objc private func dismissPopup() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
        print("DEBUG: AuthPopupViewController Popup kapatılıyor.")
    }

    private func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.contentView.isUserInteractionEnabled = false
            self.closeButton.isEnabled = false
             print("DEBUG: AuthPopupViewController Loading başladı.")
        }
    }

    private func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.contentView.isUserInteractionEnabled = true
            self.closeButton.isEnabled = true

             print("DEBUG: AuthPopupViewController Loading durdu.")
        }
    }

    @objc private func loginTabTapped() {
        print("DEBUG: Giriş Yap tab tapped")
        loginTabButton.backgroundColor = Colors.primaryPurple
        loginTabButton.setTitleColor(.white, for: .normal)
        loginTabButton.layer.borderWidth = 0
        signupTabButton.backgroundColor = .white
        signupTabButton.setTitleColor(Colors.primaryPurple, for: .normal)
        signupTabButton.layer.borderColor = Colors.primaryPurple.cgColor
        signupTabButton.layer.borderWidth = 1
        UIView.animate(withDuration: 0.3) {
            self.nameTextField.isHidden = true
            self.surnameTextField.isHidden = true
            self.emailPhoneTextField.isHidden = false
            self.passwordTextField.isHidden = false
            self.formFieldsStackView.layoutIfNeeded()
            self.scrollViewContainerView.layoutIfNeeded()
        }

        mainActionButton.setTitle("Giriş Yap", for: .normal)

         emailPhoneTextField.text = ""
         passwordTextField.text = ""
         nameTextField.text = ""
         surnameTextField.text = ""
         emailPhoneTextField.placeholder = "E-posta Adresi veya Telefon Numarası"
         passwordTextField.placeholder = "Şifre"
         nameTextField.placeholder = "Adınız"
         surnameTextField.placeholder = "Soyadınız"

         if let placeholder = emailPhoneTextField.placeholder {
             emailPhoneTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
         }
          if let placeholder = passwordTextField.placeholder {
              passwordTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
          }

         emailPhoneTextField.keyboardType = .emailAddress
         print("DEBUG: AuthPopupViewController Giriş Yap UI güncellendi.")
    }

    @objc private func signupTabTapped() {
        print("DEBUG: Üye Ol tab tapped")
        signupTabButton.backgroundColor = Colors.primaryPurple
        signupTabButton.setTitleColor(.white, for: .normal)
        signupTabButton.layer.borderWidth = 0
        loginTabButton.backgroundColor = .white
        loginTabButton.setTitleColor(Colors.primaryPurple, for: .normal)
        loginTabButton.layer.borderColor = Colors.primaryPurple.cgColor
        loginTabButton.layer.borderWidth = 1
        UIView.animate(withDuration: 0.3) {
            self.nameTextField.isHidden = false
            self.surnameTextField.isHidden = false
            self.emailPhoneTextField.isHidden = false
            self.passwordTextField.isHidden = false
            self.formFieldsStackView.layoutIfNeeded()
            self.scrollViewContainerView.layoutIfNeeded()
        }

        mainActionButton.setTitle("Üye Ol", for: .normal)

         emailPhoneTextField.text = ""
         passwordTextField.text = ""
         nameTextField.text = ""
         surnameTextField.text = ""
         emailPhoneTextField.placeholder = "E-posta Adresi"
         passwordTextField.placeholder = "Şifre"
          nameTextField.placeholder = "Adınız"
          surnameTextField.placeholder = "Soyadınız"

          if let placeholder = emailPhoneTextField.placeholder {
              emailPhoneTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
          }
           if let placeholder = passwordTextField.placeholder {
               passwordTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
           }
            if let placeholder = nameTextField.placeholder {
                nameTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
            }
             if let placeholder = surnameTextField.placeholder {
                 surnameTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
             }

        emailPhoneTextField.keyboardType = .emailAddress
         print("DEBUG: AuthPopupViewController Üye Ol UI güncellendi.")
    }

    @objc private func mainActionButtonTapped() {
        let currentAction = mainActionButton.title(for: .normal) ?? "Unknown Action"
        print("DEBUG: \(currentAction) butonu tıklandı.")
        guard let emailOrPhone = emailPhoneTextField.text, !emailOrPhone.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
             print("DEBUG: Validation başarısız - Email/Telefon ve Şifre boş.")
             showAlert(title: "Uyarı", message: "E-posta/Telefon ve Şifre alanları boş bırakılamaz.")
             return
        }

        print("DEBUG: Validation başarılı. E-posta/Tel: \(emailOrPhone), Şifre: [Gizli]")
        
        view.endEditing(true)
        
        startLoading()
        print("DEBUG: Loading indicator başlatıldı.")

        if currentAction == "Giriş Yap" {
            print("DEBUG: Action: Giriş Yap. Firebase signIn çağrılıyor...")
            Auth.auth().signIn(withEmail: emailOrPhone, password: password) { [weak self] authResult, error in

                print("DEBUG: signIn completion block'una girildi. Error: \(error?.localizedDescription ?? "nil")")
                self?.stopLoading()
                print("DEBUG: Loading indicator durduruldu.")
                if let error = error {
                    print("DEBUG: Giriş Yapma Hatası: \(error.localizedDescription)")
                    self?.showAlert(title: "Giriş Başarısız", message: error.localizedDescription)
                } else {
                    print("DEBUG: Giriş Başarılı: User ID \(authResult?.user.uid ?? "N/A")")
                    self?.dismissPopup()
                }
            }
        } else if currentAction == "Üye Ol" {
            guard let name = nameTextField.text, !name.isEmpty,
                  let surname = surnameTextField.text, !surname.isEmpty else {
                print("DEBUG: Validation başarısız - Üye olma için Ad/Soyad boş.")
                stopLoading()
                showAlert(title: "Eksik Bilgi", message: "Üye olabilmek için Adınız ve Soyadınız alanlarını doldurmalısınız.")
                return
            }

            print("DEBUG: Action: Üye Ol. Firebase createUser çağrılıyor...")
            Auth.auth().createUser(withEmail: emailOrPhone, password: password) { [weak self] authResult, error in
                 print("DEBUG: createUser completion block'una girildi. Error: \(error?.localizedDescription ?? "nil")")
                 if let error = error {
                     print("DEBUG: Üye Olma Hatası: \(error.localizedDescription)")
                     self?.stopLoading()
                     print("DEBUG: Loading indicator durduruldu (Auth Error).")
                     self?.showAlert(title: "Kayıt Başarısız", message: error.localizedDescription)
                 } else if let user = authResult?.user {
                     print("DEBUG: Üyelik Başarılı (Auth): User ID \(user.uid). Profil bilgileri Firestore'a kaydediliyor...")
                     let userData: [String: Any] = [
                         "name": name,
                         "surname": surname,
                         "email": emailOrPhone,
                         "createdAt": Timestamp()
                     ]

                     print("DEBUG: FirebaseManager.saveUserProfile çağrılıyor...")
                     FirebaseManager.shared.saveUserProfile(userId: user.uid, userData: userData) { result in
                         print("DEBUG: saveUserProfile completion block'una girildi.")
                         print("DEBUG: Loading indicator durduruldu (Firestore Done).")

                         switch result {
                         case .success():
                             print("DEBUG: Profil Bilgileri Firestore'a başarıyla kaydedildi.")
                             self?.showAlert(title: "Kayıt Başarılı", message: "Hesabınız başarıyla oluşturuldu ve profiliniz kaydedildi. Giriş yapabilirsiniz.") { _ in
                                   self?.dismissPopup()
                             }
                         case .failure(let firestoreError):
                             print("DEBUG: Firestore Kayıt Hatası: \(firestoreError.localizedDescription)")
                             self?.showAlert(title: "Profil Kayıt Hatası", message: "Hesabınız oluşturuldu ancak profil bilgileriniz kaydedilemedi: \(firestoreError.localizedDescription)") { _ in
                                 self?.dismissPopup()
                             }
                         }
                     }
                 } else {
                     print("DEBUG: createUser completion block: Hem error hem authResult/user nil.")
                     self?.stopLoading()
                     self?.showAlert(title: "Kayıt Başarısız", message: "Beklenmeyen bir hata oluştu.")
                 }
            }
        }
    }

    private func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
         print("DEBUG: AuthPopupViewController Alert gösteriliyor - Başlık: \(title), Mesaj: \(message)")
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: completion))
        present(alertController, animated: true, completion: nil)
    }

    @objc private func appleLoginTapped() {
         print("DEBUG: Apple ile Giriş Yap tapped - Yakında Gelecek")
         showComingSoonAlert()
    }
    @objc private func facebookLoginTapped() {
         print("DEBUG: Facebook ile Giriş Yap tapped - Yakında Gelecek")
         showComingSoonAlert()
    }
    @objc private func googleLoginTapped() {
         print("DEBUG: Google ile Giriş Yap tapped - Yakında Gelecek")
         showComingSoonAlert()
    }

     @objc func adjustScrollViewForKeyboard(notification: NSNotification) {
         guard let userInfo = notification.userInfo,
               let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

         let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

         if notification.name == UIResponder.keyboardWillHideNotification {
             scrollView.contentInset = .zero
             scrollView.scrollIndicatorInsets = .zero
             print("DEBUG: AuthPopupViewController Klavye gizleniyor, scrollView insets sıfırlandı.")
         } else {
             let keyboardHeight = keyboardViewEndFrame.size.height

             let bottomPadding = view.safeAreaInsets.bottom

             let totalBottomInset = max(0, keyboardHeight - bottomPadding)

             scrollView.contentInset.bottom = totalBottomInset
             scrollView.scrollIndicatorInsets.bottom = totalBottomInset
             print("DEBUG: AuthPopupViewController Klavye gösteriliyor, scrollView bottom inset: \(totalBottomInset)")
             
              if let activeTextField = UIResponder.currentFirstResponder as? UITextField {
                 let textFieldFrameInScrollView = activeTextField.convert(activeTextField.bounds, to: scrollView)

                 var visibleRect = scrollView.bounds
                 visibleRect.size.height -= totalBottomInset
                 if textFieldFrameInScrollView.maxY > visibleRect.maxY - Padding.small {
                     let scrollAmount = textFieldFrameInScrollView.maxY - visibleRect.maxY + Padding.small
                     var contentOffset = scrollView.contentOffset
                     contentOffset.y += scrollAmount
                     let maxScrollY = max(0, scrollView.contentSize.height - scrollView.bounds.height + totalBottomInset)
                     contentOffset.y = min(contentOffset.y, maxScrollY)
                     contentOffset.y = max(0, contentOffset.y)
                     scrollView.setContentOffset(contentOffset, animated: true)
                      print("DEBUG: AuthPopupViewController Text field klavye altında, scrollView kaydırıldı.")
                 } else {
                      print("DEBUG: AuthPopupViewController Text field klavye altında değil veya kaydırmaya gerek yok.")
                 }
             } else {
                  print("DEBUG: AuthPopupViewController Aktif text field bulunamadı.")
             }
         }
         UIView.animate(withDuration: 0.3) {
             self.view.layoutIfNeeded()
         }
     }

    private func createSocialButton(title: String, iconName: String) -> UIButton {
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
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        var iconImage = UIImage(systemName: iconName, withConfiguration: config)?.withRenderingMode(.alwaysOriginal)
         if iconImage == nil || iconImage?.renderingMode == .alwaysTemplate {
              if let assetImage = UIImage(named: iconName) {
                   iconImage = assetImage.withRenderingMode(.alwaysOriginal)
              } else {
                  print("UYARI: AuthPopupViewController İkon görseli bulunamadı: \(iconName). Default fallback kullanılıyor.")
                  iconImage = UIImage(systemName: "questionmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
              }
         }

        iconImageView.image = iconImage
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
         if iconImageView.image?.renderingMode == .alwaysTemplate {
             iconImageView.tintColor = Colors.darkGrayText
         }

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = Colors.darkGrayText
        titleLabel.textAlignment = .center
        stack.addArrangedSubview(iconImageView)
        stack.addArrangedSubview(titleLabel)

        button.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            stack.topAnchor.constraint(greaterThanOrEqualTo: button.topAnchor, constant: 4),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: button.leadingAnchor, constant: 4),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: button.trailingAnchor, constant: -4),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: button.bottomAnchor, constant: -4)
        ])
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderColor = Colors.lightGrayBorder.cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true

        return button
    }

     @objc private func showComingSoonAlert() {
         print("DEBUG: AuthPopupViewController 'Yakında Gelecek' alerti gösteriliyor.")
         let alertController = UIAlertController(
             title: "Yakında Gelecek",
             message: "Bu özellik şu anda geliştirilme aşamasındadır. Anlayışınız için teşekkür ederiz.",
             preferredStyle: .alert)
         
         let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
         alertController.addAction(okAction)

         present(alertController, animated: true, completion: nil)
     }
}
