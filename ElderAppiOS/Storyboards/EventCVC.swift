//
//  EventCVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/5.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class EventCVC: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var peopleView: UIView!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    
    func setCell(event:NSDictionary){
        
        backView.Theme()
        eventImageView.image = UIImage(named: "event_default")
        
        if let imgUrl = event["imgUrl"] as? String{
            eventImageView.loadImageUsingUrlString(urlString: imgUrl)
        }
        
        titleLabel.text = event["name"] as? String
        categoryLabel.text = "\(event["cat"] as? String ?? "")(\(event["district"] as? String ?? ""))"
        
        rewardLabel.text = ""
        if let reward = event["reward"] as? Int{
            rewardLabel.text = "獎勵\(reward.description)"
        }
        
        
        if let type = event["type"] as? Int{
            if(type == 1){
                let date = (event["dateTime"] as? String ?? "").substring(to: 10)
                dateLabel.text = date
            }else{
                dateLabel.text = "週期性活動"
            }
        }
        peopleView.clipsToBounds=true
        peopleView.layer.cornerRadius=4
        peopleLabel.text = "\((event["people"] as? Int ?? 0).description) / \((event["maximum"] as? Int ?? 0).description)"
        
    }
    
    
   
}

