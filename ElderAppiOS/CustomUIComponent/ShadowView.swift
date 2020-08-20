//
//  ShadowView.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2020/8/20.
//  Copyright © 2020 林奕儒. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override func awakeFromNib() {
        self.layer.cornerRadius = 6
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.4
    }

}
