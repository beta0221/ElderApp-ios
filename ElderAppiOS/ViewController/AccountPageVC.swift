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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageOutterView.layer.cornerRadius = imageOutterView.frame.size.width / 2
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        updateRequestButton.layer.cornerRadius = 5
        extendRequestButton.layer.cornerRadius = 5
        
        
        
        
        let service = Service()
        service.MyAccountRequest(completion: { result in switch result{
            case .success(let res):
                let img_url = "\(service.host)/images/users/\(res.id!)/\(res.img!)"
                let url = NSURL(string:img_url)
                let data = NSData(contentsOf: url! as URL)
                self.userImage.image = UIImage(data: data! as Data)
            case .failure(let error):
                print(error)
            }
            
        })
        
        
    }
    
    
    @IBAction func logout(_ sender: Any) {
        _ = UserHelper.clearUser()
        self.navigateToLoginPage()
    }
    
    private func navigateToLoginPage(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginPageVC") as! LoginPageVC
        let navigationController = UINavigationController(rootViewController: newViewController)
        self.view.window?.rootViewController = navigationController
    }
    
    
    
    
    
    

}
