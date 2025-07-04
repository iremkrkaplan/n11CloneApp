//
//  SceneDelegate.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 30.06.2025.
//

import UIKit
import Combine
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var authStateCancellable: AnyCancellable?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        authStateCancellable = FirebaseManager.shared.$isUserLoggedIn
            .sink { [weak self] isLoggedIn in
                print("DEBUG: SceneDelegate - Auth state changed: isUserLoggedIn = \(isLoggedIn)")
                self?.setRootViewController(isLoggedIn: isLoggedIn)
            }

        setRootViewController(isLoggedIn: FirebaseManager.shared.isUserLoggedIn)
        print("DEBUG: SceneDelegate - Initial root view controller set based on Auth state.")
        self.window = window

        window.makeKeyAndVisible()

        print("DEBUG: SceneDelegate willConnectTo session called. Window setup complete.")
    }

    func setRootViewController(isLoggedIn: Bool) {
        guard let window = self.window else { return }
        let newViewController: UIViewController

        if isLoggedIn {
            print("DEBUG: setRootViewController - Kullanıcı giriş yapmış (\(FirebaseManager.shared.getCurrentUserId() ?? "N/A")), Ana Ekran gösteriliyor.")
            newViewController = MainTabBarController()
        } else {
            print("DEBUG: setRootViewController - Kullanıcı giriş yapmamış, Giriş/Kayıt akışı gösteriliyor.")
    
            let accountVC = AccountViewController()
            let navController = UINavigationController(rootViewController: accountVC)
            newViewController = navController
        }
        if let currentViewController = window.rootViewController {
             if type(of: currentViewController) != type(of: newViewController) {
                 let snapshot = window.snapshotView(afterScreenUpdates: true)!
                 newViewController.view.addSubview(snapshot)
                 window.rootViewController = newViewController
                 UIView.animate(withDuration: 0.5, animations: {
                     snapshot.alpha = 0
                 }, completion: { _ in
                     snapshot.removeFromSuperview()
                 })
                 print("DEBUG: setRootViewController - UI geçişi yapıldı.")
             } else {
                 print("DEBUG: setRootViewController - Root ViewController zaten doğru durumda veya aynı tipte, geçiş atlandı.")
                 window.rootViewController = newViewController
             }
         } else {
             window.rootViewController = newViewController
             print("DEBUG: setRootViewController - İlk root ViewController ayarlandı (animasyonsuz).")
         }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        authStateCancellable?.cancel()
        print("DEBUG: SceneDelegate sceneDidDisconnect. Auth state listener aboneliği iptal edildi.")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("DEBUG: SceneDelegate sceneDidBecomeActive.")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("DEBUG: SceneDelegate sceneWillResignActive.")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("DEBUG: SceneDelegate sceneWillEnterForeground.")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("DEBUG: SceneDelegate sceneDidEnterBackground.")
    }
}
