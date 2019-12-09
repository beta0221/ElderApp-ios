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

    var Trans:Transaction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissButton()
        transCollectionView.dataSource = self
        transCollectionView.delegate = self
        
        
        let service = Service()
        service.GetTransHistory(completion: { result in
            switch result{
            case .success(let res):
                self.Trans = res
                self.transCollectionView.reloadData()
            case .failure(let error):
                print(error)
        
            }
            
        })
        
        
    }
    

}


extension TransPageVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.Trans?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let transCVC:TransCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "TransCVC", for: indexPath) as! TransCVC
        
        transCVC.setTransCell(tran: self.Trans![indexPath.row])
        
        return transCVC
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.transCollectionView.frame.width
        return CGSize(width: width, height: 120.0)
    }
    
    
}
