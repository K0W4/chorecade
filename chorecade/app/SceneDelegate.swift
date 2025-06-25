//
//  SceneDelegate.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 06/06/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        Task {
            await Repository.start()
            let window = UIWindow(windowScene: windowScene)
            window.overrideUserInterfaceStyle = .light
            
//            if let userRecord = Repository.userRecord{
//                
//                if userRecord["nickname"] is String {
//                    
//                    let tabBarController = TabBarController()
//                    window.rootViewController = tabBarController
//                    
//                } else {
//                    let tabBarController = UserDataViewController()
//                    window.rootViewController = tabBarController
//                }
//                
//            } else {
//                let tabBarController = PermissionViewController()
//                window.rootViewController = tabBarController
//                print("Nickname não encontrado no userRecord.")
//            }
            
            let tabBarController = GroupDetailsViewController()
            window.rootViewController = tabBarController
            
            self.window = window
            window.makeKeyAndVisible()
        }
        
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = false) {
        guard let window = self.window else {
            return
        }
        
        // change the root view controller to your specific view controller
        if animated {
            UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: {
                window.rootViewController = vc
            }, completion: nil)
        } else {
            window.rootViewController = vc
        }
        // pesquisar coordinator - animacoes
        window.rootViewController = vc
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
