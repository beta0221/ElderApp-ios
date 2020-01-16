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
    
    var locationArray:[NSDictionary] = []
    var locationCellArray:[LocationCell] = []
    var locationQuantity:[Int:Int] = [:]
    
    var selectedLocationId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissButton()
        getProductDetail()
    }
    
    func getProductDetail(){
        if(slug == nil){
            self.dismiss(animated: false, completion: nil)
            return
        }
        
        AD.service.GetProductDetail(slug: slug!, completion: {result in
            switch result{
            case .success(let res):
                
                let urlString = "\(Service.hostName)/images/products/\(res["slug"] as? String ?? "")/\(res["img"] as? String ?? "")"
                self.productImage.loadImageUsingUrlString(urlString: urlString)
                self.nameLabel.text = "商品：\(res["name"] as? String ?? "")"
                self.priceLabel.text = "樂幣：\((res["price"] as? Int)?.description ?? "")"
                self.infoLabel.text = res["info"] as? String ?? ""
                
                let locations = res["location"] as? [NSDictionary]
                for l in locations!{
                    let location_id = l["location_id"] as! Int
                    let quantity = l["quantity"] as! Int
                    self.locationQuantity[location_id] = quantity
                }
                self.getLocation()
                break
            case .failure(let error):
                print(error)
            }
        })
        
    }
    
    func getLocation(){
        AD.service.GetLocation(completion: {result in
            switch result{
            case .success(let res):
                self.locationArray = res
                self.loadLocation()
                break
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func loadLocation(){
        self.LocationStack.subviews.forEach({$0.removeFromSuperview()})
        for l in self.locationArray{
            let location_id = l["id"] as! Int
            if(self.locationQuantity.keys.contains(location_id)){
                let quantity = self.locationQuantity[location_id]
                var isCheck = false
                if(location_id == self.selectedLocationId){
                    isCheck = true
                }
                let locationView = LocationCell(location: l,quantity:quantity!,isCheck: isCheck)
                locationView!.tag = location_id
                self.locationCellArray.append(locationView!)
                locationView?.delegate = self
                self.LocationStack.addArrangedSubview(locationView!)
                locationView?.translatesAutoresizingMaskIntoConstraints=false
                locationView?.heightAnchor.constraint(equalToConstant: 56.0).isActive=true
            }
        }
    }
    
    @IBAction func SubmitPurchaseRequest(_ sender: Any) {
        if(self.selectedLocationId == nil){
            Common.SystemAlert(Title: "提醒", Body: "請選擇門市", SingleBtn: "確定", viewController: self)
            return
        }
        
        AD.service.PurchaseProduct(location_id: self.selectedLocationId!, product_slug: self.slug!, completion: {result in
            switch result{
            case .success(let res):
                if(res == "success"){
                    Common.SystemAlert(Title: "提醒", Body: "兌換成功", SingleBtn: "確定", viewController: self)
                    
                    var q = self.locationQuantity[self.selectedLocationId!]
                    q! -= 1
                    self.locationQuantity[self.selectedLocationId!] = q!
                    self.loadLocation()
                    
                }else{
                    Common.SystemAlert(Title: "提醒", Body: res, SingleBtn: "確定", viewController: self)
                }
                
                break
            case .failure(let error):
                print(error)
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
        
        for l in self.locationCellArray{
            if(l.tag == self.selectedLocationId){
                l.uncheckButton()
            }
        }
        self.selectedLocationId = id
    }
    
    
}
