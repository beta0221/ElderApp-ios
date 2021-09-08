//
//  GiveMoneyFormVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/4.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class GiveMoneyFormVC: UIViewController {

    
    @IBOutlet weak var giveToNameLabel: UILabel!
    @IBOutlet weak var amountTextfield: UITextField!
    @IBOutlet weak var commentTextfield: UITextField!
    
    var take_id:Int?
    var take_email:String?
    var take_name:String?
    
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let datadec  = take_name?.data(using: String.Encoding.utf8)
        let decodevalue = String(data: datadec!, encoding: String.Encoding.nonLossyASCII)
        giveToNameLabel.text = decodevalue
        
    }
    
    @IBAction func submitTransaction(_ sender: Any) {
        let amount = Int(amountTextfield.text!)
        let comment = commentTextfield.text
        
        if(amount! <= 0){
            Common.SystemAlert(Title: "金額錯誤", Body: "請輸入有效金額", SingleBtn: "確定", viewController: self)
            return
        }
        
        
        AD.service.TransactionRequest(take_id: self.take_id!, take_email: self.take_email!, amount: amount!, eventName: comment!, completion: {result in switch
            result{
            case .success(let res):
                if(res == "success"){
                    Common.SystemAlert(Title: "支付成功", Body: "回首頁", SingleBtn: "確定", viewController: self,handler: {_ in
                        NotificationCenter.default.post(name: Notification.Name("updateMyData"), object: nil)
                        self.performSegue(withIdentifier: "unwind_IndexPageVC", sender: nil)
                    })
                }else if(res == "insufficient"){
                    Common.SystemAlert(Title: "失敗", Body: "剩餘樂幣不足", SingleBtn: "確定", viewController: self,handler: {_ in
                        self.performSegue(withIdentifier: "unwind_IndexPageVC", sender: nil)
                    })
                }else{
                    Common.SystemAlert(Title: "失敗", Body: res, SingleBtn: "確定", viewController: self,handler: {_ in
                        self.performSegue(withIdentifier: "unwind_IndexPageVC", sender: nil)
                    })
                }
                
                
            case .failure(let error):
                print(error)
                self.performSegue(withIdentifier: "unwind_IndexPageVC", sender: nil)
            }
            
        })
        
        
    }
    
    
}
