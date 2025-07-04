//
//  AuthViewController.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 3.07.2025.
//

// Features/Auth/AuthViewController.swift

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hesap Oluştur"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-posta"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .darkGray
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Şifre"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .darkGray
        textField.rightViewMode = .always
        let eyeButton = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        eyeButton.setImage(UIImage(systemName: "eye.slash", withConfiguration: config), for: .normal)
        eyeButton.tintColor = .systemGray
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        eyeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

        textField.rightView = eyeButton

        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Üye Ol", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupTargets()
    }

    private func setupUI() {
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(registerButton)
        
        view.addSubview(mainStackView)
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupTargets() {
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }

    @objc private func registerButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Eksik Bilgi", message: "Lütfen e-posta ve şifre alanlarını doldurun.")
            return
        }

        print("Üyelik Bilgileri: Email: \(email), Şifre: \(password)")
        
        startLoading()
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            self?.stopLoading()
            
            if let error = error {
                print("HATA: Kullanıcı oluşturulamadı: \(error.localizedDescription)")
                self?.showAlert(title: "Kayıt Başarısız", message: error.localizedDescription)
                return
            }
            
            if let user = authResult?.user {
                print("Başarılı! Kullanıcı oluşturuldu: \(user.uid)")
                self?.showAlert(title: "Kayıt Başarılı", message: "Hesabınız başarıyla oluşturuldu. Giriş yapabilirsiniz.")
            
            }
        }
    }
        
    private func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.registerButton.isEnabled = false
            self.registerButton.alpha = 0.5
        }
    }
    
    private func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.registerButton.isEnabled = true
            self.registerButton.alpha = 1.0
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    @objc func togglePasswordVisibility(sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()

        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
        sender.tintColor = passwordTextField.isSecureTextEntry ? .systemGray : .systemBlue
        if let textRange = passwordTextField.textRange(from: passwordTextField.beginningOfDocument, to: passwordTextField.endOfDocument) {
            passwordTextField.replace(textRange, withText: passwordTextField.text!)
        }
    }
}
