//
//  AccountPageVC.swift
//  ElderAppiOS
//
//  Created by Movark on 2019/11/4.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit
import CoreData
import LineSDK

class AccountPageVC: UIViewController {

    @IBOutlet weak var updateImageButtonOutterView: UIView!
    
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
    
    @IBOutlet weak var userInsuranceDateLabel: UILabel!
    
    @IBOutlet weak var userExpiryDateLabel: UILabel!
    
    @IBOutlet weak var userIsValidLabel: UILabel!
    
    @IBOutlet weak var userQrCodeImage: UIImageView!
    
    @IBOutlet weak var applyInsuranceButton: UIButton!
    
    @IBOutlet weak var updateRequestButton: UIButton!
    
    @IBOutlet weak var extendRequestButton: UIButton!
    
    @IBOutlet weak var extendBtn_view: UIView!
    
    var qrcodeImage:CIImage!
    
    var locationUrl:String?
    @IBOutlet weak var locationUrlOutterView: UIView!
    
    var myCourseUrl:String?
    @IBOutlet weak var myCourseUrlOutterView: UIView!
    
    @IBOutlet weak var bindLineOutterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageOutterView.layer.cornerRadius = imageOutterView.frame.size.width / 2
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        updateImageButtonOutterView.layer.cornerRadius = updateImageButtonOutterView.frame.size.width / 2
        
        updateRequestButton.layer.cornerRadius = 5
        extendRequestButton.layer.cornerRadius = 5
        applyInsuranceButton.layer.cornerRadius = 5
        
