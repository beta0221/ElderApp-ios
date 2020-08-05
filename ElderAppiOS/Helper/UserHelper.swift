//
//  UserHelper.swift
//  ElderAppiOS
//
//  Created by Movark on 2019/11/4.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import Foundation
import CoreData

class UserHelper{
    
    static func storeUser(res:NSDictionary,password:String = "")->Void{
        
        if(!password.isEmpty){
            UserDefaults.standard.setPassword(value: password)
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
    
}
