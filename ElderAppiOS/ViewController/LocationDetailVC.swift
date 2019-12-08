//
//  LocationDetailVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/12/8.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class LocationDetailVC: UIViewController {

    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outterView.clipsToBounds=true
        outterView.layer.cornerRadius = 5
    }
    
    func setLocationDetail(location:NSDictionary){
        nameLabel.text = "名稱:\(location["name"] as? String ?? "")"
        addressLabel.text = "地址:\(location["address"] as? String ?? "")"
        linkLabel.text = "連結:\(location["link"] as? String ?? "")"
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
