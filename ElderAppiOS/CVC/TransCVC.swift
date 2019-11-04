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
        backView.layer.cornerRadius = 5
        if(tran.event == ""){
            eventLabel.text = "無"
        }else{
            eventLabel.text = tran.event
        }
        
        targetLabel.text = tran.targetName
        dateLabel.text = tran.createdAt?.substring(to: 10)
        amountLabel.text = "\(tran.amount ?? 0)"
        
        if(tran.giveTake == 1){
            amountLabel.textColor = .green
        }else{
            amountLabel.textColor = .red
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
