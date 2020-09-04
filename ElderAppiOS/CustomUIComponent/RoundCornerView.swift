//
//  RoundCornerView.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2020/8/20.
//  Copyright © 2020 林奕儒. All rights reserved.
//

import UIKit

class RoundCornerView: UIImageView {

    override func awakeFromNib() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
    }

}
class RoundButton:UIButton{
    override func awakeFromNib() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
    }
}
