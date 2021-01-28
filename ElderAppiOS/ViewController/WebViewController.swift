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
        loadWebView(urlString: urlString)
    }
    
    func loadUrl(urlString:String,title:String){
        titleLabel.text = title
        loadWebView(urlString: urlString)
    }
    
    func loadMyGroupMember(){
        titleLabel.text = "我的組織"
        let urlString = "\(Service.host)/memberGroupMembers?token=\(UserDefaults.standard.getToken() ?? "")"
        loadWebView(urlString: urlString)
    }
    
    func loadLocationUrl(locationUrl:String){
        titleLabel.text = "據點管理"
        let urlString = "\(Service.host)/\(locationUrl)?token=\(UserDefaults.standard.getToken() ?? "")"
        loadWebView(urlString: urlString)
    }
    
    func loadMyCourseUrl(myCourseUrl:String){
        titleLabel.text = "課程管理"
        let urlString = "\(Service.host)/\(myCourseUrl)?token=\(UserDefaults.standard.getToken() ?? "")"
        loadWebView(urlString: urlString)
    }
    
    private func loadWebView(urlString:String){
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        webview.load(urlRequest)
    }
    
    @IBAction func exit(_ sender: Any) {
        dismiss(animated:true,completion: nil)
    }
    

}
