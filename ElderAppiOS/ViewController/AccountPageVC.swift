//
//  AccountPageVC.swift
//  ElderAppiOS
//
//  Created by Movark on 2019/11/4.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit
import CoreData

class AccountPageVC: UIViewController {

    
    @IBOutlet weak var imageOutterView: UIView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var userGenderLabel: UILabel!
    
    @IBOutlet weak var userBirthdateLabel: UILabel!
    
    @IBOutlet weak var userPhoneLabel: UILabel!
    
    @IBOutlet weak var userTelLabel: UILabel!
    
    @IBOutlet weak var userAddressLabel: UILabel!
    
    @IBOutlet weak var userIdNumberLabel: UILabel!
    
    @IBOutlet weak var userIsValidLabel: UILabel!
    
    @IBOutlet weak var userQrCodeImage: UIImageView!
    
    @IBOutlet weak var updateRequestButton: UIButton!
    
    @IBOutlet weak var extendRequestButton: UIButton!
    
    @IBOutlet weak var extendBtn_view: UIView!
    
    var qrcodeImage:CIImage!
    
    var service = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageOutterView.layer.cornerRadius = imageOutterView.frame.size.width / 2
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        updateRequestButton.layer.cornerRadius = 5
        extendRequestButton.layer.cornerRadius = 5
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadAccountData()
        print("loadAccountData")
    }
    
    private func loadAccountData(){
            
            service.MyAccountRequest(completion: { result in switch result{
                case .success(let res):
                    
                if((res["img"] as? String ?? "null") == "null"){
                    self.userImage.image = UIImage(named: "user_default")
                }else{
                    let img_url = "\(self.service.host)/images/users/\(res["id"] as! Int)/\(res["img"] as! String)"
                    self.userImage.loadImageUsingUrlString(urlString: img_url)
                }
                    
                self.userNameLabel.text = res["name"] as? String ?? ""
                self.userEmailLabel.text = res["email"] as? String ?? ""
                if(res["gender"] as! Int == 1){
                    self.userGenderLabel.text = "男"
                }else{
                    self.userGenderLabel.text = "女"
                }
                self.userBirthdateLabel.text = res["birthdate"] as? String ?? ""
                self.userTelLabel.text = res["tel"] as? String ?? ""
                self.userPhoneLabel.text = res["phone"] as? String ?? ""
                self.userAddressLabel.text = res["address"] as? String ?? ""
                self.userIdNumberLabel.text = res["id_number"] as? String ?? ""
                if(res["valid"] as! Int == 1){
                    self.extendBtn_view.isHidden = true
                    self.userIsValidLabel.text = "有效"
                    self.userIsValidLabel.textColor = .green
                }else{
                    self.extendBtn_view.isHidden = false
                    self.userIsValidLabel.text = "待付款"
                    self.userIsValidLabel.textColor = .red
                }
                
                let myString = res["id_code"] as! String
                let data = myString.data(using: String.Encoding.utf8)
                guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
                qrFilter.setValue(data, forKey: "inputMessage")
                guard let qrcodeImage = qrFilter.outputImage else { return }
                let scaledQrImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
                self.userQrCodeImage.image = UIImage(ciImage:scaledQrImage)
                
                case .failure(let error):
                    print(error)
                }
                
            })
    }
    
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeUserData()
        self.navigateToLoginPage()
    }
    
    private func navigateToLoginPage(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginPageVC") as! LoginPageVC
        let navigationController = UINavigationController(rootViewController: newViewController)
        self.view.window?.rootViewController = navigationController
    }
    
    
    @IBAction func updateAccount(_ sender: Any) {
        
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "UpdateAccountPageVC") as? UpdateAccountPageVC{
            controller.updateDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func extendRequest(_ sender: Any) {
        
        let service = Service()
        service.ExtandRequest(completion: {result in
            switch result{
            case .success(let res):
                let controller = UIAlertController(title: "訊息", message:res, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確定", style: .default, handler:nil)
                controller.addAction(okAction)
                self.present(controller, animated: true, completion:nil)
            case .failure(let error):
                print(error)
            }
        })
    }
   
    
    @IBAction func showStatement(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "StatementVC") as? StatementVC{
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func uploadImage(_ sender: Any) {
        Common.SystemAlert(Title: "非常抱歉", Body: "此功能尚未開放", SingleBtn: "確定", viewController: self)
    }
    

}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    func loadImageUsingUrlString(urlString:String){
        
    
        let url = NSURL(string: urlString)
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = imageFromCache
            return
        }
        
        let urlRequest = URLRequest(url: url! as URL)
        let dataTask = URLSession.shared.dataTask(with: urlRequest){(data,response,error) in
            
            if error != nil{
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let imageToCache = UIImage(data: data!){
                    imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    self.image = imageToCache
                }   
            }
            
        }
        
        dataTask.resume()
        
        
        
        
    }
    
    
    
    
}

extension AccountPageVC:UpdateDelegate{
    func update() {
        loadAccountData()
    }
    
    
}


protocol UpdateDelegate {
    func update()->Void
}
