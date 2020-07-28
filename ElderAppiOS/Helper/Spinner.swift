//
//  Spinner.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2020/7/28.
//  Copyright © 2020 林奕儒. All rights reserved.
//

import Foundation
import UIKit

open class Spinner{
    internal static var spinner:UIActivityIndicatorView?
    
    public static func start() {
        
        if(spinner != nil){
            return
        }
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

        
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            spinner!.style = .whiteLarge
            spinner!.color = .gray

            topController.view.addSubview(spinner!)
            spinner!.startAnimating()
            
        }
        
    }
    
    
    public static func stop() {
        if spinner != nil {
            spinner!.stopAnimating()
            spinner!.removeFromSuperview()
            spinner = nil
        }
    }
    
}
