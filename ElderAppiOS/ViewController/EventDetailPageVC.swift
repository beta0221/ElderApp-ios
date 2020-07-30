//
//  EventDetailPageVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/5.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class EventDetailPageVC: UIViewController {

    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!
    @IBOutlet weak var eventBodyTextview: UITextView!
    
    @IBOutlet weak var cancelEventButton: UIButton!
    @IBOutlet weak var joinEventButton: UIButton!
    @IBOutlet weak var rewardAndArriveButton: UIView!
    
    var updateEventDelegate:UpdateEventDelegate?
    
    var slug:String = ""
    var isParticipated:Bool = false
    
    @IBAction func unwindEventDetailPageVC(segue: UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissButton()
        
        eventImageView.image = UIImage(named: "event_default")
        self.getEventDetail()
    }
    
    private func checkParticipateStatus(){
        cancelEventButton.isHidden = !isParticipated
        rewardAndArriveButton.isHidden = !isParticipated
        joinEventButton.isHidden = isParticipated
        
    }
    
    private func getEventDetail(){
        if(self.slug.isEmpty){return}
        Spinner.start()
        AD.service.GetEventDetail(slug: self.slug, completion: {result in
            switch result{
            case .success(let res):
                guard let event = res["event"] as? NSDictionary else {
                    DispatchQueue.main.async {Spinner.stop()}
                    return
                }
                self.isParticipated = res["isParticipated"] as? Bool ?? false
                
                if let imgUrl = event["imgUrl"] as? String{
                    self.eventImageView.loadImageUsingUrlString(urlString: imgUrl)
                }
                
                self.eventTitleLabel.text = event["title"] as? String ?? ""
                self.rewardLabel.text = (event["reward"] as? Int ?? 0).description
                self.eventBodyTextview.text = event["body"] as? String ?? ""
                
                if let type = event["type"] as? Int{
                    if(type == 1){
                        self.dateTimeLabel.text = "活動時間：\(event["dateTime"] as? String ?? "")"
                        self.deadLineLabel.text = "截止日期：\(event["deadline"] as? String ?? "")"
                    }else{
                        self.dateTimeLabel.text = "經常性活動"
                        self.deadLineLabel.text = ""
                    }
                }
                
                self.checkParticipateStatus()
                
                DispatchQueue.main.async {Spinner.stop()}
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
    }
    
    @IBAction func joinButton(_ sender: Any) {
        AD.service.JoinEventRequest(event_slug: self.slug, completion: {result in
            switch result{
            case .success(let res):
                if(res["s"] as! Int == 1){
                    Common.SystemAlert(Title: "成功", Body: (res["m"] as! String), SingleBtn: "確定", viewController: self)
                    self.isParticipated = true
                    self.checkParticipateStatus()
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
        
        AD.service.CancelEventRequest(event_slug: self.slug, completion: {result in
            switch result{
            case .success(let res):
                if(res["s"] as! Int == 1){
                    Common.SystemAlert(Title: "成功", Body: (res["m"] as! String), SingleBtn: "確定", viewController: self)
                    self.isParticipated = false
                    self.checkParticipateStatus()
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
        AD.service.IsUserArrive(slug: self.slug, completion: {result in
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
            controller.eventTitle = self.eventTitleLabel.text
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}
