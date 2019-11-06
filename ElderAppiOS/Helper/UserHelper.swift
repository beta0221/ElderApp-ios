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
    
    static func storeUser(response:Dictionary<String,Any>,password:String = "")->Bool{
        
        
        let userEntity = NSEntityDescription.entity(forEntityName:"UserData",in:viewContext)!
        let user = NSManagedObject(entity:userEntity,insertInto:viewContext)
        
        
        
        if(password != ""){
            user.setValue(response["email"] as! String,forKeyPath:"email")
            user.setValue(response["id_code"] as! String,forKeyPath:"id_code")
            user.setValue(response["img"] as? String,forKeyPath:"img")            
            user.setValue(response["name"] as! String,forKeyPath:"name")
            user.setValue(password,forKeyPath:"password")
            user.setValue(response["rank"] as! Int,forKeyPath:"rank")
            user.setValue(response["user_id"] as! Int,forKeyPath:"user_id")
            user.setValue(response["wallet"] as! Int,forKeyPath:"wallet")
        }
        
        user.setValue(response["access_token"] as! String,forKeyPath:"token")
        
        do {
            try viewContext.save()
            UserDefaults.standard.set(response["email"] as! String, forKey: "email")
            UserDefaults.standard.set(password, forKey: "password")
            UserDefaults.standard.set(response["user_id"] as! Int, forKey: "user_id")
            UserDefaults.standard.set(response["access_token"] as! String, forKey: "token")
            UserDefaults.standard.synchronize()
            return true
        } catch let error as NSError {
            print("\(error)")
            return false
        }
        
        
    }
    
    
    static func clearUser()->Bool{
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try viewContext.execute(request)
            print("刪除成功")
            return true
        } catch {
            print("Delete Fail")
            return false
        }
    }
    
    

}
