//
//  PostPageVC.swift
//  ElderAppiOS
//
//  Created by Movark on 2020/8/17.
//  Copyright © 2020 林奕儒. All rights reserved.
//

import UIKit

class PostPageVC: UIViewController {

    @IBOutlet weak var postCollectionView: UICollectionView!
    var postList:[NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        getPostList(page: 1)
    }
    
    func getPostList(page:Int){
        Spinner.start()
        AD.service.getPostList(page: page, completion: {result in
            switch result{
            case .success(let res):
                
                if let postList = res["postList"] as? [NSDictionary]{
                    self.postList = postList
                }
                DispatchQueue.main.async {
                    Spinner.stop()
                    self.postCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.postCollectionView.frame.size.width
        return CGSize(width: width, height: 192.0)
    }
    
}
