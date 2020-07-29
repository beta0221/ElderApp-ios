//
//  LocationCell.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/12/8.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class LocationCell: UIView {

    var location:NSDictionary!
    var quantity:Int!
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var checkButton: CheckBox!
    
    var delegate:LocationCellDelegate?
    
    required init?(location:NSDictionary,quantity:Int,isCheck:Bool=false) {
        super.init(frame:.zero)
        self.location = location
        self.quantity=quantity
        
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("LocationCell", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        if(isCheck){
            checkButton.isChecked=true
        }
        commonInit()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(){
        let name = location["name"] as? String ?? ""
        locationNameLabel.text = "\(name)(數量:\(self.quantity.description))"
        let location_id = location["location_id"] as? Int ?? 0
        checkButton.tag = location_id
        self.tag = location_id
    }
    
    func uncheckButton(){
        checkButton.isChecked=false
    }
    
    @IBAction func showLocationDetail(_ sender: Any) {
        self.delegate?.showLocationDetail(location: self.location!)
    }
    
    
    @IBAction func selectLocation(_ sender: CheckBox) {
        if(!sender.isChecked){
            self.delegate?.select(id: sender.tag)
        }else{
            self.delegate?.deSelect()
        }
        
    }
    

}
