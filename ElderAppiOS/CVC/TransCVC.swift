//
//  TransCVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/4.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class TransCVC: UICollectionViewCell {
    
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    func setTransCell(tran:TransactionElement){
        backView.layer.cornerRadius = 8
        if(tran.event == "" || tran.event == nil){
            eventLabel.text = "無"
        }else{
            eventLabel.text = tran.event
        }
        
        targetLabel.text = tran.targetName
        dateLabel.text = tran.createdAt?.substring(to: 10)
        amountLabel.text = "\(tran.amount ?? 0)"
        
        if(tran.giveTake == 1){
            
            amountLabel.textColor = UIColor(red: 1/255, green: 144/255, blue: 35/255, alpha: 1)
        }else{
            amountLabel.textColor = UIColor(red: 194/255, green: 24/255, blue: 16/255, alpha: 1)
        }
    }
    
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
