//
//  MyOrderCVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/12/8.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class MyOrderCVC: UICollectionViewCell {
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var purchaseDateLabel: UILabel!
    
    
    func setMyOrderCVC(order:NSDictionary){
        
        outterView.Theme()
        let urlString = order["imgUrl"] as? String ?? ""
        productImage.loadImageUsingUrlString(urlString: urlString)
        productNameLabel.text = "產品:\(order["name"] as? String ?? "")"
        locationLabel.text = "據點:\(order["location_name"] as? String ?? "")"
        addressLabel.text = "地址:\(order["address"] as? String ?? "")"
        purchaseDateLabel.text = "兌換時間:\(order["created_at"] as? String ?? "")"
        if(order["receive"] as? Int == 1){
            statusImage.isHidden = false
        }else{
            statusImage.isHidden = true
        }
    }
    
}
