//
//  ApplyInsuranceVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2021/8/9.
//  Copyright © 2021 林奕儒. All rights reserved.
//

import Foundation
import UIKit

class ApplyInsuranceVC: UIViewController {
    
    @IBOutlet weak var contentScrollview: UIScrollView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var identityNumberTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var birthdateField: UITextField!
    
    @IBOutlet var textFieldCollection: [UITextField]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissButton()
        keyboardDissmissable()
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "確定", style: .plain, target: self, action: #selector(self.dismissPicker))
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        let BirthdatePicker = UIDatePicker()
        BirthdatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        BirthdatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            BirthdatePicker.preferredDatePickerStyle = .wheels
        }
        
        BirthdatePicker.locale = Locale(identifier: "zh_TW")
        birthdateField.inputView = BirthdatePicker
        birthdateField.inputAccessoryView = toolBar
        
    }
    
    @objc func datePickerValueChanged(_ sender:UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        birthdateField.text = selectedDate
    }
    
    @objc func dismissPicker(){
        view.endEditing(true)
    }
    
    
    
    
    @IBAction func submitFormAction(_ sender: Any) {
        var valid = true
        textFieldCollection.forEach(){textField in
            if(textField.text?.isEmpty ?? true){ valid = false }
        }
        if(!valid){
            Common.SystemAlert(Title: "訊息", Body: "請確認資料是否完整", SingleBtn: "確定", viewController: self)
            return;
        }
        
        Spinner.start()
        AD.service.applyInsurance(name: nameTextField.text!, identityNumber: identityNumberTextField.text!, phone: phoneTextField.text!, birthdate: birthdateField.text!, completion: { result in
          
            switch result{
            case .success(_):
                DispatchQueue.main.async { Spinner.stop() }
                Common.SystemAlert(Title: "訊息", Body: "申請成功", SingleBtn: "確定", viewController: self, handler: {_ in
                    self.dismiss(animated: true, completion: nil)
                })
            case .failure(let error):
                print(error)
                DispatchQueue.main.async { Spinner.stop() }
                Common.SystemAlert(Title: "錯誤", Body: "系統錯誤", SingleBtn: "確定", viewController: self)
            }
        })
        
    }
    
    
}
