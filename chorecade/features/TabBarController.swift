
import UIKit

class TabBarController: UITabBarController {
    lazy var taskTabItem: UINavigationController = {
        // setup tabItem
        let title = "Tasks"
        let image = UIImage(systemName: "calendar.badge.plus")
        let tabItem = UITabBarItem(title: title, image: image, selectedImage: image)
        
        // setup rootViewController
        let rootViewController = TaskListViewController()
        rootViewController.tabBarItem = tabItem
        
        // setup navigationController
        let navController = UINavigationController(rootViewController: rootViewController)
        return navController
    }()
    
    lazy var groupTabItem: UINavigationController = {
        // setup tabItem
        let title = "Groups"
        let image = UIImage(systemName: "dollarsign.circle")
        let tabItem = UITabBarItem(title: title, image: image, selectedImage: image)
        
        // setup rootViewController
        let rootViewController = CreateGroupViewController()
        rootViewController.tabBarItem = tabItem
        
        // setup navigationController
        let navController = UINavigationController(rootViewController: rootViewController)
        return navController
    }()
    
//
//    
//    lazy var profileTabItem: UINavigationController = {
//        // setup tabItem
//        let title = "Perfil"
//        let image = UIImage(systemName: "person")
//        let tabItem = UITabBarItem(title: title, image: image, selectedImage: image)
//        
//        
//        // setup rootViewController
//        let rootViewController = ProfileController()
//        rootViewController.tabBarItem = tabItem
//        rootViewController.view.backgroundColor = .white
//        
//        // setup navigationController
//        let navController = UINavigationController(rootViewController: rootViewController)
//        return navController
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            taskTabItem,
            groupTabItem,
        ]
        tabBar.backgroundColor = .background
        tabBar.tintColor = .primaryPurple300
        tabBar.unselectedItemTintColor = .black50
    }
}
