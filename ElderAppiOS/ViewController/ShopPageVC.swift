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
    var products:[NSDictionary]?
    var cats:[NSDictionary]?
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    //已兌換
    @IBOutlet var MyOrderListView: UIView!
    @IBOutlet weak var myOrderCollectionView: UICollectionView!
    var myOrder:[NSDictionary]?
    
    //
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissButton()
        
        loadMyOrderListView()
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        myOrderCollectionView.delegate = self
        myOrderCollectionView.dataSource = self
        getAllProducts()
    }
    
    func loadMyOrderListView(){
        MyOrderListView.isHidden=true
        contentView.addAndFill(view: MyOrderListView)
    }
    
    func getAllProducts(){
        AD.service.GetAllProducts(completion: {result in
            switch result{
            case .success(let res):
                self.products =  res["products"] as? [NSDictionary]
                self.cats = res["cats"] as? [NSDictionary]
                self.productCollectionView.reloadData()
                break
            case .failure(let error):
                print(error)
            }
        })
    }
    
    @IBAction func showMyOrderList(_ sender: Any) {
        MyOrderListView.isHidden=false
        AD.service.MyOrderList(completion: {result in
            switch result{
            case .success(let res):
                self.myOrder = res
                self.myOrderCollectionView.reloadData()
                break
            case .failure(let error):
                print(error)
            }
        })
    }
    
    @IBAction func showProductList(_ sender: Any) {
        MyOrderListView.isHidden=true
    }
    

}


extension ShopPageVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == productCollectionView){
            return products?.count ?? 0
        }
        
        return myOrder?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == productCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVC", for: indexPath) as! ProductCVC
            
            let product = products![indexPath.row]
            cell.setProductCVC(product: product)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyOrderCVC", for: indexPath) as! MyOrderCVC
        
        let order = myOrder![indexPath.row]
        cell.setMyOrderCVC(order: order)
        return cell
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == productCollectionView){
            let board = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = board.instantiateViewController(withIdentifier: "ProductDetailPageVC") as? ProductDetailPageVC else{
                return
            }
            let product = products![indexPath.row]
            vc.slug = product["slug"] as? String ?? ""
            self.present(vc,animated: true,completion: nil)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.productCollectionView.frame.size.width
        return CGSize(width: w, height: 240.0)
    }
    
}
