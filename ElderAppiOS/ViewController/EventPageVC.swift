//
//  EventPageVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/5.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class EventPageVC: UIViewController {

    var service = Service()
    @IBOutlet weak var viewOutter: UIView!
    var eventList:EventList?
    
    var CategoryDic:Dictionary<Int,String> = Dictionary<Int,String>()
    var DistrictDic:Dictionary<Int,String> = Dictionary<Int,String>()
    var MyEventDic:Dictionary<Int,Any> = Dictionary<Int,Any>()
    
    var allEvent:Event?
    var myEvent:Event?
    
    @IBOutlet weak var eventSwitcher: UIButton!
    var isAllEvent = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let group = DispatchGroup()
        group.enter()
        service.GetDistrict(completion: {result in
            switch result{
            case .success(let res):
                for dic in res{
                    self.DistrictDic[dic.id!] = dic.name
                }
                group.leave()
            case .failure(let error):
                print(error)
            }
        })
            
        
        group.enter()
        service.GetCategory(completion: {result in
            switch result{
            case .success(let res):
                for cat in res{
                    self.CategoryDic[cat.id!] = cat.name
                }
                group.leave()
            case .failure(let error):
                print(error)
            }
        })
        
        
        group.notify(queue: .main){
            self.getEvent()
        }
        getMyEvent()
        
    }
    
    
    
    
    func getMyEvent() {
        service.GetUserEvent(completion: {result in
            switch result{
            case .success(let res):
                self.myEvent = res
                self.MyEventDic.removeAll()
                for event in res{
                    self.MyEventDic[event.id!] = true
                }
            case .failure(let error):
                print(error)
            }
            
        })
    }
    
    
    
    
    func getEvent(){
        service.GetEvents(cat_id: "", district_id: "", completion: {result in
            switch result{
            case .success(let res):
                self.allEvent = res
                DispatchQueue.main.async {
                    self.loadEventList(Event: res)
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func loadEventList(Event:Event){
        eventList = EventList(_events: Event)
        eventList?.showDetailDelegate = self
        eventList?.CategoryDic = self.CategoryDic
        eventList?.DistrictDic = self.DistrictDic
        eventList!.translatesAutoresizingMaskIntoConstraints=false
        viewOutter.addSubview(eventList!)

        NSLayoutConstraint.activate([
            eventList!.topAnchor.constraint(equalTo: viewOutter.topAnchor, constant: 0),
            eventList!.leadingAnchor.constraint(equalTo: viewOutter.leadingAnchor, constant: 0),
            eventList!.trailingAnchor.constraint(equalTo: viewOutter.trailingAnchor, constant: 0),
            eventList!.bottomAnchor.constraint(equalTo: viewOutter.bottomAnchor, constant: 0),
        ])
        
    }
    
    
    func switchToAll(){
        self.eventList?.Events = allEvent
        self.eventList?.collectionView.reloadData()
    }
    
    
    func switchToMy(){
        self.eventList?.Events = myEvent
        self.eventList?.collectionView.reloadData()
    }
    
    
    
    @IBAction func eventSwitch(_ sender: Any) {
        if(self.isAllEvent){
            self.eventSwitcher.setTitle("所有活動", for: .normal)
            self.switchToMy()
            self.isAllEvent = false
        }else{
            self.eventSwitcher.setTitle("我的活動", for: .normal)
            self.switchToAll()
            self.isAllEvent = true
        }
        
    }
    


}

protocol ShowDetailDelegate {
    func show(Event:EventElement)->Void
}


protocol UpdateEventDelegate{
    func updateMyEvent()->Void
}

extension EventPageVC:ShowDetailDelegate,UpdateEventDelegate{
    func updateMyEvent() {
        self.getMyEvent()
    }
    
    func show(Event: EventElement) {

        let EventDetailPageVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventDetailPageVC") as! EventDetailPageVC
        EventDetailPageVC.event = Event
        EventDetailPageVC.updateEventDelegate = self
        if(self.MyEventDic[Event.id!] != nil){
            EventDetailPageVC.hasJoined = true
        }
        
        self.present(EventDetailPageVC, animated: true, completion: nil)

    }
    
    
    
}
