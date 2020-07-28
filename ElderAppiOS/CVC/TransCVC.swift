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
    
    
    
    func setCell(tran:NSDictionary){
        backView.layer.cornerRadius = 8
        let event = tran["event"] as? String ?? ""
        if(event.isEmpty){
            eventLabel.text = "無"
        }else{
            eventLabel.text = event
        }
        
        targetLabel.text = tran["target_name"] as? String
        dateLabel.text = "(\((tran["created_at"] as? String)?.substring(to: 10) ?? ""))"
        
        let amount = tran["amount"] as? Int ?? 0
        if let giveTake = tran["give_take"] as? Int{
            if(giveTake == 1){
                amountLabel.text = "+\(amount)"
                amountLabel.textColor = UIColor(red: 1/255, green: 144/255, blue: 35/255, alpha: 1)
            }else{
                amountLabel.text = "-\(amount)"
                amountLabel.textColor = UIColor(red: 194/255, green: 24/255, blue: 16/255, alpha: 1)
            }
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
