//
//  PostCVC.swift
//  ElderAppiOS
//
//  Created by Movark on 2020/8/17.
//  Copyright © 2020 林奕儒. All rights reserved.
//

import UIKit

class PostCVC: UICollectionViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postImageOutterView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var likeOutterView: UIView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    func setCVC(post:NSDictionary){
        
        postImageOutterView.isHidden = true
        
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 6
        
        userImage.clipsToBounds=true
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        self.userImage.image = UIImage(named: "user_default")
        
        likeOutterView.clipsToBounds=true
        likeOutterView.layer.cornerRadius = 6
        
        if let imgUrl = post["user_image"] as? String{
            userImage.loadImageUsingUrlString(urlString: imgUrl)
        }
        
        if let user_name = post["user_name"] as? String{
            userNameLabel.text = user_name
        }
        
        if let post_image = post["post_image"] as? String {
            if(!post_image.isEmpty){
                postImageOutterView.isHidden = false
                self.postImage.loadImageUsingUrlString(urlString: post_image)
            }
        }
        
        if let title = post["title"] as? String{
            titleLabel.text = title
        }
        
        if let body = post["body"] as? String{
            bodyLabel.text = body
        }
        
        if let created_at = post["created_at"] as? String{
            dateLabel.text = created_at.substring(to: 10)
        }
        
        if let likes = post["likes"] as? Int{
            likesLabel.text = likes.description
        }
        
        if let comments = post["comments"] as? Int{
            commentsLabel.text = comments.description
        }
        
    }
    
    func updateData(likes:String,comments:String){
        likesLabel.text = likes
        commentsLabel.text = comments
    }
}
