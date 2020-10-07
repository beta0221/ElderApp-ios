//
//  LikeButton.swift
//  ElderAppiOS
//
//  Created by Movark on 2020/8/18.
//  Copyright © 2020 林奕儒. All rights reserved.
//

import UIKit

class LikeButton: UIButton {

    let likeImage:UIImage = UIImage(named: "icon_like")!
    let unlikeImage:UIImage = UIImage(named: "icon_unlike")!

    var hasLiked = false
    override func awakeFromNib() {
        self.setImage(unlikeImage, for: .normal)
        self.imageView?.contentMode = .scaleToFill
    }
    
    func like(){
        self.setImage(likeImage, for: .normal)
        self.hasLiked = true
    }
    
    func unlike(){
        self.setImage(unlikeImage, for: .normal)
        self.hasLiked = false
    }

}
