//
//  Common.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/5.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import Foundation
import UIKit

class Common{
    
    static func SystemAlert(Title:String,Body:String,SingleBtn:String,viewController:UIViewController){
        let controller = UIAlertController(title: Title, message:Body , preferredStyle: .alert)
        let okAction = UIAlertAction(title: SingleBtn, style: .default, handler: nil)
        controller.addAction(okAction)
        viewController.present(controller, animated: true, completion: nil)
    }
    
    static func SystemAlert(Title:String,Body:String,SingleBtn:String,viewController:UIViewController,handler:@escaping (_ action:UIAlertAction)->Void){
        let controller = UIAlertController(title: Title, message:Body , preferredStyle: .alert)
        let okAction = UIAlertAction(title: SingleBtn, style: .default, handler: handler)
        controller.addAction(okAction)
        viewController.present(controller, animated: true, completion: nil)
    }
    
    static func SystemConfirm(Title:String,Body:String,ConBtn:String,CancelBtn:String,viewController:UIViewController,ConHandler:@escaping (_ action:UIAlertAction)->Void,CancelHandler:@escaping(_ action:UIAlertAction)->Void){
        let controller = UIAlertController(title: Title, message:Body , preferredStyle: .alert)
        let okAction = UIAlertAction(title: ConBtn, style: .default, handler: ConHandler)
        let cancelAction = UIAlertAction(title: CancelBtn, style: .default, handler: CancelHandler)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        viewController.present(controller, animated: true, completion: nil)
    }
    
    
    
    
    
    static func getSizeFromString(string:String, withFont font:UIFont)->CGSize{
        let textSize = NSString(string: string ).size(
            withAttributes: [ NSAttributedString.Key.font:font ])
        return textSize
    }
    
    
    static func colorWithRGB(rgbString:String!, alpha:CGFloat!) -> UIColor! {
        
        let scanner = Scanner.init(string: rgbString.lowercased())
        var baseColor:UInt64 = UInt64()
        scanner.scanHexInt64(&baseColor)
        
        let red     = ((CGFloat)((baseColor & 0xFF0000) >> 16)) / 255.0
        let green   = ((CGFloat)((baseColor & 0xFF00) >> 8)) / 255.0
        let blue    = ((CGFloat)(baseColor & 0xFF)) / 255.0
        
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}


extension UIViewController{
    
    func addDismissButton(){
        if #available(iOS 13, *) {
            return
        }
        let button = UIButton()
        let img = UIImage(named: "back")
        button.setImage(img, for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints=false
        self.view.addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40.0),
            button.widthAnchor.constraint(equalToConstant: 40.0),
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12.0),
            button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
        ])
    }
    
    @objc func dismiss(_ sender:Any){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func donePressed() {
        view.endEditing(true)
    }
    
    func keyboardDissmissable(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.donePressed))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

extension UIView{
    func addAndFill(view:UIView){
        view.translatesAutoresizingMaskIntoConstraints=false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
        ])
    }
    
    func Theme(){
        clipsToBounds=true
        layer.borderWidth=1.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 8.0
        
        layer.masksToBounds=true
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 8.0
    }
    
}


extension UserDefaults{
    func setUserId(value:Int){
        set(value,forKey: "user_id")
        synchronize()
    }
    func getUserId()->Int?{
        return integer(forKey: "user_id")
    }
    func setAccount(value:String){
        set(value,forKey: "email")
        synchronize()
    }
    func getAccount()->String?{
        return string(forKey: "email")
    }
    func setPassword(value:String){
        set(value,forKey: "password")
        synchronize()
    }
    func getPassword()->String?{
        return string(forKey: "password")
    }
    func setUserName(value:String){
        set(value,forKey: "userName")
        synchronize()
    }
    func getUserName()->String?{
        return string(forKey: "userName")
    }
    func setToken(value:String){
        set(value,forKey: "token")
        synchronize()
    }
    func getToken()->String?{
        return string(forKey: "token")
    }
    
    func removeUserData(){
        removeObject(forKey: "user_id")
        removeObject(forKey: "email")
        removeObject(forKey: "password")
        removeObject(forKey: "userName")
        removeObject(forKey: "token")
    }
    
}

class MyTapGesture:UITapGestureRecognizer{
    var tapView:UIView?
    var int:Int?
    var string:String?
}
