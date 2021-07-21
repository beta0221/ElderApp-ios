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
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var pointCashTitleView: UIView!
    @IBOutlet weak var pointCashView: UIView!
    @IBOutlet weak var cashTitleView: UIView!
    @IBOutlet weak var cashView: UIView!
    
    @IBOutlet weak var payCashPriceLabel: UILabel!
    @IBOutlet weak var payCashPointLabel: UILabel!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var originalCashLabel: UILabel!
    
    

    
    var listType:ListType = .free
    
    func setProductCVC(product:NSDictionary,listType:ListType){
        
        self.listType = listType
        switch self.listType {
            case .free:
                priceView.isHidden = false
                pointCashTitleView.isHidden = true
                pointCashView.isHidden = true
                cashTitleView.isHidden = true
                cashView.isHidden = true
            case .cash:
                priceView.isHidden = true
                pointCashTitleView.isHidden = false
                pointCashView.isHidden = false
                cashTitleView.isHidden = false
                cashView.isHidden = false
        }
        
        productImage.image = UIImage(named: "event_default")
        outterView.Theme()
        
        let imgUrl = product["imgUrl"] as? String ?? ""
        productImage.loadImageUsingUrlString(urlString: imgUrl)
        
        nameLabel.text = product["name"] as? String
        
        priceLabel.text = "樂幣：\((product["price"] as? Int)?.description ?? "")"
        
        payCashPriceLabel.text = (product["pay_cash_price"] as? Int)?.description ?? ""
        payCashPointLabel.text = (product["pay_cash_point"] as? Int)?.description ?? ""
        cashLabel.text = (product["cash"] as? Int)?.description ?? ""
        let originalCashString = "原價：\((product["original_cash"] as? Int)?.description ?? "")"
        originalCashLabel.attributedText = NSAttributedString(string: originalCashString, attributes:[NSAttributedString.Key.strikethroughStyle:1])
        
        
        
        
        
    }
    
    
}
