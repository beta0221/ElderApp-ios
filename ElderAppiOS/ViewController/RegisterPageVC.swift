//
//  RegisterPageVC.swift
//  ElderAppiOS
//
//  Created by Movark on 2019/11/6.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class RegisterPageVC: UIViewController {

    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailAlert: UIView!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordAlert: UIView!
    
    @IBOutlet weak var conPasswordField: UITextField!
    @IBOutlet weak var conPasswordAlert: UIView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameAlert: UIView!
    
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var telField: UITextField!
    
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var genderAlert: UIView!
    
    @IBOutlet weak var birthdateField: UITextField!
    @IBOutlet weak var birthdateAlert: UIView!
    
    @IBOutlet weak var idNumberField: UITextField!
    @IBOutlet weak var idNumberAlert: UIView!
    
    @IBOutlet weak var districtField: UITextField!
    @IBOutlet weak var districtAlert: UIView!
    var selectDistrictId:Int?
    
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var addressAlert: UIView!
    
    @IBOutlet weak var payTypeField: UITextField!
    @IBOutlet weak var payTypeAlert: UIView!
    var selectPayType:Int?
    
    @IBOutlet weak var inviterTitle_view: UIView!
    @IBOutlet weak var inviterField_view: UIView!
    @IBOutlet weak var inviterScanBtn_view: UIView!
    
    @IBOutlet weak var inviterScanBtn: UIButton!
    @IBOutlet weak var inviterField: UITextField!
    @IBOutlet weak var inviterAlert: UIView!
    
    
    
    var service = Service()
    
    var genderArray = ["請選擇性別","男","女"]
    var districtArray:District?
    var payTypeArray = ["請選擇付款方式","推薦人代收","自行繳費"]
    
    @objc func dismissPicker(){
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inviterScanBtn.layer.cornerRadius = 8
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissPicker))
        view.addGestureRecognizer(tap)
        
        let serialQue:DispatchQueue = DispatchQueue(label: "serialQue")
        
        serialQue.sync {
            getDistrict()
        }
        serialQue.sync {
            initPicker()
        }
        
    }
    func getDistrict(){
        service.GetDistrict(completion: {result in
            switch result{
            case .success(let res):
                self.districtArray = res
                let e = DistrictElement(id: 0, group: Group(rawValue: "a"), name: "請選擇地區")
                self.districtArray?.insert(e, at: 0)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func initPicker(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "確定", style: .plain, target: self, action: #selector(self.dismissPicker))
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        let GenderPicker = UIPickerView()
        GenderPicker.restorationIdentifier = "GenderPicker"
        GenderPicker.delegate = self
        genderField.inputView = GenderPicker
        genderField.inputAccessoryView = toolBar
        
        let DistrictPicker = UIPickerView()
        DistrictPicker.restorationIdentifier = "DistrictPicker"
        DistrictPicker.delegate = self
        districtField.inputView = DistrictPicker
        districtField.inputAccessoryView = toolBar
        
        let PayTypePicker = UIPickerView()
        PayTypePicker.restorationIdentifier = "PayTypePicker"
        PayTypePicker.delegate = self
        payTypeField.inputView = PayTypePicker
        payTypeField.inputAccessoryView = toolBar
        
        let BirthdatePicker = UIDatePicker()
        BirthdatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        BirthdatePicker.datePickerMode = .date
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
    
    func isFormValid()->Bool{
        var result = true
        emailAlert.isHidden = true
        passwordAlert.isHidden = true
        conPasswordAlert.isHidden = true
        nameAlert.isHidden = true
        genderAlert.isHidden = true
        birthdateAlert.isHidden = true
        idNumberAlert.isHidden = true
        districtAlert.isHidden = true
        addressAlert.isHidden = true
        payTypeAlert.isHidden = true
        inviterAlert.isHidden = true
        
        if(emailField.text!.isEmpty){
            emailAlert.isHidden = false
            result = false
        }
        if(passwordField.text!.isEmpty){
            passwordAlert.isHidden = false
            result = false
        }
        if(passwordField.text != conPasswordField.text){
            conPasswordAlert.isHidden = false
            result = false
        }
        if(nameField.text!.isEmpty){
            nameAlert.isHidden = false
            result = false
        }
        if(genderField.text!.isEmpty || genderField.text == "請選擇性別"){
            genderAlert.isHidden = false
            result = false
        }
        if(birthdateField.text!.isEmpty){
            birthdateAlert.isHidden = false
            result = false
        }
        if(idNumberField.text!.isEmpty){
            idNumberAlert.isHidden = false
            result = false
        }
         if(districtField.text!.isEmpty || districtField.text == "請選擇地區"){
            districtAlert.isHidden = false
            result = false
        }
        if(addressField.text!.isEmpty){
            addressAlert.isHidden = false
            result = false
        }
        if(payTypeField.text!.isEmpty || payTypeField.text! == "請選擇付款方式"){
            payTypeAlert.isHidden = false
            result = false
        }else if(payTypeField.text == "推薦人代收"){
            if(inviterField.text!.isEmpty){
                inviterAlert.isHidden = false
                result = false
            }
        }
        
        return result
    }
    
    
    @IBAction func submitSignUpForm(_ sender: Any) {
        
        if(self.isFormValid()){
            if(self.payTypeField.text == "推薦人代收"){
                self.checkInviter()
            }else{
                self.signUpRequest()
            }
        }
        
    }
    
    func checkInviter(){
        service.CheckInviterRequest(inviter_id_code: self.inviterField.text ?? "", completion: {result in
            switch result{
            case .success(let res):
                if(res["s"] as! Int == 1){
                    Common.SystemConfirm(Title: "確認", Body: "推薦人姓名:\(res["inviter"] as! String)", ConBtn: "是", CancelBtn: "否", viewController: self, ConHandler: {_ in
                        self.signUpRequest()
                    }, CancelHandler: {_ in })
                }else{
                    Common.SystemAlert(Title: "非常抱歉", Body: "找不到推薦人", SingleBtn: "確定", viewController: self)
                }
            case .failure(let error):
                print(error)
                Common.SystemAlert(Title: "錯誤", Body: "系統錯誤", SingleBtn: "確定", viewController: self)
            }
        })
    }
    
    func signUpRequest(){
        
        
        let Email = emailField.text ?? ""
        let Password = passwordField.text ?? ""
        let Name = nameField.text ?? ""
        let Phone = phoneField.text ?? ""
        let Tel = telField.text ?? ""
        var GenderVal = 1
        if(genderField.text == "女"){
            GenderVal = 0
        }
        let Birthdate = birthdateField.text ?? ""
        let Id_number = idNumberField.text ?? ""
        let DistrictId = selectDistrictId
        let Address = addressField.text ?? ""
        let Pay_mathodVal = selectPayType
        let Inviter_id_code = inviterField.text ?? ""
        
        
        service.SignUpRequest(Email: Email, Password: Password, Name: Name, Phone: Phone, Tel: Tel, GenderVal: GenderVal, Birthdate: Birthdate, Id_number: Id_number, DistrictId: DistrictId!, Address: Address, Pay_mathodVal: Pay_mathodVal!, Inviter_id_code: Inviter_id_code, completion: {result in
            switch result{
            case .success(let res):
                if(res["s"] != nil){
                    if(res["s"] as! Int == 1){
                        Common.SystemAlert(Title: "成功", Body: "您已完成註冊", SingleBtn: "確定", viewController: self, handler: {_ in
                            self.performSegue(withIdentifier: "unwindLoginPageVC", sender: nil)
                        })
                    }
                }else if(res["errors"] != nil){

                    var errorString = ""
                    let errors = res["errors"] as! NSDictionary
                    for (_,value) in errors{
                        let str = "\(value)"
                        let d = str.data(using: .utf8)!
                        let s = String(data: d, encoding: .nonLossyASCII)
                        errorString = s ?? "系統錯誤"
                    }
                    Common.SystemAlert(Title: "錯誤", Body: errorString , SingleBtn: "確定", viewController: self)
                }
                
            case .failure(let error):
                Common.SystemAlert(Title: "錯誤", Body: "系統錯誤", SingleBtn: "確定", viewController: self)
                print(error)
            }
        })
    }
    
    @IBAction func showScanerPage(_ sender: Any) {
        let InviterScannerPageVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InviterScannerPageVC") as! InviterScannerPageVC
        InviterScannerPageVC.getInviterIdCode = self
        self.present(InviterScannerPageVC, animated: true, completion: nil)
        
    }
    
    

}

protocol GetInviterIdCode {
    func get(idCode:String)->Void
}

extension RegisterPageVC:GetInviterIdCode{
    func get(idCode: String) {
        self.inviterField.text = idCode
    }
}

extension RegisterPageVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.restorationIdentifier == "GenderPicker"){
            return genderArray.count
        }
        if(pickerView.restorationIdentifier == "DistrictPicker"){
            return districtArray?.count ?? 0
        }
        if(pickerView.restorationIdentifier == "PayTypePicker"){
            return payTypeArray.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.restorationIdentifier == "GenderPicker"){
            return genderArray[row]
        }
        if(pickerView.restorationIdentifier == "DistrictPicker"){
            return districtArray?[row].name ?? ""
        }
        if(pickerView.restorationIdentifier == "PayTypePicker"){
            return payTypeArray[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.restorationIdentifier == "GenderPicker"){
            genderField.text = genderArray[row]
        }
        if(pickerView.restorationIdentifier == "DistrictPicker"){
            districtField.text = districtArray?[row].name ?? ""
            selectDistrictId = districtArray?[row].id
        }
        if(pickerView.restorationIdentifier == "PayTypePicker"){
            payTypeField.text = payTypeArray[row]
            if(row == 1){
                self.inviterTitle_view.isHidden = false
                self.inviterField_view.isHidden = false
                self.inviterScanBtn_view.isHidden = false
                selectPayType = 1
            }else{
                self.inviterTitle_view.isHidden = true
                self.inviterField_view.isHidden = true
                self.inviterScanBtn_view.isHidden = true
                self.inviterAlert.isHidden = true
                selectPayType = 0
            }
        }
    }
    
}
