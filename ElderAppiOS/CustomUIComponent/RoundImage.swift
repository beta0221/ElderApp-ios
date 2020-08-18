//
//  RoundImage.swift
//  ElderAppiOS
//
//  Created by Movark on 2020/8/18.
//  Copyright © 2020 林奕儒. All rights reserved.
//

import UIKit

class RoundImage: UIImageView {

    
    
    override func awakeFromNib() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
    }

}
