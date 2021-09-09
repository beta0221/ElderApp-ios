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
    
    static func ActionAlert(title:String,message:String,actions:[UIAlertAction],viewController:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions{
            alert.addAction(action)
        }
        alert.popoverPresentationController?.sourceView = viewController.view
        viewController.present(alert,animated: true)
        
    }
    
    static func SystemAlert(Title:String,Body:String,SingleBtn:String,viewController:UIViewController){
        let controller = UIAlertController(title: Title, message:Body , preferredStyle: .alert)
        let okAction = UIAlertAction(title: SingleBtn, style: .default, handler: nil)
        controller.addAction(okAction)
        controller.popoverPresentationController?.sourceView = viewController.view
        viewController.present(controller, animated: true, completion: nil)
    }
    
    static func SystemAlert(Title:String,Body:String,SingleBtn:String,viewController:UIViewController,handler:@escaping (_ action:UIAlertAction)->Void){
        let controller = UIAlertController(title: Title, message:Body , preferredStyle: .alert)
        let okAction = UIAlertAction(title: SingleBtn, style: .default, handler: handler)
        controller.addAction(okAction)
        controller.popoverPresentationController?.sourceView = viewController.view
        viewController.present(controller, animated: true, completion: nil)
    }
    
    static func SystemConfirm(Title:String,Body:String,ConBtn:String,CancelBtn:String,viewController:UIViewController,ConHandler:@escaping (_ action:UIAlertAction)->Void,CancelHandler:@escaping(_ action:UIAlertAction)->Void){
        let controller = UIAlertController(title: Title, message:Body , preferredStyle: .alert)
        let okAction = UIAlertAction(title: ConBtn, style: .default, handler: ConHandler)
        let cancelAction = UIAlertAction(title: CancelBtn, style: .default, handler: CancelHandler)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        controller.popoverPresentationController?.sourceView = viewController.view
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

extension UIButton{
    func roundButton(){
        self.clipsToBounds=true
        self.layer.cornerRadius=4
    }
}

extension UIViewController{
    
    func addDismissButton(){
//        if #available(iOS 13, *) {
//            return
//        }
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
    
    func presentOnTop(_ VC:UIViewController){
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            VC.modalPresentationStyle = .overCurrentContext
            topController.present(VC,animated: true)
        }
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
//        layer.borderWidth=1.0
//        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 8.0
        
        layer.masksToBounds=true
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 8.0
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}


extension UserDefaults{
    //user_id
    func setUserId(value:Int){
        set(value,forKey: "user_id")
        synchronize()
    }
    func getUserId()->Int?{
        return integer(forKey: "user_id")
    }
    //email
    func setAccount(value:String){
        set(value,forKey: "email")
        synchronize()
    }
    func getAccount()->String?{
        return string(forKey: "email")
    }
    //password
    func setPassword(value:String){
        set(value,forKey: "password")
        synchronize()
    }
    func getPassword()->String?{
        return string(forKey: "password")
    }
    //userName
    func setUserName(value:String?){
        if(value==nil){return}
        set(value,forKey: "userName")
        synchronize()
    }
    func getUserName()->String?{
        return string(forKey: "userName")
    }
    //token
    func setToken(value:String){
        set(value,forKey: "token")
        synchronize()
    }
    func getToken()->String?{
        return string(forKey: "token")
    }
    //wallet
    func setWallet(value:Int?){
        if(value==nil){return}
        set(value!,forKey: "wallet")
        synchronize()
    }
    func getWallet()->Int?{
        return integer(forKey: "wallet")
    }
    //rank
    func setRank(value:Int?){
        if(value==nil){return}
        set(value!,forKey: "rank")
        synchronize()
    }
    func getRank()->Int?{
        return integer(forKey: "rank")
    }
    //org_rank
    func setOrgRank(value:Int?){
        if(value==nil){return}
        set(value!,forKey: "org_rank")
        synchronize()
    }
    func getOrgRank()->Int?{
        return integer(forKey: "org_rank")
    }
    //line_id
    func setLineId(value:String){
        set(value,forKey: "line_id")
        synchronize()
    }
    func getLindId()->String?{
        return string(forKey: "line_id")
    }
    
    func removeUserData(){
        removeObject(forKey: "user_id")
        removeObject(forKey: "email")
        removeObject(forKey: "password")
        removeObject(forKey: "userName")
        removeObject(forKey: "token")
        removeObject(forKey: "wallet")
        removeObject(forKey: "rank")
        removeObject(forKey: "org_rank")
        removeObject(forKey: "line_id")
    }
    
}

extension String {
    func convertToAttributedFromHTML(fontName: String = "Arial", fontSize: Float = 32) -> NSAttributedString? {
        
        let style = "<style>body { font-family: '\(fontName)'; font-size:\(fontSize)px; }</style>"
        var attributedText: NSAttributedString?
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue,
        ]
        if let data = (self + style).data(using: .unicode, allowLossyConversion: true), let attrStr = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            attributedText = attrStr
        }
        
        return attributedText
    }
}

class MyTapGesture:UITapGestureRecognizer{
    var tapView:UIView?
    var int:Int?
    var string:String?
}
