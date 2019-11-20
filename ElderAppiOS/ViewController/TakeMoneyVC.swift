//
//  TakeMoneyVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/4.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class TakeMoneyVC: UIViewController {

    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    var qrcodeImage:CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user_id = UserDefaults.standard.getUserId()?.description ?? ""
        let user_name = UserDefaults.standard.getUserName() ?? ""
        let user_account = UserDefaults.standard.getAccount() ?? ""
        
        let myString = "\(user_id),\(user_name),\(user_account)"
        
        let data = myString.data(using: String.Encoding.utf8)
        
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        
        qrFilter.setValue(data, forKey: "inputMessage")
        
        guard let qrcodeImage = qrFilter.outputImage else { return }
        
        let scaledQrImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        qrCodeImageView.image = UIImage(ciImage:scaledQrImage)
        
        
    }
    


}
