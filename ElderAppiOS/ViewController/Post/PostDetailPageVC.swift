//
//  PostDetailPageVC.swift
//  ElderAppiOS
//
//  Created by Movark on 2020/8/18.
//  Copyright © 2020 林奕儒. All rights reserved.
//

import UIKit

class PostDetailPageVC: UIViewController {

    
    @IBOutlet weak var userImage: RoundImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var likeButton: LikeButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var commentStackview: UIStackView!
    
    var slug = ""
    var page:Int = 1
    var hasNextPage:Bool = false
    var commentViewList:[CommentView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(slug.isEmpty){ return }
        getPostDetail()
        getCommentList()
        
    }
    private func getCommentList(){
        AD.service.getCommentList(slug: self.slug,page:self.page, completion: {result in
            switch result{
            case .success(let res):
                if let hasNextPage = res["hasNextPage"] as? Bool{
                    self.hasNextPage = hasNextPage
                }
                
                if let commentList = res["commentList"] as? [NSDictionary]{
                    for comment in commentList{
                        //self.commentViewList.append(CommentView(comment: comment))
                        self.commentStackview.addArrangedSubview(CommentView(comment:comment))
                    }
                }
                print("done")
                //DispatchQueue.main.async {Spinner.stop()}
            case .failure(let error):
                print(error)
                //DispatchQueue.main.async {Spinner.stop()}
            }
        })
    }
    
    private func getPostDetail(){
        Spinner.start()
        AD.service.getPostDetail(slug: self.slug, completion: {result in
            switch result{
            case .success(let res):
                
                if let hasLiked = res["hasLiked"] as? Bool{
                    if(hasLiked){self.likeButton.like()}
                }
                if let post = res["post"] as? NSDictionary {
                    if let imgUrl = post["user_image"] as? String{
                        self.userImage.loadImageUsingUrlString(urlString: imgUrl)
                    }
                    if let user_name = post["user_name"] as? String{
                        self.userNameLabel.text = user_name
                    }
                    if let title = post["title"] as? String{
                        self.titleLabel.text = title
                    }
                    if let body = post["body"] as? String{
                        self.bodyLabel.text = body
                    }
                    if let created_at = post["created_at"] as? String{
                        self.dateLabel.text = created_at.substring(to: 10)
                    }
                    if let likes = post["likes"] as? Int{
                        self.likesLabel.text = likes.description
                    }
                    if let comments = post["comments"] as? Int{
                        self.commentsLabel.text = comments.description
                    }
                }
                DispatchQueue.main.async {Spinner.stop()}
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
    }
    
    
    @IBAction func clickLikeButton(_ sender: LikeButton) {
        if(sender.hasLiked){
            self.unlikePost()
        }else{
            self.likePost()
        }
    }
    private func likePost(){
        if (self.slug.isEmpty) {return}
        Spinner.start()
        AD.service.likePost(slug: self.slug, completion: {result in
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    self.likeButton.like()
                    self.likesInscrease()
                    Spinner.stop()
                }
            case .failure(_):
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
    }
    private func unlikePost(){
        if (self.slug.isEmpty) {return}
        Spinner.start()
        AD.service.unlikePost(slug: self.slug, completion: {result in
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    self.likeButton.unlike()
                    self.likesDecrease()
                    Spinner.stop()
                }
            case .failure(_):
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
    }
    private func likesInscrease(){
        guard let _likes = Int(self.likesLabel.text ?? "") else { return }
        let likes = _likes + 1
        self.likesLabel.text = likes.description
    }
    private func likesDecrease(){
        guard let _likes = Int(self.likesLabel.text ?? "") else { return }
        if(_likes <= 0){ return }
        let likes = _likes - 1
        self.likesLabel.text = likes.description
    }
    private func commentsInscrease(){
        guard let _comments = Int(self.commentsLabel.text ?? "") else { return }
        let comments = _comments + 1
        self.commentsLabel.text = comments.description
    }
    private func commentsDecrease(){
        guard let _comments = Int(self.commentsLabel.text ?? "") else { return }
        if(_comments <= 0){ return }
        let comments = _comments - 1
        self.commentsLabel.text = comments.description
    }
    


}
