//
//  LoginPageVC.swift
//  ElderAppiOS
//
//  Created by Movark on 2019/11/4.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit
import CoreData
import LineSDK

class LoginPageVC: UIViewController {

    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var lineLoginButton: UIButton!
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func unwindLoginPageVC(_ sender:UIStoryboardSegue){}
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 5
        lineLoginButton.layer.cornerRadius = 5
    
        if let controller = storyboard?.instantiateViewController(withIdentifier: "StatementVC") as? StatementVC{
            self.present(controller, animated: true, completion: nil)
        }

        keyboardDissmissable()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func errorAlert(){
        Common.SystemAlert(Title: "錯誤", Body: "帳號或密碼錯誤", SingleBtn: "OK", viewController: self)
    }
    
    
    @IBAction func login(_ sender: Any) {
        
        guard let email = emailTextfield.text,
              let password = passwordTextfield.text else {
            errorAlert()
            return
        }
        
        if(email.isEmpty || password.isEmpty){
            errorAlert()
            return
        }
        
        Spinner.start()
        AD.service.LoginRequest(Email: email, Password: password,completion: {result in
            switch result{
            case .success(let response):
                DispatchQueue.main.async {
                    Spinner.stop()
                    self.handleToken(response: response, password: password)
                }
            case .failure(let error):
                print("An error occured \(error)")
                DispatchQueue.main.async {Spinner.stop()}
                Common.SystemAlert(Title: "錯誤", Body: "伺服器錯誤", SingleBtn: "OK", viewController: self)
            }
        })
                
    }
    
    private func handleToken(response:NSDictionary,password:String? = nil,lineId:String? = nil){
        UserHelper.handleToken(response: response, password: password, lineId: lineId, complition: {
            self.navigateToIndexPage()
        })
    }
    
    
    
    @IBAction func lineLoginAction(_ sender: Any) {
        Spinner.start()
        LoginManager.shared.login(permissions: [.profile], in: self){ result in
            switch result{
            case .success(let loginResult):
                DispatchQueue.main.async {Spinner.stop()}
                if let profile = loginResult.userProfile {
                    self.lineLoginRequest(userID: profile.userID)
                }
            case .failure(let error):
                DispatchQueue.main.async {Spinner.stop()}
                print(error)
            }
        }
    }
    
    private func lineLoginRequest(userID:String){
        Spinner.start()
        AD.service.lineLogin(userID: userID, completion: {result in
            switch result{
            case .success(let res):
                DispatchQueue.main.async {
                    Spinner.stop()
                    self.handleToken(response: res, lineId: userID)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    Spinner.stop()
                    Common.SystemAlert(Title: "訊息", Body: "尚未綁定此Line帳號。\n若已有會員帳號請先進行綁定\n或先進行註冊", SingleBtn: "確定", viewController: self)
                }
                print(error)
            }
        })
    }
    
    
    private func navigateToIndexPage(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        let navigationController = UINavigationController(rootViewController: newViewController)
        self.view.window!.rootViewController = navigationController
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.contentScrollView.setContentOffset(CGPoint(x: 0, y: 160), animated: true)
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            let keyboardHeight = keyboardSize.height
//        }
    }
    
    @objc func keyboardWillHide(_ sender:Any){
        self.contentScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

}



