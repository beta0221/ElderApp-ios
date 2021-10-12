//
//  CartVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2021/7/19.
//  Copyright © 2021 林奕儒. All rights reserved.
//

import UIKit

class CartVC: UIViewController {
    
    private var slug:String?
    private var location_id:Int?
    private var pointPerProduct:Int?
    private var cashPerProduct:Int?
    
    
    
    @IBOutlet weak var quantityTextfield: UITextField!
    @IBOutlet weak var totalCash: UILabel!
    @IBOutlet weak var totalPoint: UILabel!
    @IBOutlet weak var walletRemain: UILabel!
    
    
    init(slug:String,location_id:Int,pointPerProduct:Int,cashPerProduct:Int) {
        super.init(nibName: "CartVC", bundle: nil)
        
        self.slug = slug
        self.location_id = location_id
        self.pointPerProduct = pointPerProduct
        self.cashPerProduct = cashPerProduct
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardDissmissable()
        
        walletRemain.text = "剩餘樂幣：\(UserDefaults.standard.getWallet() ?? 0)"
        totalCash.text = (self.cashPerProduct ?? 0).description
        totalPoint.text = (self.pointPerProduct ?? 0).description
        quantityTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        
        let quantity = Int(textField.text ?? "0") ?? 0
        textField.text = quantity.description
        
        cacuCashAndPoint(quantity: quantity)
    }
    
    @IBAction func increaseAction(_ sender: Any) {
        var quantity = Int(quantityTextfield.text ?? "0") ?? 0
        quantity += 1
        quantityTextfield.text = quantity.description
        cacuCashAndPoint(quantity: quantity)
    }
    
    @IBAction func decreaseAction(_ sender: Any) {
        var quantity = Int(quantityTextfield.text ?? "0") ?? 0
        if(quantity == 0){ return }
        quantity -= 1
        quantityTextfield.text = quantity.description
        cacuCashAndPoint(quantity: quantity)
    }
    
    private func cacuCashAndPoint(quantity:Int){
        totalCash.text = ((self.cashPerProduct ?? 0) * quantity).description
        totalPoint.text = ((self.pointPerProduct ?? 0) * quantity).description
    }
    
    @IBAction func purchaseAction(_ sender: Any) {
        let quantity = Int(quantityTextfield.text ?? "0") ?? 0
        if (quantity <= 0){
            Common.SystemAlert(Title: "訊息", Body: "數量不可為0", SingleBtn: "確定", viewController: self)
            return
        }
        guard let location_id = self.location_id,let slug = self.slug else {
            Common.SystemAlert(Title: "訊息", Body: "系統錯誤", SingleBtn: "確定", viewController: self)
            return
        }
        
        Spinner.start()
        AD.service.PurchaseProductByCash(location_id: location_id, product_slug: slug, quantity: quantity, completion: {result in
            switch result{
            case .success(let res):
                DispatchQueue.main.async { Spinner.stop() }
                if let orderNumero = res["order_numero"] as? String{

                    weak var pvc = self.presentingViewController
                    self.dismiss(animated: false, completion: {
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                        vc.modalPresentationStyle = .overCurrentContext
                        pvc?.present(vc,animated: true,completion: {
                            vc.loadOrderDetail(orderNumero: orderNumero)
                        })
                    })

                }
            case .failure(let error):
                DispatchQueue.main.async { Spinner.stop() }
                Common.SystemAlert(Title: "錯誤", Body: error.content, SingleBtn: "確定", viewController: self)
            }
        })
        
    }
    
    @IBAction func exitAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
}