        loadAccountData()
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    private func loadAccountData(){
            Spinner.start()
            AD.service.MyAccountRequest(completion: { result in switch result{
                case .success(let res):
                    
                self.userImage.image = UIImage(named: "user_default")
                if let img =  res["img"] as? String{
                    self.userImage.loadImageUsingUrlString(urlString: img)
                }
                    
                self.userNameLabel.text = res["name"] as? String ?? ""
                self.userEmailLabel.text = res["email"] as? String ?? ""
                if(res["gender"] as? Int ?? 1 == 1){
                    self.userGenderLabel.text = "男"
                }else{
                    self.userGenderLabel.text = "女"
                }
                self.userBirthdateLabel.text = res["birthdate"] as? String ?? ""
                self.userTelLabel.text = res["tel"] as? String ?? ""
                self.userPhoneLabel.text = res["phone"] as? String ?? ""
                self.userAddressLabel.text = res["address"] as? String ?? ""
                self.userIdNumberLabel.text = res["id_number"] as? String ?? ""
                
                self.userInsuranceDateLabel.text = res["insurance_date"] as? String ?? ""
                self.userExpiryDateLabel.text = res["expiry_date"] as? String ?? ""
                
                if(res["valid"] as! Int == 1){
                    self.extendBtn_view.isHidden = true
                    self.userIsValidLabel.text = "有效"
                    self.userIsValidLabel.textColor = UIColor(red: 1/255, green: 144/255, blue: 35/255, alpha: 1)
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
                    
                if let locationUrl = res["locationUrl"] as? String{
                    self.locationUrl = locationUrl
                    self.locationUrlOutterView.isHidden = false
                }
                    
                if let myCourseUrl = res["myCourseUrl"] as? String{
                    self.myCourseUrl = myCourseUrl
                    self.myCourseUrlOutterView.isHidden = false
                }
                    
//                if let isLineAccountBinded = res["isLineAccountBinded"] as? Bool,
//                   isLineAccountBinded == false{
//                    self.bindLineOutterView.isHidden = false
//                }
                    
                DispatchQueue.main.async {Spinner.stop()}
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {Spinner.stop()}
                }
                
            })
    }
    
    @IBAction func locationUrlAction(_ sender: Any) {
        guard let locationUrl = self.locationUrl else { return }
        let board = UIStoryboard(name: "Main", bundle: nil)
        let vc = board.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.modalPresentationStyle = .currentContext
        self.present(vc,animated: true,completion: {
            vc.loadLocationUrl(locationUrl: locationUrl)
        })
    }
    @IBAction func myCourseUrlAction(_ sender: Any) {
        guard let myCourseUrl = self.myCourseUrl else { return }
        let board = UIStoryboard(name: "Main", bundle: nil)
        let vc = board.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.modalPresentationStyle = .currentContext
        self.present(vc,animated: true,completion: {
            vc.loadMyCourseUrl(myCourseUrl: myCourseUrl)
        })
    }
    @IBAction func bindLineAccountAction(_ sender:Any){
        Spinner.start()
        LoginManager.shared.login(permissions: [.profile], in: self){ result in
            switch result{
            case .success(let loginResult):
                DispatchQueue.main.async {Spinner.stop()}
                if let profile = loginResult.userProfile {
                    self.bindLineAccountRequest(userID: profile.userID)
                }
            case .failure(let error):
                DispatchQueue.main.async {Spinner.stop()}
                print(error)
            }
        }
    }
    
    private func bindLineAccountRequest(userID:String){
        Spinner.start()
        AD.service.bindLineAccount(userID: userID, completion: {result in
            switch result{
            case .success(let res):
                DispatchQueue.main.async {
                    Spinner.stop()
                    var msg = "綁定失敗"
                    if(res == "success"){
                        msg = "綁定成功"
                        self.bindLineOutterView.isHidden = true
                    }
                    Common.SystemAlert(Title: "訊息", Body: msg, SingleBtn: "確定", viewController: self)
                }
            case .failure(let error):
                DispatchQueue.main.async {Spinner.stop()}
                print(error)
            }
        })
    }
    
    @IBAction func logout(_ sender: Any) {
        Spinner.start()
        AD.service.LogoutRequest(completion: {result in
            switch result{
            case .success(_):
                DispatchQueue.main.async {Spinner.stop()}
                UserDefaults.standard.removeUserData()
                self.navigateToLoginPage()
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
        
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
        
        Spinner.start()
        AD.service.ExtandRequest(completion: {result in
            switch result{
            case .success(let res):
                DispatchQueue.main.async {Spinner.stop()}
                let controller = UIAlertController(title: "訊息", message:res, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確定", style: .default, handler:nil)
                controller.addAction(okAction)
                self.present(controller, animated: true, completion:nil)
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
    }
    
    
    @IBAction func applyInsuranceAction(_ sender: Any) {
        
        let applyInsuranceVC = ApplyInsuranceVC(nibName: "ApplyInsuranceVC", bundle: nil)
        self.present(applyInsuranceVC,animated: true)
        
    }
    
   
    
    @IBAction func showStatement(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "StatementVC") as? StatementVC{
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func uploadImage(_ sender: Any) {
        showImagePickerControlActionSheet()
    }
    

}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    func loadImageUsingUrlString(urlString:String,completion:(()->Void)? = nil){
        
        let url = NSURL(string: urlString)
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = imageFromCache
            if(completion != nil){
                completion!()
            }
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
                    if(completion != nil){
                        completion!()
                    }
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

extension AccountPageVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func showImagePickerControlActionSheet(){
        let photoLibraryAction = UIAlertAction(title: "從檔案",style: .default, handler: {(action)in
            self.showImagePickerController(sourceType: .photoLibrary)
        })
        let takePhotoAction = UIAlertAction(title: "拍照",style: .default, handler: {(action)in
            self.showImagePickerController(sourceType: .camera)
        })
        let cancelAction = UIAlertAction(title: "取消",style: .cancel, handler: nil)
        Common.ActionAlert(title: "上傳相片", message: "請選擇取用圖片方式", actions: [photoLibraryAction,takePhotoAction,cancelAction], viewController: self)
        
    }
    
    func showImagePickerController(sourceType:UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage:UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
//            userImage.image = editedImage
            selectedImage = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
//            userImage.image = originalImage
            selectedImage = originalImage
        }
        
        self.dismiss(animated:true,completion: {
            if(selectedImage == nil){ return }
            guard let imageData = selectedImage?.pngData() else { return }
            let imageString = imageData.base64EncodedString()
            Spinner.start()
            AD.service.UploadImageRequest(image: imageString, completion: {result in
                switch result{
                case .success(let res):
                    if let imgUrl = res["imgUrl"] as? String{
                        print("success")
                        DispatchQueue.main.async {
                            self.userImage.loadImageUsingUrlString(urlString: imgUrl)
                            Common.SystemAlert(Title: "訊息", Body: "上傳成功", SingleBtn: "確定", viewController: self)
                        }
                    }
                    DispatchQueue.main.async { Spinner.stop() }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        Common.SystemAlert(Title: "錯誤", Body: "上傳失敗", SingleBtn: "確定", viewController: self)
                        Spinner.stop()
                    }
                }
            })
            
        })
        
    }
}
