//
//  UserHelper.swift
//  ElderAppiOS
//
//  Created by Movark on 2019/11/4.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class UserHelper{
    
    static func storeUser(res:NSDictionary,password:String? = nil,lineId:String? = nil)->Void{
        
        if let _password = password{
            UserDefaults.standard.setPassword(value: _password)
        }
        
        if let _lineId = lineId{
            UserDefaults.standard.setLineId(value: _lineId)
        }
        
        if let email = res["email"] as? String{
            UserDefaults.standard.setAccount(value: email)
        }
        
        if let user_id = res["user_id"] as? Int{
            UserDefaults.standard.setUserId(value: user_id)
        }
            
        if let name = res["name"] as? String{
            UserDefaults.standard.setUserName(value: name)
        }
        
        if let wallet = res["wallet"] as? Int{
            UserDefaults.standard.setWallet(value: wallet)
        }
        
        if let rank = res["rank"] as? Int{
            UserDefaults.standard.setRank(value: rank)
        }
        
        if let org_rank = res["org_rank"] as? Int{
            UserDefaults.standard.setOrgRank(value: org_rank)
        }
            
        if let token = res["access_token"] as? String{
            UserDefaults.standard.setToken(value: token)
        }
        
    }
    
    static func handleToken(response:NSDictionary,password:String? = nil,lineId:String? = nil,complition:(()->Void)? = nil){
        if(response["access_token"] != nil){
            
            UserHelper.storeUser(res: response,password: password,lineId: lineId)
            UIApplication.shared.registerForRemoteNotifications()
            if(complition != nil){ complition!() }
            
        }else if(response["ios_update_url"] != nil){
            
            let ios_update_url = response["ios_update_url"] as? String ?? ""
            guard let url = URL(string: ios_update_url) else { return }
            UIApplication.shared.open(url)
            
        }else{
            self.errorAlert()
            print("帳號密碼錯誤")
        }
    }
    
    static func errorAlert(){
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            Common.SystemAlert(Title: "錯誤", Body: "登入失敗", SingleBtn: "OK", viewController: topController)
        }
    }
    
    
}
