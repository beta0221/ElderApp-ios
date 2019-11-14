//
//  StatementVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/11.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class StatementVC: UIViewController {

    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.clipsToBounds=true
        contentView.layer.cornerRadius = 12
        
    }
    

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
