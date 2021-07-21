//
//  ProductDetailPageVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/12/8.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit
import WebKit

class ProductDetailPageVC: UIViewController {

    var type:ListType = .free
    var slug:String?
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var pointCashTitleView: UIView!
    @IBOutlet weak var pointCashView: UIView!
    @IBOutlet weak var cashTitleView: UIView!
    @IBOutlet weak var cashView: UIView!
    
    @IBOutlet weak var payCashPriceLabel: UILabel!
    @IBOutlet weak var payCashPointLabel: UILabel!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var originalCashLabel: UILabel!
    
    private var cashPerProduct:Int = 0
    private var pointPerProduct:Int = 0
    
    @IBOutlet weak var infoWKView: WKWebView!
    
    @IBOutlet weak var LocationStack: UIStackView!
    var locationCellArray:[LocationCell] = []
    var selectedLocationId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.type {
            case .free:
                priceView.isHidden = false
                pointCashTitleView.isHidden = true
                pointCashView.isHidden = true
                cashTitleView.isHidden = true
                cashView.isHidden = true
            case .cash:
                priceView.isHidden = true
                pointCashTitleView.isHidden = false
                pointCashView.isHidden = false
                cashTitleView.isHidden = false
                cashView.isHidden = false
        }
        
        
        infoWKView.navigationDelegate = self
        
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
                self.nameLabel.text = product["name"] as? String ?? ""
                self.priceLabel.text = "樂幣：\((product["price"] as? Int)?.description ?? "")"
                
                self.payCashPriceLabel.text = (product["pay_cash_price"] as? Int)?.description ?? ""
                self.payCashPointLabel.text = (product["pay_cash_point"] as? Int)?.description ?? ""
                self.cashPerProduct = product["pay_cash_price"] as? Int ?? 0
                self.pointPerProduct = product["pay_cash_point"] as? Int ?? 0
                
                self.cashLabel.text = (product["cash"] as? Int)?.description ?? ""
                let originalCashString = "原價：\((product["original_cash"] as? Int)?.description ?? "")"
                self.originalCashLabel.attributedText = NSAttributedString(string: originalCashString, attributes:[NSAttributedString.Key.strikethroughStyle:1])
                
                let html = "<style>body{font-family:'Arial';font-size:32px;}</style>\(product["info"] as? String ?? "")"
                self.infoWKView.loadHTMLString(html, baseURL: nil)
                //self.infoLabel.attributedText = (product["info"] as? String ?? "").convertToAttributedFromHTML()
                
                let locationList = res["locationList"] as? [NSDictionary] ?? []
                self.loadLocation(locationList: locationList)
                
                DispatchQueue.main.async {Spinner.stop()}
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
        
    }
    
    private func setBodyHeight(_ height:CGFloat){
        for con in infoWKView.constraints{
            if(con.identifier == "WKViewHeight"){
                con.constant = height
            }
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
    private func loadLocation(locationList:[NSDictionary]){
        self.LocationStack.subviews.forEach({$0.removeFromSuperview()})
        self.locationCellArray = []
        
        for location in locationList{
            
            var quantity = 0
            
            switch self.type {
            case .free:
                quantity = location["quantity"] as? Int ?? 0
            case .cash:
                quantity = location["quantity_cash"] as? Int ?? 0
            }
            
            guard let locationCell = LocationCell(location: location, quantity: quantity) else { return }
            self.locationCellArray.append(locationCell)
            locationCell.delegate = self
            locationCell.translatesAutoresizingMaskIntoConstraints = false
            self.LocationStack.addArrangedSubview(locationCell)
            locationCell.heightAnchor.constraint(equalToConstant: 64.0).isActive=true
            
        }
    }
    
    /**點擊確認兌換按鈕*/
    @IBAction func purchaseAction(_ sender: Any) {
        if(self.selectedLocationId == nil){
            Common.SystemAlert(Title: "提醒", Body: "請選擇門市", SingleBtn: "確定", viewController: self)
            return
        }
        
        switch self.type {
        case .free:
            self.purchaseRequest()
        case .cash:
            let cartVC = CartVC(slug: slug!, location_id: selectedLocationId!, pointPerProduct: pointPerProduct, cashPerProduct: cashPerProduct)
            cartVC.modalPresentationStyle = .overCurrentContext
            self.present(cartVC,animated: false)
        }
        
    }
    
    /**兌換請求 api*/
    private func purchaseRequest(){
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
    
    
    @IBAction func shareAction(_ sender: Any) {
        guard let url = URL(string: "\(Service.host)/app/product/\(slug ?? "")") else { return }
        let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(ac, animated: true)
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


extension ProductDetailPageVC:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    if let _height = height as? CGFloat{
                        self.setBodyHeight(_height + 100.0)
                    }
                })
            }
        })
        
    }
}
