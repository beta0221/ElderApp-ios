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
        
        self.loadUserData()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    private func loadUserData(){
        
        self.orgRankOutterView.isHidden = true
        self.myNameLabel.text = nil
        self.myWalletLabel.text = nil
        self.myLevelLabel.text = nil
        self.orgRankLabel.text = nil
        
        self.myNameLabel.text = UserDefaults.standard.getUserName()
        
        if let wallet = UserDefaults.standard.getWallet(){
            self.myWalletLabel.text = wallet.description
        }
        if let rank = UserDefaults.standard.getRank(){
            self.myLevelLabel.text = rank.description
        }
        if let org_rank = UserDefaults.standard.getOrgRank(){
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
        }
        
    }
    
    @objc private func updateMyData(){
        
        AD.service.MeRequest(completion: {
            result in switch result{
            case .success(let response):
                UserHelper.storeUser(res: response)
                self.loadUserData()
            case .failure(let error):
                print("錯誤:\(error)")
            }
        })
        
    }
    
    
    
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
