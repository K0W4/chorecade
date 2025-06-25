import UIKit

class TabBarController: UITabBarController {
    lazy var taskTabItem: UINavigationController = {
        // setup tabItem
        let title = "Tasks"
        let image = UIImage(systemName: "checklist")
        let tabItem = UITabBarItem(title: title, image: image, selectedImage: image)
        
        // setup rootViewController
        let rootViewController = TaskListViewController()
        rootViewController.tabBarItem = tabItem
        
        // setup navigationController
        let navController = UINavigationController(rootViewController: rootViewController)
        return navController
    }()
    
    lazy var rankTabItem: UINavigationController = {
        // setup tabItem
        let title = "Rank"
        let image = UIImage(systemName: "trophy")
        let tabItem = UITabBarItem(title: title, image: image, selectedImage: image)
        
        // setup rootViewController
        let rootViewController = RankingViewController()
        rootViewController.tabBarItem = tabItem
        
        // setup navigationController
        let navController = UINavigationController(rootViewController: rootViewController)
        return navController
    }()
    
    lazy var groupTabItem: UINavigationController = {
        // setup tabItem
        let title = "Group"
        let image = UIImage(systemName: "person.3")
        let tabItem = UITabBarItem(title: title, image: image, selectedImage: image)
        
        // setup rootViewController
        let rootViewController = CreateGroupViewController()
        rootViewController.tabBarItem = tabItem
        
        // setup navigationController
        let navController = UINavigationController(rootViewController: rootViewController)
        return navController
    }()
    
    lazy var profileTabItem: UINavigationController = {
        // setup tabItem
        let title = "Profile"
        let image = UIImage(systemName: "person")
        let tabItem = UITabBarItem(title: title, image: image, selectedImage: image)
        
        // setup rootViewController
        let rootViewController = ProfileViewController()
        rootViewController.tabBarItem = tabItem
        
        // setup navigationController
        let navController = UINavigationController(rootViewController: rootViewController)
        return navController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            taskTabItem,
            rankTabItem,
            groupTabItem,
            profileTabItem
        ]
        tabBar.backgroundColor = .white
        tabBar.tintColor = .primaryPurple300
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.systemGray2.cgColor
        tabBar.unselectedItemTintColor = .systemGray2
    }
}
