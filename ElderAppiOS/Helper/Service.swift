//
//  Service.swift
//  D+AF
//
//  Created by Movark on 2019/8/21.
//  Copyright © 2019 Movark. All rights reserved.
//

import Foundation
// 导入CommonCrypto
import CommonCrypto
import CoreData

enum APIError:Error{
    case responseProblem
    case decodingProblem
    case encodingProblem
}
    

struct Service {
    
    static var hostName:String = "https://www.happybi.com.tw"
    
    let host:String = "https://www.happybi.com.tw"
    
    var iOSVer:Int{
        get{
            let dictionary = Bundle.main.infoDictionary!
            let localVersion = dictionary["CFBundleShortVersionString"] as! String
            let localVersionArray = localVersion.components(separatedBy: ".")
            var iOSVer = 0
            for i in 0...2{
                let lv = Int(localVersionArray[i]) ?? 0
                if(i == 0){
                    iOSVer += lv * 10000
                }else if(i==1){
                    iOSVer += lv * 100
                }else if(i==2){
                    iOSVer += lv
                }
            }
            return iOSVer
        }
    }
    
    private func printJsonData(jsonData:Data){
        let string = String(data: jsonData, encoding: String.Encoding.utf8) as String?
        print(string ?? "")
    }
    
        
    
