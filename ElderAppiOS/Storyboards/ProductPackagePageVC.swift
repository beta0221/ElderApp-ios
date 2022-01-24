//
//  ProductPackagePageVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2022/1/24.
//  Copyright © 2022 林奕儒. All rights reserved.
//

import UIKit
import WebKit

class ProductPackagePageVC: UIViewController {

    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var infoWKView: WKWebView!
    var slug:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoWKView.navigationDelegate = self
        addDismissButton()
        getProductPackage()
        
    }
    
    
    private func getProductPackage(){
        Spinner.start()
        AD.service.GetProductPackages(slug: slug, completion: { result in
            switch result{
            case .success(let res):
                
                guard let product = res["product"] as? NSDictionary else{ return }
                
                let urlString = product["imgUrl"] as? String ?? ""
                
                self.productImage.loadImageUsingUrlString(urlString: urlString)
                self.productTitleLabel.text = product["name"] as? String ?? ""
                
                
                let html = "<style>body{font-family:'Arial';font-size:32px;}</style>\(product["info"] as? String ?? "")"
                self.infoWKView.loadHTMLString(html, baseURL: nil)
                
                
                DispatchQueue.main.async {Spinner.stop()}
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
    }

    
    private func setWKViewBodyHeight(_ height:CGFloat){
        for con in infoWKView.constraints{
            if(con.identifier == "WKViewHeight"){
                con.constant = height
            }
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
            }
        }
    }

    

}



extension ProductPackagePageVC:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    if let _height = height as? CGFloat{
                        self.setWKViewBodyHeight(_height + 100.0)
                    }
                })
            }
        })
        
    }
}

