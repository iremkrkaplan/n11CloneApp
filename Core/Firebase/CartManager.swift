//
//  CartManager.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 5.07.2025.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth


class CartManager {
    static let shared = CartManager()
    private let db = Firestore.firestore()
    private let cartCollectionName = "cart"

    private init() {}
    
    private var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }

    func addToCart(product: Product, quantity: Int = 1, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = currentUserId else {
             completion(.failure(NSError(domain: "CartManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
             return
         }

        let productId = product.id
         if productId.isEmpty {
             completion(.failure(NSError(domain: "CartManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Product ID is missing or empty"])))
              return
         }

        let documentId = "\(userId)_\(productId)"
        let cartItemRef = db.collection("users").document(userId).collection(cartCollectionName).document(documentId)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let documentSnapshot: DocumentSnapshot
            do {
                documentSnapshot = try transaction.getDocument(cartItemRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            if documentSnapshot.exists {
                let currentQuantity = documentSnapshot.data()?["quantity"] as? Int ?? 0
                let newQuantity = currentQuantity + quantity
                transaction.updateData([
                    "quantity": newQuantity,
                    "timestamp": FieldValue.serverTimestamp()
                ], forDocument: cartItemRef)
                print("Transaction: Updated quantity for item \(documentId) to \(newQuantity)")

            } else {
                 guard var newCartItem = CartItem(product: product, userId: userId) else {
                      let error = NSError(domain: "CartManagerError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to create new CartItem from product data."])
                      errorPointer?.pointee = error
                      return nil
                 }
                 newCartItem.quantity = quantity
                 newCartItem.id = documentId
                do {
                    try transaction.setData(from: newCartItem, forDocument: cartItemRef)
                    print("Transaction: Added new item \(documentId) with quantity \(quantity)")
                } catch let setDataError as NSError {
                     errorPointer?.pointee = setDataError
                     return nil
                }
            }

            return nil

        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Transaction successfully committed.")
                completion(.success(()))
                 NotificationCenter.default.post(name: .cartDidChange, object: nil)
            }
        }
    }

    func removeFromCart(productId: String, completion: @escaping (Result<Void, Error>) -> Void) {
         guard let userId = currentUserId else {
              completion(.failure(NSError(domain: "CartManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
              return
          }
         if productId.isEmpty {
              completion(.failure(NSError(domain: "CartManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Product ID is missing or empty"])))
               return
          }
        let documentId = "\(userId)_\(productId)"
        let cartItemRef = db.collection("users").document(userId).collection(cartCollectionName).document(documentId)


        cartItemRef.delete() { error in
            if let error = error {
                print("Error removing cart item (\(documentId)): \(error)")
                completion(.failure(error))
            } else {
                print("Successfully removed cart item (\(documentId)) from cart")
                completion(.success(()))
                NotificationCenter.default.post(name: .cartDidChange, object: nil)
            }
        }
    }

    func updateItemQuantity(productID: String, quantity: Int, completion: @escaping (Error?) -> Void) {
         guard let userId = currentUserId else {
              completion(NSError(domain: "CartManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
              return
          }
        if productID.isEmpty {
            completion(NSError(domain: "CartManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Product ID is missing or empty"]))
            return
        }
         guard quantity >= 0 else {
             completion(NSError(domain: "CartManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Quantity cannot be negative"]))
             return
         }
        let documentId = "\(userId)_\(productID)"
        let cartItemRef = db.collection("users").document(userId).collection(cartCollectionName).document(documentId)
         db.runTransaction({ (transaction, errorPointer) -> Any? in
             let documentSnapshot: DocumentSnapshot
             do {
                 documentSnapshot = try transaction.getDocument(cartItemRef)
             } catch let fetchError as NSError {
                 errorPointer?.pointee = fetchError
                 return nil
             }

             guard documentSnapshot.exists else {
                 let error = NSError(domain: "CartManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Cart item not found for update"])
                 errorPointer?.pointee = error
                 return nil
             }

             transaction.updateData([
                 "quantity": quantity,
                 "timestamp": FieldValue.serverTimestamp()
             ], forDocument: cartItemRef)
             print("Transaction: Updated quantity for item \(documentId) to \(quantity)")

             return nil

         }) { (object, error) in
             if let error = error {
                 print("Error updating cart item quantity \(documentId): \(error.localizedDescription)")
                 completion(error)
             } else {
                 print("Successfully updated cart item quantity \(documentId) to \(quantity)")
                 completion(nil)
                 NotificationCenter.default.post(name: .cartDidChange, object: nil)
             }
         }
     }

    func addCartItemsListener(completion: @escaping (Result<[CartItem], Error>) -> Void) -> ListenerRegistration? {
        guard let userId = currentUserId else {
             completion(.failure(NSError(domain: "CartManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
             return nil
         }
        
        let cartCollectionRef = db.collection("users").document(userId).collection(cartCollectionName)


        let listener = cartCollectionRef
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { querySnapshot, error in

                if let error = error {
                    print("Error fetching cart items: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No cart documents found for user \(userId)")
                    completion(.success([]))
                    return
                }

                let cartItems = documents.compactMap { document -> CartItem? in
                     do {
                         var item = try document.data(as: CartItem.self)
                         if item.quantity <= 0 { return nil }
                         return item
                     } catch {
                         print("Error decoding cart item document \(document.documentID): \(error)")
                         return nil
                     }
                 }

                print("Fetched \(cartItems.count) cart items for user \(userId)")
                completion(.success(cartItems))
            }

        return listener
    }

    func addCartItemCountListener(completion: @escaping (Result<Int, Error>) -> Void) -> ListenerRegistration? {
        guard let userId = currentUserId else {
            completion(.failure(NSError(domain: "CartManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return nil
        }
        let cartCollectionRef = db.collection("users").document(userId).collection(cartCollectionName)
        
                let listener = cartCollectionRef
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching cart item count: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                let totalQuantity = querySnapshot?.documents.reduce(0) { (sum, document) -> Int in
                    let data = document.data()
                    let quantity = data["quantity"] as? Int ?? 0
                    return sum + (quantity > 0 ? quantity : 0)
                } ?? 0
                
                
                print("Fetched total cart item quantity: \(totalQuantity) for user \(userId)")
                completion(.success(totalQuantity))
            }
        
        return listener}
}

extension Notification.Name {
    static let cartDidChange = Notification.Name("cartDidChange")
}
