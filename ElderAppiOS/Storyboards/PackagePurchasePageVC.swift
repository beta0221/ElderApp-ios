//
//  PackagePurchasePageVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2022/1/25.
//  Copyright © 2022 林奕儒. All rights reserved.
//

import UIKit

class PackagePurchasePageVC: UIViewController {

    
    var slug:String!
    var packageId:Int!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var myPointLabel: UILabel!
    @IBOutlet weak var myBonusLabel: UILabel!
    
    @IBOutlet weak var totalPointLabel: UILabel!
    @IBOutlet weak var totalCashLabel: UILabel!
    @IBOutlet weak var bonusDiscountTextfield: UITextField!
    
    @IBOutlet weak var receiverNameTextfield: UITextField!
    @IBOutlet weak var receiverPhoneTextfield: UITextField!
    @IBOutlet weak var receiverAddressTextfield: UITextField!
    
    
    
    var wallet:Int = 0
    var bonus:Int = 0
    
    var totalPoint:Int = 0
    var price:Int = 0
    
    var bonusDicsount:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardDissmissable()
        addDismissButton()
        caculatePackage()
        
        bonusDiscountTextfield.addTarget(self, action: #selector(bonusDiscountTextfieldOnChange), for: .editingChanged)
        
    }
    
    private func caculatePackage(){
        Spinner.start()
        AD.service.CaculatePackage(slug: slug, package_id: packageId, completion: { result in
            switch result{
            case .failure(let error):
                DispatchQueue.main.async {Spinner.stop()}
                print(error)
            case .success(let res):
                print(res)
                DispatchQueue.main.async {Spinner.stop()}
                
                guard let title = res["title"] as? String,
                      let wallet = res["wallet"] as? Int,
                      let bonus = res["bonus"] as? Int,
                      let totalPoint = res["total_point"] as? Int,
                      let price = res["price"] as? Int,
                      let receiverName = res["receiver_name"] as? String,
                      let receiverPhone = res["receiver_phone"] as? String,
                      let receiverAddress = res["address"] as? String else { return }
                
                
                self.wallet = wallet
                self.bonus = bonus
                self.totalPoint = totalPoint
                self.price = price
                
                self.titleLabel.text = title
                self.myPointLabel.text = wallet.description
                self.myBonusLabel.text = bonus.description
                self.totalPointLabel.text = totalPoint.description
                self.totalCashLabel.text = price.description
                
                self.receiverNameTextfield.text = receiverName
                self.receiverPhoneTextfield.text = receiverPhone
                self.receiverAddressTextfield.text = receiverAddress
                
            }
        })
    }

    @objc private func bonusDiscountTextfieldOnChange(_ sender: UITextField){
        self.bonusDicsount = Int(sender.text ?? "0") ?? 0
        
        if(bonusDicsount > bonus){
            bonusDicsount = bonus
            sender.text = bonus.description
        }
        
        let _price = price - bonusDicsount
        totalCashLabel.text = _price.description
        
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        if(totalPoint > wallet){
            Common.SystemAlert(Title: "錯誤", Body: "樂幣餘額不足", SingleBtn: "確定", viewController: self)
            return
        }
        
        if(bonusDicsount > bonus){
            Common.SystemAlert(Title: "錯誤", Body: "紅利點數餘額不足", SingleBtn: "確定", viewController: self)
            return
        }
        
        guard let receiverName = receiverNameTextfield.text,
              let receiverPhone = receiverPhoneTextfield.text,
              let address = receiverAddressTextfield.text else {
            Common.SystemAlert(Title: "錯誤", Body: "請確認收件資料是否完整", SingleBtn: "確定", viewController: self)
            return
        }
        
        AD.service.purchasePackage(slug: slug, packageId: packageId, receiverName: receiverName, receiverPhone: receiverPhone, address: address, bonusDiscount: bonusDicsount, completion: {result in
            switch result{
            case .failure(let error):
                DispatchQueue.main.async {Spinner.stop()}
                print(error)
            case .success(let res):
                print(res)
                DispatchQueue.main.async {Spinner.stop()}
                
                guard let orderNumero = res["order_numero"] as? String else { return }
                
                weak var pvc = self.presentingViewController
                self.dismiss(animated: false, completion: {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                    vc.modalPresentationStyle = .overCurrentContext
                    pvc?.present(vc,animated: true,completion: {
                        vc.loadOrderDetail(orderNumero: orderNumero)
                    })
                })
                
                
            }
        })
        
        
        
    }
    
    

}
