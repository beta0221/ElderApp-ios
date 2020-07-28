//
//  ProductCVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/12/8.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class ProductCVC: UICollectionViewCell {
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    func setProductCVC(product:NSDictionary){
        
        outterView.Theme()
        
        let imgUrl = product["imgUrl"] as? String ?? ""
        productImage.loadImageUsingUrlString(urlString: imgUrl)
        nameLabel.text = "商品：\(product["name"] as? String ?? "")"
        priceLabel.text = "樂幣：\((product["price"] as? Int)?.description ?? "")"
    }
    
    
}
