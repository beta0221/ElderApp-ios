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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 5
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func login(_ sender: Any) {
    
        
        guard let email = emailTextfield.text else {return}
        guard let password = passwordTextfield.text else {return}
        
        let service = Service()
        service.LoginRequest(Email: email, Password: password,completion: {result in
            switch result{
            case .success(let response):
                if(response["access_token"] != nil){
                    
                    let result = UserHelper.storeUser(response: response, password: password)
                    if(result){
                        self.navigateToIndexPage()
                    }
                    
                }else{
                    print("帳號密碼錯誤")
                    let controller = UIAlertController(title: "錯誤", message: "帳號密碼錯誤", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    controller.addAction(okAction)
                    self.present(controller, animated: true, completion: nil)
                }
            case .failure(let error):
                print("An error occured \(error)")
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
