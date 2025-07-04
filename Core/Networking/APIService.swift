import Foundation

enum APIError: Error {
    case requestFailed(Error)
    case itemNotFound
    case unknownError
}

class APIService {

    static let shared = APIService()

    private init() {}

    func fetchAllProducts(completion: @escaping (Result<[Product], APIError>) -> Void) {
        
        print("Mock API: Fetching all products...")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            if !mockProducts.isEmpty {
                print("Mock API: Successfully fetched \(mockProducts.count) products.")
                completion(.success(mockProducts))
            } else {
                print("Mock API: Error - Mock data is empty.")
                completion(.failure(.itemNotFound))
            }
        }
    }

    func fetchProductDetail(for productId: String, completion: @escaping (Result<Product, APIError>) -> Void) {
        
        print("Mock API: Fetching detail for product ID: \(productId)...")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let product = mockProducts.first(where: { $0.id == productId }) {
                print("Mock API: Successfully found detail for product ID: \(productId).")
                completion(.success(product))
            } else {
                print("Mock API: Error - Product with ID \(productId) not found in mock data.")
                completion(.failure(.itemNotFound))
            }
        }
    }
}
