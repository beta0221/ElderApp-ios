//
//  TransPageVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/4.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit


class TransPageVC: UIViewController {

    
    @IBOutlet weak var transCollectionView: UICollectionView!

    var TransList:[NSDictionary] = []
    
    var page:Int = 1
    var hasNextPage:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissButton()
        transCollectionView.dataSource = self
        transCollectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("updateMyData"), object: nil)
        
        self.getTransHistory()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    private func getTransHistory(){
        Spinner.start()
        AD.service.GetTransHistory(page:self.page,completion: { result in
            switch result{
            case .success(let res):
                self.TransList += res["transList"] as? [NSDictionary] ?? []
                let hasNextPage = res["hasNextPage"] as? Bool ?? false
                if(hasNextPage){
                    self.page += 1
                }
                self.hasNextPage = hasNextPage
                self.transCollectionView.reloadData()
                DispatchQueue.main.async {Spinner.stop()}
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
            
        })
    }
    
    @objc private func reloadData(){
        self.TransList = []
        self.transCollectionView.reloadData()
        self.page = 1
        self.hasNextPage = true
        self.getTransHistory()
    }

}


extension TransPageVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.TransList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let transCVC:TransCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "TransCVC", for: indexPath) as! TransCVC
        
        transCVC.setCell(tran: self.TransList[indexPath.row])
        return transCVC
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.transCollectionView.frame.size.width
        return CGSize(width: width, height: 140.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(indexPath.row == TransList.count - 1 && hasNextPage){
            self.getTransHistory()
        }
    }
}
