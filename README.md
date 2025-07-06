# N11 Clone Application - Core Feature Development

This project is a study developed to advance my mobile development skills and deepen my understanding of modern iOS application development practices. It mimics the fundamental functions n11 e-commerce application. During the project development process, the focus was on building the basic building blocks and making the core features functional.

## Approach and Architecture

*   **Programmatic UI:** Instead of Storyboard and XIB files, a completely programmatic UI approach has been adopted for user interface design. This was preferred to gain more control over UI components and to learn Auto Layout principles at the code level.

*   **Modular Structure:** A modular folder structure (`Features`, `Core`, `Models`, `Networking`) has been used to ensure the project is organized, understandable, and scalable in the future. Care has been taken to separate the code into layers.

*   **Mock Data Source:** Local mock data has been used as the primary data source for the application.

*   **Backend Services:** Firebase Authentication and Firestore services have been integrated for user authentication, management, and data storage/management needs.

## Developed Core Features

Below is a list of the main features that have been made functional as a result of the project's development process:

*   **Full Programmatic UI:** All core screens of the application (Login/Register, Home, Categories, Cart, My Lists, My Account, Product Detail) have been created using code, and Auto Layout constraints have been managed programmatically.

*   **Modular Folder Structure:** Application layers and feature areas are organized into clearly separated folders.

*   **Basic Navigation Structure:** A 5-tab `UITabBarController` has been integrated to navigate between the main sections of the application, and transitions between screens (`UINavigationController` with push/pop) are provided programmatically.

*   **Firebase Authentication Integration:** Firebase Authentication SDK has been integrated for users to register and log in with email and password. Basic authentication flows and session control at application launch have been implemented.

*   **Mock Data Usage:** Locally prepared mock data has been used to provide the product and related information needed by the application.

*   **Home Screen Development:**
    *   Product lists obtained from mock data are displayed on a `UICollectionView`.
    *   Custom `UICollectionViewCell` classes (for different product types) have been created with programmatic UI to showcase products in the CollectionView.
    *   The CollectionView's layout has been laid out to support different section structures (e.g., horizontally scrollable or vertical grid) for various product types.

*   **Product Detail Screen:**
    *   A separate screen to display the details of the selected product has been designed with programmatic UI.
    *   When a product on the Home screen is tapped, the relevant product's mock detail data is fetched, and the transition to the detail screen is provided.

*   **Firebase Firestore Integration (Favorite Management):**
    *   Firebase Firestore database has been integrated.
    *   A basic data structure has been established to store user-based favorite products.
    *   The logic for adding or removing a product from favorites on the product detail screen has been linked with Firestore (add/status check functionality).
    *   On the My Lists screen, the user's favorited products are listed by fetching them from Firestore in real-time.

*   **Kingfisher Integration:** The Kingfisher library has been included in the project to asynchronously and efficiently load product images from URLs and has been used for image loading operations.

## Technologies Used

*   Swift
*   UIKit (Programmatic UI)
*   Firebase (Authentication, Firestore)
*   Kingfisher (Image Loading)
*   Codable (Data Modeling)

## Project Structure

The project is built on the following modular structure:

```
├── Core
│   ├── Firebase
│   │   ├── FavoritesManager.swift
│   │   └── FirebaseManager.swift
│   ├── Models
│   │   └── Product.swift
│   ├── Networking
│   │   └── APIService.swift
│   └── Utilities
│       └── ColorConstants.swift
├── Features
│   ├── Account
│   │   └── AccountViewController.swift
│   ├── Authentication
│   │   ├── AuthPopupViewController.swift
│   │   └── AuthViewController.swift
│   ├── Cart
│   │   └── CartViewController.swift
│   ├── Categories
│   │   └── CategoriesViewController.swift
│   ├── CommonUI
│   │   ├── CustomSearchBar.swift
│   │   ├── Extensions.swift
│   │   └── FilterSortBarView.swift
│   ├── Favorites
│   │   ├── FavoriteProductCell.swift
│   │   └── FavoritesViewController.swift
│   ├── Home
│   │   ├── Cells
│   │   ├── HomeHeaderView.swift
│   │   ├── HomeViewController.swift
│   │   ├── Layouts
│   │   └── MockData.swift
│   └── ProductDetail
│       └── ProductDetailViewController.swift
├── Launch Screen.storyboard
├── N11CloneApp
│   ├── AppDelegate.swift
│   ├── GoogleService-Info.plist
│   ├── Info.plist
│   ├── MainTabBarController.swift
│   └── SceneDelegate.swift
└── Resources
    └── Assets.xcassets
```
