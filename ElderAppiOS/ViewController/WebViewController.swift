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
        addDismissButton()
    }
    
    func loadProductList(){
        titleLabel.text = "銀髮商城"
        let urlString = "\(Service.hostName)/product/list?token=\(UserDefaults.standard.getToken() ?? "")"
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        webview.load(urlRequest)
    }
    
//    private func getIdCode(){
//        AD.service.MyAccountRequest(completion: {result in
//            switch result{
//            case .success(let res):
//                if let id_code = res["id_code"] as? String{
//                    self.loadWebView(id_code: id_code)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        })
//    }
    
//    private func loadWebView(id_code:String){
//        let urlString = "\(Service.hostName)/member_tree/\(id_code)"
//        guard let url = URL(string: urlString) else {return}
//        let urlRequest = URLRequest(url: url)
//        webview.load(urlRequest)
//    }
    


}
