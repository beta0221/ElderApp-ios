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
    @IBOutlet weak var panelView3: UIView!
    @IBOutlet weak var bannerWebView: WKWebView!
    
    
    
    @IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var myWalletLabel: UILabel!
    @IBOutlet weak var myLevelLabel: UILabel!
    
    @IBOutlet weak var orgRankLabel: UILabel!
    @IBOutlet weak var orgRankOutterView: UIView!
    
    @IBAction func unwind_IndexPageVC(_ sender:UIStoryboardSegue){}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bannerView.translatesAutoresizingMaskIntoConstraints=false
        
        let url:URL = URL(string: "\(Service.hostName)/slider.html")!
        let urlRequest:URLRequest = URLRequest(url: url)
        bannerWebView.load(urlRequest)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMyData), name: Notification.Name("updateMyData"), object: nil)
        
        
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateMyData()
    }
    
    
    @objc private func updateMyData(){
        
        AD.service.MeRequest(completion: {
            result in switch result{
            case .success(let response):
                if(response["user_id"] != nil){
                    self.myNameLabel.text = response["name"] as? String
                    self.myWalletLabel.text = "\(response["wallet"] as? Int ?? 0)"
                    self.myLevelLabel.text = "\(response["rank"] as? Int ?? 0)"
                    
                    if let org_rank = response["org_rank"] as? Int{
                        if(org_rank >= 3){
                            self.orgRankOutterView.isHidden = false
                            switch org_rank {
                            case 3:
                                self.orgRankLabel.text = "大天使"
                            case 4:
                                self.orgRankLabel.text = "守護天使"
                            case 5:
                                self.orgRankLabel.text = "領航天使"
                            default:
                                break
                            }
                        }
                    }else{
                        self.orgRankOutterView.isHidden = true
                    }
                }
            case .failure(let error):
                print("錯誤:\(error)")
            }
        })
        
    }
    
    
//    private func autoReLogin(){
//
//        AD.service.LoginRequest(completion: {result in
//            switch result{
//            case .success(let response):
//                if(response["access_token"] != nil){
//                    print("access_token : \(response["access_token"] as! String)")
//                    UserHelper.storeUser(response: response)
//                    self.updateMyData()
//                }else if(response["ios_update_url"] != nil){
//                    let ios_update_url = response["ios_update_url"] as? String ?? ""
//                    guard let url = URL(string: ios_update_url) else { return }
//                    Common.SystemAlert(Title: "訊息", Body: "您目前的版本過舊，請進行更新", SingleBtn: "OK", viewController: self, handler: {_ in
//                        UIApplication.shared.open(url,completionHandler: {_ in
//                            self.autoLogout()
//                        })
//                    })
//                }else{
//                    print("response 沒有回來 token, Server fucked up")
//                    self.autoLogout()
//                }
//            case .failure(let error):
//                print("An error occured \(error)")
//                self.autoLogout()
//            }
//        })
//    }
    
//    private func autoLogout(){
//        print("自動登出")
//        UserDefaults.standard.removeUserData()
//        self.navigateToLoginPage()
//    }
    
//    private func navigateToLoginPage(){
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginPageVC") as! LoginPageVC
//        let navigationController = UINavigationController(rootViewController: newViewController)
//        self.view.window?.rootViewController = navigationController
//    }
    
    
    @IBAction func loadProductList(_ sender: Any) {
        let board = UIStoryboard(name: "Main", bundle: nil)
        let vc = board.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.modalPresentationStyle = .currentContext
        self.present(vc,animated: true,completion: {
            vc.loadProductList()
        })
    }
    
    
    @IBAction func viewMyGroup(_ sender: Any) {
        let board = UIStoryboard(name: "Main", bundle: nil)
        let vc = board.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.modalPresentationStyle = .currentContext
        self.present(vc,animated: true,completion: {
            vc.loadMyGroupMember()
        })
    }
    

}
