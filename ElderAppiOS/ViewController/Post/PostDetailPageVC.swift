//
//  PostDetailPageVC.swift
//  ElderAppiOS
//
//  Created by Movark on 2020/8/18.
//  Copyright © 2020 林奕儒. All rights reserved.
//

import UIKit

class PostDetailPageVC: UIViewController {

    
    var delegate:PostDetailDelegate?
    
    @IBOutlet weak var userImage: RoundImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleImageOutterView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var likeButton: LikeButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var commentStackview: UIStackView!
    
    var slug = ""
    var page:Int = 1
    var hasNextPage:Bool = false
    var isLoading:Bool = false
    //var commentViewList:[CommentView] = []
    @IBOutlet weak var notFoundOutterView: UIView!
    
    
    @IBOutlet weak var textViewBottomConstrait: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstrait: NSLayoutConstraint!
    @IBOutlet weak var commentTextview: UITextView!
    @IBOutlet weak var submitButtonOutterView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(slug.isEmpty){ return }
        getPostDetail()
        getCommentList()
        keyboardDissmissable()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func getCommentList(){
        isLoading = true
        AD.service.getCommentList(slug: self.slug,page:self.page, completion: {result in
            switch result{
            case .success(let res):
                self.isLoading = false
                if let commentList = res["commentList"] as? [NSDictionary]{
                    if(self.page == 1 && commentList.count == 0){self.notFoundOutterView.isHidden = false}
                    for comment in commentList{
                        //self.commentViewList.append(CommentView(comment: comment))
                        self.commentStackview.addArrangedSubview(CommentView(comment:comment))
                    }
                }
                if let hasNextPage = res["hasNextPage"] as? Bool{
                    self.hasNextPage = hasNextPage
                    if(hasNextPage){
                        self.page += 1
                    }
                }
                //DispatchQueue.main.async {Spinner.stop()}
            case .failure(let error):
                print(error)
                self.isLoading = false
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
                    if let post_image = post["post_image"] as? String{
                        if(!post_image.isEmpty){
                            self.titleImageOutterView.isHidden = false
                            self.titleImage.loadImageUsingUrlString(urlString: post_image)
                        }
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
    
    @IBAction func submitComment(_ sender: Any) {
        if(self.slug.isEmpty){ return }
        if(self.commentTextview.text.isEmpty){ return }
        Spinner.start()
        AD.service.commentOnPost(slug: self.slug, comment: self.commentTextview.text, completion: { result in
            switch result{
            case .success(let res):
                if let alert = res["alert"] as? String{
                    DispatchQueue.main.async {
                        Spinner.stop()
                        Common.SystemAlert(Title: "訊息", Body: alert, SingleBtn: "確定", viewController: self)
                    }
                    return
                }
                
                if(!self.hasNextPage){
                    if let comment = res["comment"] as? NSDictionary{
                        self.commentStackview.addArrangedSubview(CommentView(comment: comment))
                    }
                }
                self.commentsInscrease()
                self.notFoundOutterView.isHidden = true
                DispatchQueue.main.async {
                    self.commentTextview.text = ""
                    Spinner.stop()
                }
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
            case .success(let res):
                if let alert = res["alert"] as? String{
                    DispatchQueue.main.async {
                        Spinner.stop()
                        Common.SystemAlert(Title: "訊息", Body: alert, SingleBtn: "確定", viewController: self)
                    }
                }else{
                    DispatchQueue.main.async {
                        self.likeButton.like()
                        self.likesInscrease()
                        Spinner.stop()
                    }
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.textViewHeightConstrait.constant = 112.0
            self.textViewBottomConstrait.constant = keyboardHeight - self.view.safeAreaInsets.bottom
            self.view.layoutIfNeeded()
            self.submitButtonOutterView.isHidden = true
        }
    }
    @objc func keyboardWillHide(_ sender:Any){
        self.textViewHeightConstrait.constant = 56.0
        self.textViewBottomConstrait.constant = 0
        self.view.layoutIfNeeded()
        self.submitButtonOutterView.isHidden = false
    }

    override func didMove(toParent parent: UIViewController?) {
        if !(parent?.isEqual(self.parent) ?? false) {
            self.delegate?.updatePost(likes: self.likesLabel.text ?? "", comments: self.commentsLabel.text ?? "")
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension PostDetailPageVC:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var isBottom = false
        if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)){
            isBottom = true
        }
        
        if(isBottom && !self.isLoading && self.hasNextPage){
            self.getCommentList()
        }
        
    }
}


extension PostDetailPageVC:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "留言..." {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "留言..."
            textView.textColor = UIColor.lightGray
        }
    }
}
