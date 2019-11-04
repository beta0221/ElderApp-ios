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
            let controller = UIAlertController(title: "金額錯誤", message: "請輸入有效金額", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        
        
        
        let service = Service()
        service.TransactionRequest(take_id: self.take_id!, take_email: self.take_email!, amount: amount!, eventName: comment!, completion: {result in switch
            result{
            case .success(let res):
                if(res == "success"){
                    let controller = UIAlertController(title: "支付成功", message: "回首頁", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .default, handler:{ action in
                        self.performSegue(withIdentifier: "unwind_IndexPageVC", sender: nil)
                    })
                    controller.addAction(okAction)
                    self.present(controller, animated: true, completion:nil)
                    
                }else if(res == "insufficient"){
                    let controller = UIAlertController(title: "失敗", message: "剩餘樂幣不足", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .default, handler: { action in
                        self.performSegue(withIdentifier: "unwind_IndexPageVC", sender: nil)
                    })
                    controller.addAction(okAction)
                    self.present(controller, animated: true, completion:nil)
                    
                }else{
                    let controller = UIAlertController(title: "失敗", message: res, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .default, handler: { action in
                        self.performSegue(withIdentifier: "unwind_IndexPageVC", sender: nil)
                    })
                    controller.addAction(okAction)
                    self.present(controller, animated: true, completion:nil)
                    
                }
                
                
            case .failure(let error):
                print(error)
                self.performSegue(withIdentifier: "unwind_IndexPageVC", sender: nil)
            }
            
        })
        
        
    }
    
    
}
