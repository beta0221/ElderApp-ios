//
//  PassPermitVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/20.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class PassPermitVC: UIViewController {

    var eventTitle:String?
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTitleLabel.text = eventTitle
        
    }
    


}
