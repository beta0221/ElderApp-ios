//
//  EventDetailPageVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/5.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class EventDetailPageVC: UIViewController {

    
    var event:EventElement?
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!
    @IBOutlet weak var eventBodyTextview: UITextView!
    
    @IBOutlet weak var cancelEventButton: UIButton!
    @IBOutlet weak var joinEventButton: UIButton!
    @IBOutlet weak var rewardAndArriveButton: UIView!
    
    var updateEventDelegate:UpdateEventDelegate?
    
    var service = Service()
    
    var hasJoined = false
    
    @IBAction func unwindEventDetailPageVC(segue: UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissButton()
        
        let urlString = "https://www.happybi.com.tw/images/events/\(event?.slug ?? "")/\(event?.image ?? "")"
        eventImageView.loadImageUsingUrlString(urlString: urlString)
        eventTitleLabel.text = event?.title
        dateTimeLabel.text = "活動時間:\(event?.dateTime ?? "")"
        deadLineLabel.text = "截止日期:\(event?.deadline ?? "")"
        eventBodyTextview.text = event?.body
        
        checkStatus()
    }
    
    func checkStatus(){
        cancelEventButton.isHidden = !hasJoined
        rewardAndArriveButton.isHidden = !hasJoined
        joinEventButton.isHidden = hasJoined
        
    }
    
    @IBAction func joinButton(_ sender: Any) {
        service.JoinEventRequest(event_slug: (event?.slug!)!, completion: {result in
            switch result{
            case .success(let res):
                if(res["s"] as! Int == 1){
                    Common.SystemAlert(Title: "成功", Body: (res["m"] as! String), SingleBtn: "確定", viewController: self)
                    self.hasJoined = true
                    self.checkStatus()
                    self.updateEventDelegate?.updateMyEvent()
                }else{
                    Common.SystemAlert(Title: "訊息", Body: (res["m"] as! String), SingleBtn:"確定", viewController: self)
                }
            case .failure(let error):
                print(error)
                Common.SystemAlert(Title: "錯誤", Body:"\(error)", SingleBtn:"確定", viewController: self)
            }
        })
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        service.CancelEventRequest(event_slug: (event?.slug!)!, completion: {result in
            switch result{
            case .success(let res):
                if(res["s"] as! Int == 1){
                    Common.SystemAlert(Title: "成功", Body: (res["m"] as! String), SingleBtn: "確定", viewController: self)
                    self.hasJoined = false
                    self.checkStatus()
                    self.updateEventDelegate?.updateMyEvent()

                }else{
                    
                    Common.SystemAlert(Title: "訊息", Body: (res["m"] as! String), SingleBtn:"確定", viewController: self)
                }
            case .failure(let error):
                print(error)
                Common.SystemAlert(Title: "錯誤", Body:"\(error)", SingleBtn:"確定", viewController: self)
            }
        })
    }
    
    @IBAction func isUserArrive(_ sender: Any) {
        service.IsUserArrive(slug: self.event?.slug ?? "", completion: {result in
            switch result{
            case .success(let res):
                let s = res["s"] as! Int
                if(s == 1){
                    //已完成報到 顯示通行證
                    self.showPassPermitVC()
                }else if(s == 2){
                    //未完成報到 掃描 qrcode
                    self.showScannerVC()
                }else{
                    Common.SystemAlert(Title: "錯誤", Body: res["m"] as? String ?? "", SingleBtn: "確定", viewController: self)
                }
                
                break
            case .failure(let error):
                print(error)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "arriveScanner")
        {
            let eventScannerVC = segue.destination as! EventRewardScannerVC
            
            eventScannerVC.rewardMode = false
            
        }
    }
    
    func showScannerVC(){
        self.performSegue(withIdentifier: "arriveScanner", sender: nil)
    }
    
    func showPassPermitVC(){
        if let controller = storyboard?.instantiateViewController(withIdentifier: "PassPermitVC") as? PassPermitVC{
            controller.eventTitle = self.event?.title ?? ""
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}
