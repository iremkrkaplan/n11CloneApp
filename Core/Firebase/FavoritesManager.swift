//
//  FavoritesManager.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 3.07.2025.
//
// Core/Firebase/FavoritesManager.swift

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension Notification.Name {
    static let favoritesDidChange = Notification.Name("favoritesDidChange")
}

class FavoritesManager {
    static let shared = FavoritesManager()
    private let db = Firestore.firestore()

    private var userId: String? {
        Auth.auth().currentUser?.uid
    }

    private func favoritesCollectionRef() -> CollectionReference? {
        guard let userId = userId else { return nil }
        return db.collection("users").document(userId).collection("favorites")
    }

    private init() {}

    func add(product: Product, completion: @escaping (Error?) -> Void) {
        guard let collection = favoritesCollectionRef() else {
            completion(NSError(domain: "FavoritesManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        
        do {
            try collection.document(product.id).setData(from: product) { error in
                if error == nil {
                    NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
                }
                completion(error)
            }
        } catch {
            completion(error)
        }
    }

    func remove(productID: String, completion: @escaping (Error?) -> Void) {
        guard let collection = favoritesCollectionRef() else {
            completion(NSError(domain: "FavoritesManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        
        collection.document(productID).delete { error in
            if error == nil {
                NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
            }
            completion(error)
        }
    }

    func getFavoriteIds(completion: @escaping (Result<Set<String>, Error>) -> Void) {
        guard let collection = favoritesCollectionRef() else {
            completion(.success([]))
            return
        }

        collection.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let ids = snapshot?.documents.map { $0.documentID } ?? []
            completion(.success(Set(ids)))
        }
    }
    
    func listenForFavorites(completion: @escaping (Result<[Product], Error>) -> Void) -> ListenerRegistration? {
        guard let collection = favoritesCollectionRef() else {
            completion(.success([]))
            return nil
        }
        
        return collection.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let products = snapshot?.documents.compactMap {
                try? $0.data(as: Product.self)
            } ?? []
            
            completion(.success(products))
        }
    }
}
