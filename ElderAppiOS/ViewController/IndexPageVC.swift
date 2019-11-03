//
//  IndexPageVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/3.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit
import WebKit

class IndexPageVC: UIViewController {

    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var contantStackView: UIView!
    
    @IBOutlet weak var panelView1: UIView!
    @IBOutlet weak var panelView2: UIView!
    @IBOutlet weak var bannerWebView: WKWebView!
    
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
        
    }
    


}
