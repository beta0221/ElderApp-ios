//
//  NewPostPageVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2020/8/17.
//  Copyright © 2020 林奕儒. All rights reserved.
//

import UIKit

class NewPostPageVC: UIViewController {
    
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var delegate:NewPostPageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addDismissButton()
        keyboardDissmissable()
    }
    
    @IBAction func submitPost(_ sender: Any) {
        
        if(titleTextfield.text?.isEmpty ?? true){return}
        if(bodyTextView.text?.isEmpty ?? true){return}

        Spinner.start()
        AD.service.makeNewPost(title: titleTextfield.text!, body: bodyTextView.text!, completion: {result in
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    Spinner.stop()
                    Common.SystemAlert(Title: "訊息", Body: "發布成功", SingleBtn: "確定", viewController: self,handler: {_ in
                        self.dismiss(animated: true,completion: {
                            self.delegate?.reload()
                        })
                    })
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
    

}
