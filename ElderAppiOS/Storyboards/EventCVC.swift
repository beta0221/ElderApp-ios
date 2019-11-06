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
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var eventStackview: UIStackView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var peopleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var event:EventElement?
    
//    var CategoryDic:Dictionary<Int,String>?
//    var DistrictDic:Dictionary<Int,String>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func SetEventItem(event:EventElement,catDic:Dictionary<Int,String>,disDic:Dictionary<Int,String>){
        self.event = event
        backView.layer.cornerRadius = 8
        
        if(event.image != "" || event.image != nil){
            let urlString = "\(Service.hostName)/images/events/\(event.slug ?? "")/\(event.image ?? "")"
            eventImage.loadImageUsingUrlString(urlString:urlString)
        }else{
            eventImage.image = UIImage(named: "event_default")
        }
        
        eventImage.contentMode = .scaleAspectFill
        eventImage.layer.cornerRadius = eventImage.frame.width / 2
        
        titleLabel.text = event.title
        
        categoryLabel.text = "\(catDic[event.categoryID!] ?? "")-\(disDic[event.districtID!] ?? "")"
        locationLabel.text = event.location
        dateLabel.text = event.dateTime
        peopleLabel.text = "人數：\(event.people ?? 0) / \(event.maximum ?? 0)"
    }
    
    
   
}

