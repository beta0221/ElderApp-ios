//
//  SceneDelegate.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/3.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase
import FirebaseCore
import FirebaseCrashlytics
import FirebaseMessaging
import LineSDK

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let _ = (scene as? UIWindowScene) else { return }
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        //disable 深夜模式
        window?.overrideUserInterfaceStyle = .light
        
        //LINE SDK
        LoginManager.shared.setup(channelID: "1655872039", universalLinkURL: nil)
        
        // Initiazlie Firebase
        FirebaseApp.configure()
        // Set Firebase messaging delegate
        Messaging.messaging().delegate = AD as MessagingDelegate
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        
        UNUserNotificationCenter.current().delegate = AD
         
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (state, error) in
        }
        
        //UIApplication.shared.registerForRemoteNotifications()
        
        
        
        
        
        if(UserDefaults.standard.getAccount() != nil){
            self.navigateToIndexPage()
            AD.autoReLogin()
        }else{
            self.navigateToLoginPage()
        }
        
        
        self.window?.makeKeyAndVisible()
        
        
    }
    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        if(UserDefaults.standard.getAccount() != nil){
            AD.checkIfTokenAlife()
        }
        
    }
    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    @available(iOS 13.0, *)
    private func navigateToIndexPage(){
        let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
        let rootNC = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = rootNC
    }
    @available(iOS 13.0, *)
    private func navigateToLoginPage(){
        let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPageVC")
        //let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostPageVC")
        let rootNC = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = rootNC
    }

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
            let path = components.path else {
                return
        }
        print("path = \(path)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            AD.handleUniversalLinks(path: path)
        }
    }
    
    /**
        Deep Link
     */
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        //Line Login
        _ = LoginManager.shared.application(.shared, open: URLContexts.first?.url)
        
    }
    
}

