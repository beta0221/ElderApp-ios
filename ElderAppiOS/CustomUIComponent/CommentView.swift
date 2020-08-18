//
//  CommentView.swift
//  ElderAppiOS
//
//  Created by Movark on 2020/8/18.
//  Copyright © 2020 林奕儒. All rights reserved.
//

import UIKit

class CommentView: UIView {

   @IBOutlet var contentView: UIView!

    @IBOutlet weak var userImage: RoundImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    required init(comment:NSDictionary) {
        super.init(frame: .zero)
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("CommentView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
//        self.contentView.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.backgroundColor = .black
        
        if let user_name = comment["user_name"] as? String {
            self.userNameLabel.text = user_name
        }
        if let user_image = comment["user_image"] as? String {
            self.userImage.loadImageUsingUrlString(urlString: user_image)
        }else{
            self.userImage.image = UIImage(named: "user_default")
        }
        if let date = comment["created_at"] as? String {
            self.dateLabel.text = date.substring(to: 10)
        }
        if let body = comment["body"] as? String {
            self.bodyLabel.text = body
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
