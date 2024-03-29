//
//  UpdateAccountPageVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/5.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class UpdateAccountPageVC: UIViewController {

    
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var phoneTextfield: UITextField!
    
    @IBOutlet weak var telTextfield: UITextField!
    
    @IBOutlet weak var addressTextfield: UITextField!
    
    @IBOutlet weak var idNumberTextfield: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var updateDelegate:UpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissButton()
        keyboardDissmissable()
        
        
        submitButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
        
        
        AD.service.MyAccountRequest(completion: { result in switch result{
            case .success(let res):
                
            self.nameTextfield.text = res["name"] as? String ?? ""
            
            
            
            self.telTextfield.text = res["tel"] as? String ?? ""
            self.phoneTextfield.text = res["phone"] as? String ?? ""
            self.addressTextfield.text = res["address"] as? String ?? ""
            self.idNumberTextfield.text = res["id_number"] as? String ?? ""
            
            case .failure(let error):
                print(error)
            }
            
        })
        
        
        
        
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitUpdateRequest(_ sender: Any) {
        
        let Name = nameTextfield.text ?? ""
        let Phone = phoneTextfield.text ?? ""
        let Tel = telTextfield.text ?? ""
        let Address = addressTextfield.text ?? ""
        let Id_number = idNumberTextfield.text ?? ""
        
        AD.service.UpdateAccountRequest(Name: Name, Phone: Phone, Tel: Tel, Address: Address, Id_number: Id_number, completion: {result in
            switch result{
            case .success(let res):
                if(res["s"] as? Int == 1){
                    Common.SystemAlert(Title: "完成", Body: res["m"] as? String ?? "", SingleBtn: "確定", viewController: self,handler: {_ in
                        self.dismiss(animated: true, completion: nil)
                        self.updateDelegate?.update()
                    })
                }else{
                    Common.SystemAlert(Title: "錯誤", Body: res["m"] as? String ?? "", SingleBtn: "確定", viewController: self,handler: {_ in
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            case .failure(let error):
                print(error)
                Common.SystemAlert(Title: "OOps!", Body: "錯誤", SingleBtn: "確定", viewController: self,handler: {_ in
                    self.dismiss(animated: true, completion: nil)
                })
            }
            
        })
    }
    
    
    
    
    
    
    
    

}
