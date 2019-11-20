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
    
    static func storeUser(response:Dictionary<String,Any>,password:String = "")->Void{
        if(password != ""){
            UserDefaults.standard.setAccount(value: response["email"] as! String)
            UserDefaults.standard.setPassword(value: password)
            UserDefaults.standard.setUserId(value: response["user_id"] as! Int)
            UserDefaults.standard.setUserName(value: response["name"] as! String)
        }
        UserDefaults.standard.setToken(value: response["access_token"] as! String)
    }
    
}
