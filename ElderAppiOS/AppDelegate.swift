//
//  AppDelegate.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/3.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let service = Service()
    var window: UIWindow?
    //for qrcode scanner

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //支援12.4加上去的
        if #available(iOS 13.0, *) {
            // In iOS 13 setup is done in SceneDelegate
        } else {
            
            
            let window = UIWindow(frame: UIScreen.main.bounds)
            self.window = window

            var isLogin = false

            if(UserDefaults.standard.getAccount() != nil){
                isLogin = true
            }
            if(isLogin == true){
                self.navigateToIndexPage()
            }else{
                self.navigateToLoginPage()
            }
//            self.window?.makeKeyAndVisible()
        }
        
        
        return true
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //支援12.4加上去的
        if #available(iOS 13.0, *) {
            // In iOS 13 setup is done in SceneDelegate
        } else {
            if(UserDefaults.standard.getAccount() != nil){
                self.checkIfTokenAlife()
            }
        }
    }
    private func navigateToIndexPage(){
        let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
        let rootNC = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = rootNC
    }
    private func navigateToLoginPage(){
        let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPageVC")
        let rootNC = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = rootNC
    }
    private func checkIfTokenAlife(){
        print("check if token alife")
        AD.service.MeRequest(completion: {result in
            switch result{
                case .success(let res):
                    if(res["user_id"] == nil){
                        self.autoReLogin()
                    }
                case .failure(_):
                    self.autoReLogin()
            }
        })
    }
    private func autoReLogin(){
        
        print("auto relogin")
        AD.service.LoginRequest(completion: {result in
            switch result{
            case .success(let response):
                if(response["access_token"] != nil){
                    
                    UserHelper.storeUser(response: response)
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
    private func autoLogout(){
        UserDefaults.standard.removeUserData()
        self.navigateToLoginPage()
    }
    
    

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ElderAppiOS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}



let AD = UIApplication.shared.delegate as! AppDelegate
let viewContext = AD.persistentContainer.viewContext
