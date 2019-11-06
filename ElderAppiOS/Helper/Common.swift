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
