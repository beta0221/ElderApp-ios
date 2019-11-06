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
    
    var CatArray:EventCategory?
    var DisArray:District?
    
    var SelectCatId = ""
    var SelectDisId = ""
    
    var unSearchEvent:Event?
    var allEvent:Event?
    var myEvent:Event?
    
    
    @IBOutlet weak var eventSwitcher: UIButton!
    var isAllEvent = true
    
    @IBOutlet var searchBoxView: UIView!
    
    var searchBoxOpenConstraint:NSLayoutConstraint?
    var searchBoxCloseConstraint:NSLayoutConstraint?
    
    @IBOutlet weak var eventSearchBar: UISearchBar!
    @IBOutlet weak var eventCatField: UITextField!
    @IBOutlet weak var eventDisField: UITextField!
    
    var isInitView = true
    
    @objc func dismissPicker(){
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        tap.cancelsTouchesInView=false
        self.view.addGestureRecognizer(tap)
        
        eventSearchBar.delegate = self
        
        searchBoxView.translatesAutoresizingMaskIntoConstraints=false
        searchBoxView.clipsToBounds=true
        self.view.addSubview(searchBoxView)
        searchBoxOpenConstraint=searchBoxView.heightAnchor.constraint(equalToConstant: 240)
        searchBoxCloseConstraint = searchBoxView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            searchBoxView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchBoxView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            searchBoxView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.searchBoxCloseConstraint!
        ])
        
        
        let group = DispatchGroup()
        group.enter()
        service.GetDistrict(completion: {result in
            switch result{
            case .success(let res):
                self.DisArray = res
                let d = DistrictElement(id: 0, group: Group(rawValue: "_"), name: "所有地區")
                self.DisArray?.insert(d,at:0)
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
                self.CatArray = res
                let c = EventCategoryElement(id: 0, name: "所有類別", slug: "_", createdAt: "_", updatedAt: "_")
                self.CatArray?.insert(c, at: 0)
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
            self.initPicker()
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
        service.GetEvents(cat_id: self.SelectCatId, district_id: self.SelectDisId, completion: {result in
            switch result{
            case .success(let res):
                self.unSearchEvent = res
                self.allEvent = res
                
                if(self.isInitView){
                    DispatchQueue.main.async {
                        self.loadEventList(Event: res)
                        self.isInitView = false
                    }
                }else{
                    DispatchQueue.main.async {
                        self.switchToAll()
                    }
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
        self.eventSwitcher.setTitle("我的活動", for: .normal)
        self.isAllEvent = true
    }
    
    
    func switchToMy(){
        self.eventList?.Events = myEvent
        self.eventList?.collectionView.reloadData()
        self.eventSwitcher.setTitle("所有活動", for: .normal)
        self.isAllEvent = false
    }
    
    
    
    @IBAction func eventSwitch(_ sender: Any) {
        if(self.isAllEvent){
            self.switchToMy()
        }else{
            self.switchToAll()
        }
        
    }
    
    func initPicker(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "確定", style: .plain, target: self, action: #selector(self.dismissPicker))
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        let DistrictPicker = UIPickerView()
        DistrictPicker.restorationIdentifier = "DistrictPicker"
        DistrictPicker.delegate = self
        eventDisField.inputView = DistrictPicker
        eventDisField.inputAccessoryView = toolBar
        
        let CatPicker = UIPickerView()
        CatPicker.restorationIdentifier = "CatPicker"
        CatPicker.delegate = self
        eventCatField.inputView = CatPicker
        eventCatField.inputAccessoryView = toolBar
    }
    
    
    
    @IBAction func openSearchBox(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            NSLayoutConstraint.deactivate([self.searchBoxCloseConstraint!])
            NSLayoutConstraint.activate([self.searchBoxOpenConstraint!])
            self.view.layoutIfNeeded()
        },completion: nil)
    }
    
    
    @IBAction func closeSearchBox(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            NSLayoutConstraint.deactivate([self.searchBoxOpenConstraint!])
            NSLayoutConstraint.activate([self.searchBoxCloseConstraint!])
            self.view.layoutIfNeeded()
        },completion: nil)
        
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


extension EventPageVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            self.allEvent = self.unSearchEvent
        } else {

            self.allEvent?.removeAll()
            for arr in self.unSearchEvent! {
                if (arr.title?.contains(searchText))! {
                    self.allEvent!.append(arr)
                }
            }
        }
        
        self.switchToAll()
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print("SearchButtonCLicked")
//    }
    
}

extension EventPageVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.restorationIdentifier == "DistrictPicker"){
            return self.DisArray?.count ?? 0
        }
        if(pickerView.restorationIdentifier == "CatPicker"){
            return self.CatArray?.count ?? 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.restorationIdentifier == "DistrictPicker"){
            return self.DisArray?[row].name ?? "_"
        }
        if(pickerView.restorationIdentifier == "CatPicker"){
            return self.CatArray?[row].name ?? "_"
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.restorationIdentifier == "DistrictPicker"){
            self.eventDisField.text = self.DisArray?[row].name
            if(row > 0){
                self.SelectDisId = "\(self.DisArray?[row].id ?? 0)"
            }else{
                self.SelectDisId = ""
            }
        }
        if(pickerView.restorationIdentifier == "CatPicker"){
            self.eventCatField.text = self.CatArray?[row].name
            if(row > 0){
                self.SelectCatId = "\(self.CatArray?[row].id ?? 0)"
            }else{
                self.SelectCatId = ""
            }
        }
        
        //get event request
        self.getEvent()
    }
    
    
}
