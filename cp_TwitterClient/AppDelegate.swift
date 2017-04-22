//
//  AppDelegate.swift
//  cp_TwitterClient
//
//  Created by Jonathan Wong on 4/10/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import ChameleonFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard = UIStoryboard(name: "Main", bundle: nil)
    var menuNavController: UINavigationController!
    var homeNavController: UINavigationController!
    var slideOutViewController: SlideOutViewController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.userDidLogout), name: NSNotification.Name(UserDidLogoutNotification), object: nil)
        
        UINavigationBar.appearance().barTintColor = UIColor.flatMint
        UINavigationBar.appearance().tintColor = UIColor.flatSand
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.flatWhite]
        
//        if User.currentUser != nil {
//            // go to the logged in screen
//            let vc = storyboard.instantiateViewController(withIdentifier: "TweetsNavController")
////            let vc = storyboard.instantiateViewController(withIdentifier: "TweetsViewController")
//            window?.rootViewController = vc
//            print(User.currentUser!)
//        }
        
        let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuNavController = UINavigationController(rootViewController: menuVC)
        menuVC.delegate = self
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
        homeNavController = UINavigationController(rootViewController: homeVC)
        
        slideOutViewController = SlideOutViewController(leftViewController: menuNavController, mainViewController: homeNavController, overlap: 50)
        window?.rootViewController = slideOutViewController
        
        return true
    }
    
    func userDidLogout() {
        let vc = storyboard.instantiateInitialViewController()
        window?.rootViewController = vc
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        TwitterClient.sharedInstance.openURL(url: url)
        
        return true
    }
    
}

extension AppDelegate: MenuViewControllerDelegate {
    func menuViewController(_ controller: MenuViewController, didSelectRow row: Int) {
        let dataSource = controller.menuSource
//        public let menuSource = ["Profile", "Timeline", "Mentions", "Account"]
        if "profile" == dataSource[row].lowercased() {
            let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            vc.user = User.currentUser
            homeNavController.setViewControllers([vc], animated: true)
            slideOutViewController.closeSideBarAnimated(animated: true)
        } else if "timeline" == dataSource[row].lowercased() {
            let vc = storyboard.instantiateViewController(withIdentifier: "TweetsViewController")
            homeNavController.setViewControllers([vc], animated: true)
            slideOutViewController.closeSideBarAnimated(animated: true)
        } else if "mentions" == dataSource[row].lowercased() {
            let vc = storyboard.instantiateViewController(withIdentifier: "MentionsViewController")
            homeNavController.setViewControllers([vc], animated: true)
            slideOutViewController.closeSideBarAnimated(animated: true)
        } else if "account" == dataSource[row].lowercased() {
            let vc = storyboard.instantiateViewController(withIdentifier: "AccountViewController")
            homeNavController.setViewControllers([vc], animated: true)
            slideOutViewController.closeSideBarAnimated(animated: true)
        }
        
    }
}

