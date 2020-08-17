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
        
        
        // Initiazlie Firebase
        FirebaseApp.configure()
        // Set Firebase messaging delegate
        Messaging.messaging().delegate = AD
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        
        UNUserNotificationCenter.current().delegate = AD
         
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (state, error) in
        }
        
        //UIApplication.shared.registerForRemoteNotifications()
        
        
        
        
        
        if(UserDefaults.standard.getAccount() != nil){
            self.navigateToIndexPage()
            self.autoReLogin()
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
            self.checkIfTokenAlife()
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
    private func checkIfTokenAlife(){
        print("check if token alife")
        AD.service.MeRequest(completion: {result in
            switch result{
                case .success(let res):
                    if(res["user_id"] == nil){
                        self.autoReLogin()
                    }
                    
                    UserHelper.storeUser(res: res)
                case .failure(_):
                    self.autoReLogin()
            }
        })
    }
    @available(iOS 13.0, *)
    private func autoReLogin(){
        
        print("auto relogin")
        AD.service.LoginRequest(completion: {result in
            switch result{
            case .success(let response):
                if(response["access_token"] != nil){
                    
                    UserHelper.storeUser(res: response)
                    print("token refreshed")
                    
                }else if(response["ios_update_url"] != nil){
                    
                    print("ios version out-of-date")
                    let ios_update_url = response["ios_update_url"] as? String ?? ""
                    guard let url = URL(string: ios_update_url) else { return }
                    Common.SystemAlert(Title: "訊息", Body: "您目前的版本過舊，請進行更新", SingleBtn: "OK", viewController: (self.window?.rootViewController)!, handler: {_ in
                        UIApplication.shared.open(url,completionHandler: {_ in
                            self.autoLogout()
                        })
                    })
                    
                }else{
                    
                    print("response 沒有回來 token, Server fucked up")
                    self.autoLogout()
                    
                }
            case .failure(let error):
                
                print("An error occured \(error)")
                self.autoLogout()
                
            }
        })
    }
    @available(iOS 13.0, *)
    private func autoLogout(){
        UserDefaults.standard.removeUserData()
        self.navigateToLoginPage()
    }

}

