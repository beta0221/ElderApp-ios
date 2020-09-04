//
//  WebViewController.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2020/3/16.
//  Copyright © 2020 林奕儒. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addDismissButton()
    }
    
    func loadProductList(){
        titleLabel.text = "銀髮商城"
        let urlString = "\(Service.host)/product/list?token=\(UserDefaults.standard.getToken() ?? "")"
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        webview.load(urlRequest)
    }
    
    func loadUrl(urlString:String,title:String){
        titleLabel.text = title
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        webview.load(urlRequest)
    }
    
    func loadMyGroupMember(){
        titleLabel.text = "我的組織"
        let urlString = "\(Service.host)/memberGroupMembers?token=\(UserDefaults.standard.getToken() ?? "")"
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        webview.load(urlRequest)
    }
    
    @IBAction func exit(_ sender: Any) {
        dismiss(animated:true,completion: nil)
    }
    

}
