//
//  ProductDetailPageVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/12/8.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class ProductDetailPageVC: UIViewController {

    
    var slug:String?
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var LocationStack: UIStackView!
    var locationCellArray:[LocationCell] = []
    var selectedLocationId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissButton()
        getProductDetail()
    }
    
    func getProductDetail(){
        //slug = "P1575710295"    //測試產品
        if(slug == nil){
            self.dismiss(animated: false, completion: nil)
            return
        }
        
        Spinner.start()
        AD.service.GetProductDetail(slug: slug!, completion: {result in
            switch result{
            case .success(let res):
                
                guard let product = res["product"] as? NSDictionary else{ return }
                
                let urlString = product["imgUrl"] as? String ?? ""
                self.productImage.loadImageUsingUrlString(urlString: urlString)
                self.nameLabel.text = "商品：\(product["name"] as? String ?? "")"
                self.priceLabel.text = "樂幣：\((product["price"] as? Int)?.description ?? "")"
                self.infoLabel.text = product["info"] as? String ?? ""
                
                let locationList = res["locationList"] as? [NSDictionary] ?? []
                self.loadLocation(locationList: locationList)
                
                DispatchQueue.main.async {Spinner.stop()}
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
        
    }
    
    
    
    private func loadLocation(locationList:[NSDictionary]){
        self.LocationStack.subviews.forEach({$0.removeFromSuperview()})
        self.locationCellArray = []
        
        for location in locationList{
            
            let quantity = location["quantity"] as? Int ?? 0
            guard let locationCell = LocationCell(location: location, quantity: quantity) else { return }
            self.locationCellArray.append(locationCell)
            locationCell.delegate = self
            locationCell.translatesAutoresizingMaskIntoConstraints = false
            self.LocationStack.addArrangedSubview(locationCell)
            locationCell.heightAnchor.constraint(equalToConstant: 56.0).isActive=true
            
        }
    }
    
    @IBAction func SubmitPurchaseRequest(_ sender: Any) {
        if(self.selectedLocationId == nil){
            Common.SystemAlert(Title: "提醒", Body: "請選擇門市", SingleBtn: "確定", viewController: self)
            return
        }
        
        Spinner.start()
        AD.service.PurchaseProduct(location_id: self.selectedLocationId!, product_slug: self.slug!, completion: {result in
            switch result{
            case .success(let res):
                if(res == "success"){
                    Common.SystemAlert(Title: "提醒", Body: "兌換成功", SingleBtn: "確定", viewController: self)
                    self.getProductDetail()
                }else{
                    Common.SystemAlert(Title: "提醒", Body: res, SingleBtn: "確定", viewController: self)
                }
                DispatchQueue.main.async {Spinner.stop()}
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
        
    }
    
}

protocol LocationCellDelegate {
    func select(id:Int)->Void
    
    func deSelect()->Void
    
    func showLocationDetail(location:NSDictionary)->Void
}

extension ProductDetailPageVC:LocationCellDelegate{
    
    func showLocationDetail(location: NSDictionary) {
        let board = UIStoryboard(name: "Main", bundle: nil)
        guard let LocationDetailVC = board.instantiateViewController(withIdentifier: "LocationDetailVC") as? LocationDetailVC else{
            return
        }
        LocationDetailVC.modalPresentationStyle = .overFullScreen
        self.present(LocationDetailVC,animated: false,completion: nil)
        LocationDetailVC.setLocationDetail(location: location)
        
    }
    
    func deSelect() {
        self.selectedLocationId = nil
    }
    
    func select(id: Int) {
        
        for cell in self.locationCellArray{
            if(cell.tag == self.selectedLocationId){
                cell.uncheckButton()
            }
        }
        self.selectedLocationId = id
    }
    
    
}