    //會員申請續會
    func ExtandRequest(completion:@escaping(Result<String,APIError>)->Void){
        
        let requestString = "\(host)/api/extendMemberShip"
        guard let requestURL = URL(string: requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        guard let user_id = UserDefaults.standard.getUserId() else {return}
        let token = UserDefaults.standard.getToken() ?? ""
        let postString = "user_id=\(user_id)&token=\(token)"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                //                self.printJsonData(jsonData: jsonData)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary<String,Any>
                
                if(json?["s"] != nil){
                    DispatchQueue.main.async{
                        completion(.success(json?["m"] as! String))
                    }
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    //使用者登出
    func LogoutRequest(completion:@escaping(Result<String,APIError>)->Void){
        
        let requestString = "\(host)/api/auth/logout"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postString = "token="
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary<String,Any>
                if(json?["s"] as! Int == 1){
                    DispatchQueue.main.async{
                        completion(.success("登出成功"))
                    }
                }else{
                    DispatchQueue.main.async{
                        completion(.failure(.responseProblem))
                    }
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    //使用者登入
    func LoginRequest(Email:String = "",Password:String = "",completion:@escaping(Result<NSDictionary,APIError>)->Void){
        
        //core data access email and password if no input
        var _email = ""
        var _password = ""
        
        if(Email.isEmpty && Password.isEmpty){
            _email = UserDefaults.standard.getAccount() ?? ""
            _password = UserDefaults.standard.getPassword() ?? ""
        }else{
            _email = Email
            _password = Password
        }
        
        let requestString = "\(host)/api/auth/login"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postString = "email=\(_email)&password=\(_password)&iOSVer=\(self.iOSVer.description)"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let _ = response as? HTTPURLResponse,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                self.printJsonData(jsonData: jsonData)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary
                DispatchQueue.main.async{
                    completion(.success(json!))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    //註冊
    func SignUpRequest(Email:String,Password:String,Name:String,Phone:String,Tel:String,GenderVal:Int,Birthdate:String,Id_number:String,DistrictId:Int,Address:String,Pay_mathodVal:Int,Inviter_id_code:String,completion:@escaping(Result<NSDictionary,APIError>)->Void){
        
        let requestString = "\(host)/api/member/join"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postString = "email=\(Email)&password=\(Password)&name=\(Name)&phone=\(Phone)&tel=\(Tel)&gender=\(GenderVal)&birthdate=\(Birthdate)&id_number=\(Id_number)&district_id=\(DistrictId)&address=\(Address)&pay_method=\(Pay_mathodVal)&inviter_id_code=\(Inviter_id_code)&app=1"

        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let _ = response as? HTTPURLResponse,let jsonData = data else {
                DispatchQueue.main.async {
                    completion(.failure(.responseProblem))
                }
                return
            }
            do{
                self.printJsonData(jsonData: jsonData)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary
                DispatchQueue.main.async{
                    completion(.success(json!))
                }
                
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    //檢查 推薦人
    func CheckInviterRequest(inviter_id_code:String,completion:@escaping(Result<Dictionary<String,Any>,APIError>)->Void){
        
        let requestString = "\(host)/api/inviterCheck?inviter_id_code=\(inviter_id_code)"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary<String,Any>
                DispatchQueue.main.async{
                    completion(.success(json!))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    
    //get 地區
    func GetDistrict(completion:@escaping(Result<District,APIError>)->Void){
        
        let requestString = "\(host)/api/district"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                let districts = try JSONDecoder().decode(District.self, from: jsonData)
                DispatchQueue.main.async{
                    completion(.success(districts))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    //get 活動類別
    func GetCategory(completion:@escaping(Result<EventCategory,APIError>)->Void){
        
        let requestString = "\(host)/api/category"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                let eventCategories = try JSONDecoder().decode(EventCategory.self, from: jsonData)
                DispatchQueue.main.async{
                    completion(.success(eventCategories))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    //get EventList
    func GetEventList(page:Int=1,completion:@escaping(Result<NSDictionary,APIError>)->Void){
        print("GetEventList")
        let requestString = "\(host)/api/event/eventList?page=\(page.description)"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let jsonData = data else {
                completion(.failure(.responseProblem))
                return
            }
            do{
                self.printJsonData(jsonData: jsonData)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! NSDictionary
                DispatchQueue.main.async{
                    completion(.success(json))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    //get 使用者參加的 Events
    func GetMyEventList(page:Int=1,completion:@escaping(Result<NSDictionary,APIError>)->Void){
        print("GetMyEventList")
        let requestString = "\(host)/api/event/myEventList?page=\(page.description)"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("Bearer \(UserDefaults.standard.getToken() ?? "")", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                self.printJsonData(jsonData: jsonData)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! NSDictionary
                DispatchQueue.main.async{
                    completion(.success(json))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    //活動內頁 api
    func GetEventDetail(slug:String,completion:@escaping(Result<NSDictionary,APIError>)->Void){
        print("GetEventDetail")
        let requestString = "\(host)/api/event/eventDetail/\(slug)"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("Bearer \(UserDefaults.standard.getToken() ?? "")", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                self.printJsonData(jsonData: jsonData)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! NSDictionary
                DispatchQueue.main.async{
                    completion(.success(json))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    //上傳圖片
    func UploadImageRequest(image:String,completion:@escaping(Result<Dictionary<String,Any>,APIError>)->Void){
        
        let requestString = "\(host)/api/auth/uploadImage"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //        let postString = "token=\()&id=\()&name=\()&image=\()"
        //        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary<String,Any>
                DispatchQueue.main.async{
                    completion(.success(json!))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    
    //get 使用者 資料
    func MyAccountRequest(completion:@escaping(Result<Dictionary<String,Any>,APIError>)->Void){
        
        let requestString = "\(host)/api/auth/myAccount"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.getToken() ?? ""
        let postString = "token=\(token)"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            DispatchQueue.main.async {
                completion(.failure(.responseProblem))
            }
            
            return
            }
            do{
                
                self.printJsonData(jsonData: jsonData)
                let user = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary<String,Any>
                DispatchQueue.main.async{
                    completion(.success(user!))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    
    //get 使用者 資料 首頁用拿的資料比較少
    func MeRequest(completion:@escaping(Result<NSDictionary,APIError>)->Void){
        
        let requestString = "\(host)/api/auth/me"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let token = UserDefaults.standard.getToken()
        let postString = "token=\(token ?? "")"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let _ = response as? HTTPURLResponse,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary
                DispatchQueue.main.async{
                    completion(.success(json!))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    
    
    //更新使用者資料
    func UpdateAccountRequest(Name:String,Phone:String,Tel:String,Address:String,Id_number:String,completion:@escaping(Result<Dictionary<String,Any>,APIError>)->Void){
        
        let requestString = "\(host)/api/auth/updateAccount"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let token = UserDefaults.standard.getToken() ?? ""
        let postString = "token=\(token)&name=\(Name)&phone=\(Phone)&tel=\(Tel)&address=\(Address)&id_number=\(Id_number)"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary<String,Any>
                DispatchQueue.main.async{
                    completion(.success(json!))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    //參加活動
    func JoinEventRequest(event_slug:String,completion:@escaping(Result<Dictionary<String,Any>,APIError>)->Void){
        
        let requestString = "\(host)/api/joinevent/\(event_slug)"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        guard let user_id = UserDefaults.standard.getUserId() else{return}
        let token = UserDefaults.standard.getToken() ?? ""
        let postString = "token=\(token)&id=\(user_id)"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary<String,Any>
                DispatchQueue.main.async{
                    completion(.success(json!))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    
    //取消參加活動
    func CancelEventRequest(event_slug:String,completion:@escaping(Result<Dictionary<String,Any>,APIError>)->Void){
        
        let requestString = "\(host)/api/cancelevent/\(event_slug)"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        guard let user_id = UserDefaults.standard.getUserId() else {return}
        let token = UserDefaults.standard.getToken() ?? ""
        let postString = "token=\(token)&id=\(user_id)"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary<String,Any>
                DispatchQueue.main.async{
                    completion(.success(json!))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    
    //Get 交易紀錄
    func GetTransHistory(page:Int = 1,completion:@escaping(Result<NSDictionary,APIError>)->Void){
        // access from core data
        let requestString = "\(host)/api/transaction/myTransactionHistory?page=\(page.description)"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(UserDefaults.standard.getToken() ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                self.printJsonData(jsonData: jsonData)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! NSDictionary
                
                //let transactions = try JSONDecoder().decode(Transaction.self, from: jsonData)
                DispatchQueue.main.async{
                    completion(.success(json))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    
    //領取 活動獎勵
    func RrawEventReward(event_slug:String,completion:@escaping(Result<Dictionary<String,Any>,APIError>)->Void){
        
        let requestString = "\(host)/api/drawEventReward/\(event_slug)"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        guard let user_id = UserDefaults.standard.getUserId() else {return}
        let postString = "user_id=\(user_id)"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary<String,Any>
                DispatchQueue.main.async{
                    completion(.success(json!))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    
    
    //付錢
    func TransactionRequest(take_id:Int,take_email:String,amount:Int,eventName:String,completion:@escaping(Result<String,APIError>)->Void){
        
        let requestString = "\(host)/api/transaction"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        guard let give_id = UserDefaults.standard.getUserId() else {return}
        let give_email = UserDefaults.standard.getAccount() ?? ""
        let postString = "give_id=\(give_id)&give_email=\(give_email)&take_id=\(take_id)&take_email=\(take_email)&amount=\(amount)&event=\(eventName)"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let _ = response as? HTTPURLResponse,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
//            do{
//                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary<String,Any>
                let json = String(data: jsonData, encoding: .utf8)
                DispatchQueue.main.async{
                    completion(.success(json!))
                }
//            }catch{
//                DispatchQueue.main.async{
//                    print(error)
//                    completion(.failure(.decodingProblem))
//                }
//            }
        }
        dataTask.resume()
    }
    
    
    //檢查是否報到
    func IsUserArrive(slug:String,completion:@escaping(Result<NSDictionary,APIError>)->Void){
        
        let requestString = "\(host)/api/isUserArrive/\(slug)"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "GET"
        let token = UserDefaults.standard.getToken() ?? ""
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                self.printJsonData(jsonData: jsonData)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! NSDictionary
                DispatchQueue.main.async{
                    completion(.success(json))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    
    //掃描報到
    func ArriveEvent(slug:String,completion:@escaping(Result<NSDictionary,APIError>)->Void){
        
        let requestString = "\(host)/api/arriveEvent/\(slug)"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "POST"
        let token = UserDefaults.standard.getToken() ?? ""
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                self.printJsonData(jsonData: jsonData)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! NSDictionary
                DispatchQueue.main.async{
                    completion(.success(json))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    //所有商品
    func GetProductList(page:Int = 1,completion:@escaping(Result<NSDictionary,APIError>)->Void){
        let requestString = "\(host)/api/productList?page=\(page.description)"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                self.printJsonData(jsonData: jsonData)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! NSDictionary
                DispatchQueue.main.async{
                    completion(.success(json))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
        
    }
    
    //產品內頁
    func GetProductDetail(slug:String,completion:@escaping(Result<NSDictionary,APIError>)->Void){
        let requestString = "\(host)/api/product/productDetail/\(slug)"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                self.printJsonData(jsonData: jsonData)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! NSDictionary
                DispatchQueue.main.async{
                    completion(.success(json))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
        
    }
    
    //所有經銷據點
    func GetLocation(completion:@escaping(Result<[NSDictionary],APIError>)->Void){
        let requestString = "\(host)/api/location"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                self.printJsonData(jsonData: jsonData)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [NSDictionary]
                DispatchQueue.main.async{
                    completion(.success(json))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    //購買商品
    func PurchaseProduct(location_id:Int,product_slug:String,completion:@escaping(Result<String,APIError>)->Void){
        let requestString = "\(host)/api/purchase/\(product_slug)"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.httpMethod = "POST"
        let token = UserDefaults.standard.getToken() ?? ""
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let postString = "location_id=\(location_id.description)"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            
            self.printJsonData(jsonData: jsonData)
            let json = String(data: jsonData, encoding: .utf8)
            DispatchQueue.main.async{
                completion(.success(json!))
            }
        }
        dataTask.resume()
    }
    
    //我的兌換清單
    func MyOrderList(page:Int = 1,completion:@escaping(Result<NSDictionary,APIError>)->Void){
        let requestString = "\(host)/api/order/myOrderList?page=\(page.description)"
        guard let requestURL = URL(string:requestString) else{fatalError()}
        var urlRequest = URLRequest(url:requestURL)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        let token = UserDefaults.standard.getToken() ?? ""
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response, _ in guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,let jsonData = data else {
            completion(.failure(.responseProblem))
            return
            }
            do{
                self.printJsonData(jsonData: jsonData)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! NSDictionary
                DispatchQueue.main.async{
                    completion(.success(json))
                }
            }catch{
                DispatchQueue.main.async{
                    print(error)
                    completion(.failure(.decodingProblem))
                }
            }
        }
        dataTask.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}




