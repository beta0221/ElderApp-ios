//
//  ShopPageVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/12/8.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class ShopPageVC: UIViewController {

    //所有商品
    
    @IBOutlet weak var showProductButton: UIButton!
    
    var productList:[NSDictionary] = []
    var page:Int = 1
    var hasNextPage:Bool = true
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    //已兌換
    @IBOutlet weak var showMyOrderButton: UIButton!
    @IBOutlet var MyOrderListView: UIView!
    @IBOutlet weak var myOrderCollectionView: UICollectionView!
    
    var myOrderList:[NSDictionary] = []
    var myOrderPage:Int = 1
    var myOrderHasNextPage:Bool = true
    
    //
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissButton()
        
        loadMyOrderListView()
        
        showProductButton.backgroundColor = UIColor(red: 254/255, green: 114/255, blue: 53/255, alpha: 100)
        showMyOrderButton.backgroundColor = UIColor(red: 254/255, green: 167/255, blue: 53/255, alpha: 100)
        showProductButton.clipsToBounds=true
        showMyOrderButton.clipsToBounds=true
        showProductButton.layer.cornerRadius=4
        showMyOrderButton.layer.cornerRadius=4
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        myOrderCollectionView.delegate = self
        myOrderCollectionView.dataSource = self
        getProducts()
    }
    
    func loadMyOrderListView(){
        MyOrderListView.isHidden=true
        contentView.addAndFill(view: MyOrderListView)
    }
    
    private func getProducts(){
        Spinner.start()
        AD.service.GetProductList(page:self.page,completion: {result in
            switch result{
            case .success(let res):
                self.productList +=  res["productList"] as? [NSDictionary] ?? []
                
                let hasNextPage = res["hasNextPage"] as? Bool ?? false
                if(hasNextPage){
                    self.page += 1
                }
                self.hasNextPage = hasNextPage
                
                self.productCollectionView.reloadData()
                DispatchQueue.main.async {Spinner.stop()}
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
    }
    private func getMyOrderList(){
        Spinner.start()
        AD.service.MyOrderList(page:self.myOrderPage,completion: {result in
            switch result{
            case .success(let res):
                self.myOrderList += res["orderList"] as? [NSDictionary] ?? []
                
                let hasNextPage = res["hasNextPage"] as? Bool ?? false
                if(hasNextPage){
                    self.myOrderPage += 1
                }
                self.myOrderHasNextPage = hasNextPage
                
                self.myOrderCollectionView.reloadData()
                DispatchQueue.main.async {Spinner.stop()}
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
    }
    
    
    @IBAction func showMyOrderList(_ sender: Any) {
        MyOrderListView.isHidden=false
        showMyOrderButton.backgroundColor = UIColor(red: 254/255, green: 114/255, blue: 53/255, alpha: 100)
        showProductButton.backgroundColor = UIColor(red: 254/255, green: 167/255, blue: 53/255, alpha: 100)
        
        self.myOrderPage = 1
        self.myOrderHasNextPage = true
        self.myOrderList = []
        self.getMyOrderList()
        
    }
    
    @IBAction func showProductList(_ sender: Any) {
        MyOrderListView.isHidden=true
        showProductButton.backgroundColor = UIColor(red: 254/255, green: 114/255, blue: 53/255, alpha: 100)
        showMyOrderButton.backgroundColor = UIColor(red: 254/255, green: 167/255, blue: 53/255, alpha: 100)
    }
    

}


extension ShopPageVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == productCollectionView){
            return productList.count
        }
        
        return myOrderList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == productCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVC", for: indexPath) as! ProductCVC
            
            let product = self.productList[indexPath.row]
            cell.setProductCVC(product: product)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyOrderCVC", for: indexPath) as! MyOrderCVC
        
        let order = myOrderList[indexPath.row]
        cell.setMyOrderCVC(order: order)
        return cell
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == productCollectionView){
            let board = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = board.instantiateViewController(withIdentifier: "ProductDetailPageVC") as? ProductDetailPageVC else{
                return
            }
            let product = self.productList[indexPath.row]
            vc.slug = product["slug"] as? String ?? ""
            self.present(vc,animated: true,completion: nil)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.productCollectionView.frame.size.width
        return CGSize(width: w, height: 240.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(collectionView == productCollectionView){
            if(indexPath.row == productList.count - 1 && hasNextPage){
                self.getProducts()
            }
        }else if(collectionView == myOrderCollectionView){
            if(indexPath.row == myOrderList.count - 1 && myOrderHasNextPage){
                self.getMyOrderList()
            }
        }
    }
    
}
