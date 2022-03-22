//
//  SceneDelegate.swift
//  CoreDataExample
//
//  Created by Илья on 04.03.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        let todoViewController = TODOViewController()
        let todoNavigationController = UINavigationController(rootViewController: todoViewController)
        todoNavigationController.tabBarItem = UITabBarItem(title: "TO-DO", image: UIImage(systemName: "command.square.fill"), selectedImage: nil)
        
        let carsViewController = CarsViewController()
        let carsNavigationController = UINavigationController(rootViewController: carsViewController)
        carsNavigationController.tabBarItem = UITabBarItem(title: "Cars", image: UIImage(systemName: "car.fill"), selectedImage: nil)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [todoNavigationController, carsNavigationController]
        tabBarController.selectedViewController = carsNavigationController
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
