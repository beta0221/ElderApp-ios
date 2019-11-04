//
//  IndexPageVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/3.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class IndexPageVC: UIViewController {

    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var contantStackView: UIView!
    
    @IBOutlet weak var panelView1: UIView!
    @IBOutlet weak var panelView2: UIView!
    @IBOutlet weak var bannerWebView: WKWebView!
    
    
    
    @IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var myWalletLabel: UILabel!
    @IBOutlet weak var myLevelLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bannerView.translatesAutoresizingMaskIntoConstraints=false
        panelView1.translatesAutoresizingMaskIntoConstraints=false
        panelView2.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([
            bannerView.heightAnchor.constraint(equalToConstant: self.view.frame.width / 2),
            panelView1.heightAnchor.constraint(equalToConstant: self.view.frame.width / 2),
            panelView2.heightAnchor.constraint(equalToConstant: self.view.frame.width / 2),
        ])
        
        let url:URL = URL(string: "https://www.happybi.com.tw/slider.html")!
        let urlRequest:URLRequest = URLRequest(url: url)
        bannerWebView.load(urlRequest)
        
        
        updateMyData()
        

        
    }
    
    
    
    private func updateMyData(){
        let service = Service()
        service.MeRequest(completion: {
            result in switch result{
            case .success(let response):
                if(response["user_id"] != nil){
                    self.myNameLabel.text = response["name"] as? String
                    self.myWalletLabel.text = "\(response["wallet"] as? Int ?? 0)"
                    self.myLevelLabel.text = "\(response["rank"] as? Int ?? 0)"
                }else{
                    print("token 過期 重新登入")
                }
//                self.myNameLabel.text = re
            case .failure(let error):
                print("錯誤:\(error)")
            }
        })
        
    }
    
    
    private func autoReLogin(){
        let service = Service()
        service.LoginRequest(completion: {result in
            switch result{
            case .success(let response):
                if(response["access_token"] != nil){
                    
                    let result = UserHelper.storeUser(response: response)
                    if(result != true){
                        self.autoLogout()
                    }
                    
                }else{
                    self.autoLogout()
                }
            case .failure(let error):
                print("An error occured \(error)")
            }
        })
    }
    
    private func autoLogout(){
        print("自動登出")
        _ = UserHelper.clearUser()
        self.navigateToLoginPage()
    }
    
    private func navigateToLoginPage(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginPageVC") as! LoginPageVC
        let navigationController = UINavigationController(rootViewController: newViewController)
        self.view.window?.rootViewController = navigationController
    }
    
    


}
