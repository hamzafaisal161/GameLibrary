//
//  AppDelegate.swift
//  gameLibrary
//
//  Created by Hamza Faisal on 24/02/2023.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        do{
            let realm = try Realm() //using Realm database for storage
            try realm.write{
            }
        }catch{
            print("\(C.realmError) \(error)")
        }
        let tabBarController = UITabBarController() //creating tabBarController
        let listVC = GameListController()
        listVC.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1.0) //setting up two 2 view controllers for tabBarControllers
        listVC.view.backgroundColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1.0)
        let favoritesVC = FavoriteListController()
        listVC.tabBarItem = UITabBarItem(title: "Games", image: UIImage(named: "Vector.png"), tag: 0)
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        favoritesVC.view.backgroundColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1.0)
        let controllers = [listVC, favoritesVC]
        tabBarController.viewControllers = controllers
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: tabBarController) //creating a navigation controller as root controller and
        // adding tabBarController in it
        tabBarController.tabBar.backgroundColor = UIColor(red: 248/256, green: 248/256, blue: 248/256, alpha: 1.0)
        return true
    }

}

