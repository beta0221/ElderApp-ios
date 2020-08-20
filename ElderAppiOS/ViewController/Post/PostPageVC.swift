//
//  PostPageVC.swift
//  ElderAppiOS
//
//  Created by Movark on 2020/8/17.
//  Copyright © 2020 林奕儒. All rights reserved.
//

import UIKit

enum PostType{
    case allPost
    case myPost
}

class PostPageVC: UIViewController {

    @IBOutlet weak var postCollectionView: UICollectionView!
    var postList:[NSDictionary] = []
    var showPostIndex:Int?
    
    var page:Int = 1
    var rows:Int = 0
    var total:Int = 0

    var postType:PostType = .allPost
    
    @IBOutlet weak var allPostButton: UIButton!
    @IBOutlet weak var myPostButton: UIButton!
    
    
    @IBOutlet weak var paginationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationController?.navigationBar.barTintColor = .lightGray
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        allPostButton.clipsToBounds=true
        myPostButton.clipsToBounds=true
        allPostButton.layer.cornerRadius = 4
        myPostButton.layer.cornerRadius = 4
        
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        getPostList()
    }
    
    private func getPostList(){
        if(self.postType == .allPost){
            self.getAllPostList()
        }else{
            self.getMyPostList()
        }
    }
    
    func getAllPostList(){
        Spinner.start()
        AD.service.getPostList(page: self.page, completion: {result in
            switch result{
            case .success(let res):
                self.loadPostList(res: res)
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
    }
    func getMyPostList(){
        Spinner.start()
        AD.service.getMyPostList(page: self.page, completion: {result in
            switch result{
            case .success(let res):
                self.loadPostList(res: res)
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
    }
    
    private func loadPostList(res:NSDictionary){
        if let postList = res["postList"] as? [NSDictionary]{
            self.postList = postList
        }
        
        if let pagination = res["pagination"] as? NSDictionary,
            let total = res["total"] as? Int,
            let skip = pagination["skip"] as? Int,
            let rows = pagination["rows"] as? Int{
            
            self.rows = rows
            self.total = total
            
            let from = skip + 1
            var to = skip + rows
            if (to > total){ to = total }
            DispatchQueue.main.async {
                self.paginationLabel.text = "\(from.description)~\(to.description)/\(total.description)"
            }
        }
        
        DispatchQueue.main.async {
            Spinner.stop()
            self.postCollectionView.reloadData()
            self.postCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    @IBAction func showMyPost(_ sender: Any) {
        if(self.postType == .myPost){return}
        self.allPostButton.backgroundColor = .none
        self.myPostButton.backgroundColor = UIColor(displayP3Red: 254/255, green: 114/255, blue: 53/255, alpha: 100)
        self.postType = .myPost
        self.page = 1
        self.getPostList()
    }
    
    @IBAction func showAllPost(_ sender: Any) {
        if(self.postType == .allPost){return}
        self.allPostButton.backgroundColor = UIColor(displayP3Red: 254/255, green: 114/255, blue: 53/255, alpha: 100)
        self.myPostButton.backgroundColor = .none
        self.postType = .allPost
        self.page = 1
        self.getPostList()
    }
    
    
    
    @IBAction func prevPage(_ sender: Any) {
        if(self.page <= 1){ return }
        self.page -= 1
        self.getPostList()
    }
    
    
    @IBAction func nextPage(_ sender: Any) {
        
        var pageLength = self.total / self.rows
        if(self.total % self.rows != 0){ pageLength += 1 }
        if(self.page + 1 > pageLength){ return }
        
        self.page += 1
        self.getPostList()
    }
    
    @IBAction func showNewPostPage(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPostPageVC") as! NewPostPageVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    


}

protocol NewPostPageDelegate {
    func reload()->Void
}
extension PostPageVC:NewPostPageDelegate{
    func reload() {
        self.page = 1
        self.getPostList()
    }
}


protocol  PostDetailDelegate {
    func updatePost(likes:String,comments:String)->Void
}
extension PostPageVC:PostDetailDelegate{
    func updatePost(likes: String, comments: String) {
        if (self.showPostIndex == nil){ return }
        let post = self.postList[self.showPostIndex!]
        let _post = post.mutableCopy() as! NSMutableDictionary
        _post.setValue(Int(likes) ?? 0, forKey: "likes")
        _post.setValue(Int(comments) ?? 0, forKey: "comments")
        let newPost = NSDictionary(dictionary: _post)
        self.postList[self.showPostIndex!] = newPost
        self.postCollectionView.reloadData()
        self.showPostIndex = nil
    }
}


extension PostPageVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCVC", for: indexPath) as! PostCVC
        
        postCVC.setCVC(post: self.postList[indexPath.row])
        return postCVC
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "show_post_detail"){
            let slug = sender as? String ?? ""
            guard let vc = segue.destination as? PostDetailPageVC else { return }
            vc.delegate = self
            vc.slug = slug
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = postList[indexPath.row]
        guard let slug = post["slug"] as? String else { return }
        self.showPostIndex = indexPath.row
        self.performSegue(withIdentifier:"show_post_detail",sender:slug)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.postCollectionView.frame.size.width
        return CGSize(width: width, height: 192.0)
    }
    
}



