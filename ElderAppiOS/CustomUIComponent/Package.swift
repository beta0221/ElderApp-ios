//
//  Package.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2022/1/24.
//  Copyright © 2022 林奕儒. All rights reserved.
//

import UIKit

class Package:UIView{
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var avgPriceLabel: UILabel!
    
    weak var delegate:PackageDelegate?
    
    var id:Int?
    
    init(_ package:NSDictionary) {
        super.init(frame: .zero)
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("Package", owner: self, options: nil)
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 6
        
        
        guard let id = package["id"] as? Int,
              let quantity = package["quantity"] as? Int,
              let price = package["price"] as? Int,
              let price_per_item = package["price_per_item"] as? Int else { return }
        
        self.id = id
        priceLabel.text = "\(quantity.description)組 - \(price)元"
        avgPriceLabel.text = "平均單價：\(price_per_item.description)元"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapPackage))
        view.addGestureRecognizer(tap)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func tapPackage(_ sender:Any){
        guard let _id = self.id else { return }
        self.delegate?.tap(id: _id)
    }
    
}

protocol PackageDelegate:AnyObject {
    func tap(id:Int)
}
