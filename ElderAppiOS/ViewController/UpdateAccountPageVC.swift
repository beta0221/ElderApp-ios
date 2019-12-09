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
        
        
        
        let service = Service()
        service.MyAccountRequest(completion: { result in switch result{
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
        
        let service = Service()
        service.UpdateAccountRequest(Name: Name, Phone: Phone, Tel: Tel, Address: Address, Id_number: Id_number, completion: {result in
            switch result{
            case .success(let res):
                if(res["s"] as? Int == 1){
                    let controller = UIAlertController(title: "完成", message: (res["m"] as! String), preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .default, handler:{ action in
                        self.dismiss(animated: true, completion: nil)
                        self.updateDelegate?.update()
                    })
                    controller.addAction(okAction)
                    self.present(controller, animated: true, completion:nil)
                }else{
                    let controller = UIAlertController(title: "錯誤", message: (res["m"] as! String), preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .default, handler:{ action in
                        self.dismiss(animated: true, completion: nil)
                    })
                    controller.addAction(okAction)
                    self.present(controller, animated: true, completion:nil)
                }
            case .failure(let error):
                print(error)
                let controller = UIAlertController(title: "OOps!", message:"錯誤", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確定", style: .default, handler:{ action in
                    self.dismiss(animated: true, completion: nil)
                })
                controller.addAction(okAction)
                self.present(controller, animated: true, completion:nil)
            }
            
        })
    }
    
    
    
    
    
    
    
    

}
