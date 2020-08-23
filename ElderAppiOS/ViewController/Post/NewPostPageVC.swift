//
//  NewPostPageVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2020/8/17.
//  Copyright © 2020 林奕儒. All rights reserved.
//

import UIKit

class NewPostPageVC: UIViewController {
    
    
    @IBOutlet weak var contentScrollview: UIScrollView!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleImageOutterView: UIView!
    @IBOutlet weak var cancelUploadImageButton: UIButton!
    
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var delegate:NewPostPageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addDismissButton()
        keyboardDissmissable()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func submitPost(_ sender: Any) {
        
        if(titleTextfield.text?.isEmpty ?? true){return}
        if(bodyTextView.text?.isEmpty ?? true){return}
        var imageString = ""
        if(self.titleImage.image != nil){
            guard let imageData = self.titleImage.image!.pngData() else { return }
            imageString = imageData.base64EncodedString()
        }
        
        Spinner.start()
        AD.service.makeNewPost(title: titleTextfield.text!, body: bodyTextView.text!,image:imageString ,completion: {result in
            switch result{
            case .success(let res):
                if let alert = res["alert"] as? String{
                    DispatchQueue.main.async {
                        Spinner.stop()
                        Common.SystemAlert(Title: "訊息", Body: alert, SingleBtn: "確定", viewController: self)
                    }
                }else{
                    DispatchQueue.main.async {
                        Spinner.stop()
                        Common.SystemAlert(Title: "訊息", Body: "發布成功", SingleBtn: "確定", viewController: self,handler: {_ in
                            self.dismiss(animated: true,completion: {
                                self.delegate?.reload()
                            })
                        })
                    }
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    Common.SystemAlert(Title: "訊息", Body: "錯誤", SingleBtn: "確定", viewController: self)
                    Spinner.stop()
                }
            }
        })
    }
    
    
    
    @IBAction func uploadImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController,animated: true,completion: nil)
    }
    
    
    @IBAction func canceluploadImage(_ sender: Any) {
        self.titleImage.image = nil
        self.titleImageOutterView.isHidden = true
        self.cancelUploadImageButton.isHidden = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            let keyboardHeight = keyboardSize.height
//
//            self.contentScrollview.setContentOffset(CGPoint(x: 0, y: keyboardHeight), animated: true)
//        }
    }
    @objc func keyboardWillHide(_ sender:Any){
        //self.contentScrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}


extension NewPostPageVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage:UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImage = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage = originalImage
        }
        
        self.dismiss(animated:true,completion: {
            self.titleImageOutterView.isHidden = false
            self.cancelUploadImageButton.isHidden = false
            self.titleImage.image = selectedImage
        })
        
    }
}



