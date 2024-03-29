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
    
    func loadOrderDetail(orderNumero:String){
        titleLabel.text = "訂單管理"
        let urlString = "\(Service.host)/order/detail/\(orderNumero)?token=\(UserDefaults.standard.getToken() ?? "")&noFooter=1"
        loadWebView(urlString: urlString)
    }
    
    func loadOrderList(){
        titleLabel.text = "訂單管理"
        let urlString = "\(Service.host)/order/list?token=\(UserDefaults.standard.getToken() ?? "")&noFooter=1"
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
    
    func loadApplyInsuranceUrl(){
        titleLabel.text = "申請保險"
        let urlString = "\(Service.host)/insurance/apply?token=\(UserDefaults.standard.getToken() ?? "")"
        loadWebView(urlString: urlString)
    }
    
    func loadVolunteerLogUrl(){
        titleLabel.text = "志工服務記錄"
        let urlString = "\(Service.host)/clinic/volunteer/log?token=\(UserDefaults.standard.getToken() ?? "")"
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
