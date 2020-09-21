//
//  AppDelegate.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/3.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase

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
            
            // Initiazlie Firebase
            FirebaseApp.configure()
            // Set Firebase messaging delegate
            Messaging.messaging().delegate = self
            // Register for remote notifications. This shows a permission dialog on first run, to
            // show the dialog at a more appropriate time move this registration accordingly.
            if #available(iOS 10.0, *) {
              UNUserNotificationCenter.current().delegate = self
             
              let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
              UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (state, error) in
              }
            } else {
              let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
              application.registerUserNotificationSettings(settings)
            }
            //application.registerForRemoteNotifications()
            

            if(UserDefaults.standard.getAccount() != nil){
                self.navigateToIndexPage()
                self.autoReLogin()
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
                    
                    UserHelper.storeUser(res: res)
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
    private func autoLogout(){
        UserDefaults.standard.removeUserData()
        self.navigateToLoginPage()
    }
    
    
    func application(_: UIApplication, continue userActivity: NSUserActivity, restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
            let path = components.path else {
                return false
        }
        print("path = \(path)")
        self.handleUniversalLinks(path: path)
        return true
    }
    
    
    func handleUniversalLinks(path:String){
        var vc:UIViewController?
        if(path.contains("/app/product/")){
            let url = path.components(separatedBy: "/")
            if url.count < 3 { return }
            let slug = url[2]
            
            let board = UIStoryboard(name: "Main", bundle: nil)
            guard let _vc = board.instantiateViewController(withIdentifier: "ProductDetailPageVC") as? ProductDetailPageVC else {return}
            _vc.slug = slug
            vc = _vc
        }else if(path.contains("/app/event/")){
            let url = path.components(separatedBy: "/")
            if url.count < 3 { return }
            let slug = url[2]
            
        }else{
            return
        }
        
        
        if(vc == nil){ return }
        var topController:UIViewController?
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes
            .first!.delegate as! SceneDelegate
            topController = sceneDelegate.window?.rootViewController
        } else {
            topController = self.window?.rootViewController
        }
        
        if topController != nil{
            while let presentedViewController = topController!.presentedViewController {
                topController = presentedViewController
            }
            topController!.present(vc!,animated: true)
        }
        
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



@available(iOS 10,*)
extension AppDelegate:UNUserNotificationCenterDelegate{
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
          
      let userInfo = notification.request.content.userInfo
      print("willPresent userInfo: \(userInfo)")
          
      completionHandler([.badge, .sound, .alert])
    }
      
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
          
      let userInfo = response.notification.request.content.userInfo
      print("didPresent userInfo: \(userInfo)")
          
      completionHandler()
    }
}
extension AppDelegate: MessagingDelegate {
    
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("Firebase registration token: \(fcmToken)")
        
    let dataDict:[String: String] = ["token": fcmToken]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    
    if(UserDefaults.standard.getAccount() == nil){ return }
    
    service.SetPushToken(push_token: fcmToken, completion: {_ in
        print("Set push token complete.")
    })
  }
    
//  func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//    print("Received data message: \(remoteMessage.appData)")
//  }
}
