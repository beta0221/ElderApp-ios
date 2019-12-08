//
//  LocationCell.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/12/8.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class LocationCell: UIView {

    var location:NSDictionary?
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var checkButton: CheckBox!
    
    var delegate:LocationCellDelegate?
    
    required init?(location:NSDictionary) {
        super.init(frame:.zero)
        self.location = location
        
        
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("LocationCell", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        commonInit()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(){
        locationNameLabel.text = location!["name"] as? String ?? ""
        checkButton.tag = location!["id"] as! Int
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