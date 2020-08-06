//
//  LoginPageVC.swift
//  ElderAppiOS
//
//  Created by Movark on 2019/11/4.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit
import CoreData

class LoginPageVC: UIViewController {

    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func unwindLoginPageVC(_ sender:UIStoryboardSegue){}
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 5
    
        if let controller = storyboard?.instantiateViewController(withIdentifier: "StatementVC") as? StatementVC{            
            self.present(controller, animated: true, completion: nil)
        }

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    
    
    
    @IBAction func login(_ sender: Any) {
        
        guard let email = emailTextfield.text else {return}
        guard let password = passwordTextfield.text else {return}
        
        Spinner.start()
        AD.service.LoginRequest(Email: email, Password: password,completion: {result in
            switch result{
            case .success(let response):
                DispatchQueue.main.async {Spinner.stop()}
                if(response["access_token"] != nil){
                    
                    UserHelper.storeUser(res: response, password: password)
                    self.navigateToIndexPage()
                    UIApplication.shared.registerForRemoteNotifications()
                    
                }else if(response["ios_update_url"] != nil){
                    
                    let ios_update_url = response["ios_update_url"] as? String ?? ""
                    guard let url = URL(string: ios_update_url) else { return }
                    UIApplication.shared.open(url)
                    
                }else{
                    print("帳號密碼錯誤")
                    Common.SystemAlert(Title: "錯誤", Body: "帳號或密碼錯誤", SingleBtn: "OK", viewController: self)
                }
            case .failure(let error):
                print("An error occured \(error)")
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
                
    }
    
    private func navigateToIndexPage(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        let navigationController = UINavigationController(rootViewController: newViewController)
        self.view.window!.rootViewController = navigationController
    }
    
    


}
