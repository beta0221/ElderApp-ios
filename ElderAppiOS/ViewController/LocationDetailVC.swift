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
    @IBOutlet weak var linkButton: UIButton!
    var link:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outterView.clipsToBounds=true
        outterView.layer.cornerRadius = 5
    }
    
    func setLocationDetail(location:NSDictionary){
        nameLabel.text = "名稱:\(location["name"] as? String ?? "")"
        addressLabel.text = "地址:\(location["address"] as? String ?? "")"
        if(location["link"] != nil){
            linkButton.setTitle(location["link"] as? String, for: .normal)
        }else{
            linkButton.isHidden = true
        }
        link = location["link"] as? String
    }
    
    @IBAction func openLink(_ sender: Any) {
        guard let url = URL(string: self.link!) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
}
