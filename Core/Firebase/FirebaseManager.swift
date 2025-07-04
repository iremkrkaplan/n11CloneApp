//  FirebaseManager.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 2.07.2025.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
class FirebaseManager: ObservableObject {

    static let shared = FirebaseManager()

    private let db = Firestore.firestore()

    @Published var currentUser: User?
    @Published var isUserLoggedIn = false

    private init() {
        print("DEBUG: FirebaseManager init çağrıldı. Temel kurulumlar yapılıyor.")
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        Firestore.firestore().settings = settings
        print("DEBUG: FirebaseManager - Firestore settings ayarlandı.")
        Auth.auth().useAppLanguage()
        print("DEBUG: FirebaseManager - Auth language ayarlandı.")
        setupAuthStateListener()

        print("DEBUG: FirebaseManager - Init tamamlandı.")
    }
    private func setupAuthStateListener() {
        print("DEBUG: FirebaseManager - Auth State Listener kuruluyor...")
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                let isLoggedIn = (user != nil)
                self?.isUserLoggedIn = isLoggedIn
                print("DEBUG: FirebaseManager - Auth State Listener Tetiklendi - isUserLoggedIn: \(isLoggedIn), User ID: \(user?.uid ?? "nil")")
            }
        }
        print("DEBUG: FirebaseManager - Auth State Listener kuruldu.")
    }

    func saveUserProfile(userId: String, userData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        print("DEBUG: FirebaseManager - User profile kaydediliyor: UserId=\(userId), Data=\(userData)")
        db.collection("users").document(userId).setData(userData, merge: true) { error in
            if let error = error {
                 print("DEBUG: FirebaseManager - User profile kaydetme hatası: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                 print("DEBUG: FirebaseManager - User profile başarıyla kaydedildi.")
                completion(.success(()))
            }
        }
    }

    func getUserProfile(userId: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
         print("DEBUG: FirebaseManager - User profile alınıyor: UserId=\(userId)")
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                 print("DEBUG: FirebaseManager - User profile alma hatası: \(error.localizedDescription)")
                completion(.failure(error))
            } else if let data = snapshot?.data() {
                 print("DEBUG: FirebaseManager - User profile başarıyla alındı.")
                completion(.success(data))
            } else {
                 print("DEBUG: FirebaseManager - User profile bulunamadı: UserId=\(userId)")
                completion(.failure(NSError(domain: "FirebaseManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "User profile not found"])))
            }
        }
    }

    func saveCartItems(userId: String, cartItems: [[String: Any]], completion: @escaping (Result<Void, Error>) -> Void) {
         print("DEBUG: FirebaseManager - Sepet kaydediliyor: UserId=\(userId), Items=\(cartItems.count) adet")
        let cartData = [
            "items": cartItems,
            "lastUpdated": Timestamp()
        ] as [String : Any]

        db.collection("users").document(userId).collection("cart").document("items").setData(cartData) { error in
            if let error = error {
                 print("DEBUG: FirebaseManager - Sepet kaydetme hatası: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                 print("DEBUG: FirebaseManager - Sepet başarıyla kaydedildi.")
                completion(.success(()))
            }
        }
    }

    func getCartItems(userId: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
         print("DEBUG: FirebaseManager - Sepet alınıyor: UserId=\(userId)")
        db.collection("users").document(userId).collection("cart").document("items").getDocument { snapshot, error in
            if let error = error {
                 print("DEBUG: FirebaseManager - Sepet alma hatası: \(error.localizedDescription)")
                completion(.failure(error))
            } else if let data = snapshot?.data(),
                      let items = data["items"] as? [[String: Any]] {
                 print("DEBUG: FirebaseManager - Sepet başarıyla alındı (\(items.count) ürün).")
                completion(.success(items))
            } else {
                 print("DEBUG: FirebaseManager - Sepet bulunamadı veya boş.")
                completion(.success([]))
            }
        }
    }

    func saveFavoriteItems(userId: String, favoriteItems: [[String: Any]], completion: @escaping (Result<Void, Error>) -> Void) {
         print("DEBUG: FirebaseManager - Favoriler kaydediliyor: UserId=\(userId), Items=\(favoriteItems.count) adet")
        let favoritesData = [
            "items": favoriteItems,
            "lastUpdated": Timestamp()
        ] as [String : Any]

        db.collection("users").document(userId).collection("favorites").document("items").setData(favoritesData) { error in
            if let error = error {
                print("DEBUG: FirebaseManager - Favori kaydetme hatası: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                 print("DEBUG: FirebaseManager - Favoriler başarıyla kaydedildi.")
                completion(.success(()))
            }
        }
    }

    func getFavoriteItems(userId: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
         print("DEBUG: FirebaseManager - Favoriler alınıyor: UserId=\(userId)")
        db.collection("users").document(userId).collection("favorites").document("items").getDocument { snapshot, error in
            if let error = error {
                 print("DEBUG: FirebaseManager - Favoriler alma hatası: \(error.localizedDescription)")
                completion(.failure(error))
            } else if let data = snapshot?.data(),
                      let items = data["items"] as? [[String: Any]] {
                 print("DEBUG: FirebaseManager - Favoriler başarıyla alındı (\(items.count) ürün).")
                completion(.success(items))
            } else {
                 print("DEBUG: FirebaseManager - Favoriler bulunamadı veya boş.")
                completion(.success([]))
            }
        }
    }
    func saveOrder(userId: String, orderData: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
         print("DEBUG: FirebaseManager - Sipariş kaydediliyor: UserId=\(userId)")
        var orderDataWithTimestamp = orderData
        orderDataWithTimestamp["createdAt"] = Timestamp()
        orderDataWithTimestamp["status"] = "pending"
        let orderRef = db.collection("users").document(userId).collection("orders").document()

        orderRef.setData(orderDataWithTimestamp) { error in
            if let error = error {
                 print("DEBUG: FirebaseManager - Sipariş kaydetme hatası: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                 print("DEBUG: FirebaseManager - Sipariş başarıyla kaydedildi: OrderId=\(orderRef.documentID)")
                completion(.success(orderRef.documentID))
            }
        }
    }

    func getUserOrders(userId: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
         print("DEBUG: FirebaseManager - Siparişler alınıyor: UserId=\(userId)")
        db.collection("users").document(userId).collection("orders")
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                     print("DEBUG: FirebaseManager - Siparişler alma hatası: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let orders = snapshot?.documents.compactMap { doc -> [String: Any]? in
                        var data = doc.data()
                        data["id"] = doc.documentID
                        return data
                    } ?? []

                     print("DEBUG: FirebaseManager - Siparişler başarıyla alındı (\(orders.count) sipariş).")
                    completion(.success(orders))
                }
            }
    }
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
         print("DEBUG: FirebaseManager - signOut çağrıldı.")
        do {
            try Auth.auth().signOut()
             print("DEBUG: FirebaseManager - signOut başarılı.")
            completion(.success(()))
        } catch {
             print("DEBUG: FirebaseManager - signOut hatası: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
         print("DEBUG: FirebaseManager - deleteAccount çağrıldı.")
        guard let user = Auth.auth().currentUser else {
             print("DEBUG: FirebaseManager - deleteAccount hatası: Kullanıcı girişi yok.")
            completion(.failure(NSError(domain: "FirebaseManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])))
            return
        }
         print("DEBUG: FirebaseManager - Firestore'dan kullanıcı profili siliniyor: UserId=\(user.uid)")
        db.collection("users").document(user.uid).delete { [weak self] error in
            if let error = error {
                 print("DEBUG: FirebaseManager - Firestore kullanıcı profili silme hatası: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                 print("DEBUG: FirebaseManager - Authentication'dan kullanıcı siliniyor: UserId=\(user.uid)")
                user.delete { error in
                    if let error = error {
                         print("DEBUG: FirebaseManager - Auth kullanıcı silme hatası: \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                         print("DEBUG: FirebaseManager - Hesap başarıyla silindi.")
                        completion(.success(()))
                    }
                }
            }
        }
    }

    func getCurrentUserId() -> String? {
        let id = Auth.auth().currentUser?.uid
         print("DEBUG: FirebaseManager - getCurrentUserId: \(id ?? "nil")")
        return id
    }

    func getCurrentUserEmail() -> String? {
         let email = Auth.auth().currentUser?.email
         print("DEBUG: FirebaseManager - getCurrentUserEmail: \(email ?? "nil")")
        return email
    }
    func getCurrentUserDisplayName() -> String? {
         let name = Auth.auth().currentUser?.displayName
         print("DEBUG: FirebaseManager - getCurrentUserDisplayName: \(name ?? "nil")")
        return name
    }
}
