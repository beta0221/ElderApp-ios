//
//  EventPageVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/5.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class EventPageVC: UIViewController {

    @IBOutlet weak var allEventButton: UIButton!
    @IBOutlet weak var myEventButton: UIButton!
    
    @IBOutlet var searchBoxView: UIView!
    @IBOutlet weak var eventSearchBar: UISearchBar!
    @IBOutlet weak var eventCatField: UITextField!
    @IBOutlet weak var eventDisField: UITextField!
    
    @IBOutlet weak var eventCollectionView: UICollectionView!
    var page:Int = 1
    var hasNextPage:Bool = true
    
    var eventList:[NSDictionary] = []
    
    var showMyEvent:Bool = false
    
    @objc func dismissPicker(){
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        tap.cancelsTouchesInView=false
        self.view.addGestureRecognizer(tap)
        
        allEventButton.roundButton()
        myEventButton.roundButton()
        self.switchOn(button: allEventButton)
        
        eventCollectionView.dataSource = self
        eventCollectionView.delegate = self
        
        getEventList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showEventDetail), name: Notification.Name("showEventDetail"), object: nil)
    }
    
    private func presentEventDetail(slug:String){
        let board = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = board.instantiateViewController(withIdentifier: "EventDetailPageVC") as? EventDetailPageVC else{ return }
        vc.slug = slug
        vc.updateEventDelegate = self
        self.present(vc,animated: true)
    }
    @objc private func showEventDetail(_ notification:NSNotification){
        print("showEventDetail")
        guard let slug = notification.userInfo?["slug"] as? String else { return }
        print("slug:\(slug)")
        self.presentEventDetail(slug: slug)
    }
    
    
    func getMyEventList() {
        Spinner.start()
        AD.service.GetMyEventList(page:self.page,completion:{result in
            switch result{
            case .success(let res):
                
                self.eventList += res["eventList"] as? [NSDictionary] ?? []
                
                let hasNextPage = res["hasNextPage"] as? Bool ?? false
                if(hasNextPage){ self.page += 1 }
                self.hasNextPage = hasNextPage
                
                self.eventCollectionView.reloadData()
                DispatchQueue.main.async {Spinner.stop()}
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
    }
    
    func getEventList(){
        Spinner.start()
        AD.service.GetEventList(page: self.page, completion: {result in
            switch result{
            case .success(let res):
                
                self.eventList += res["eventList"] as? [NSDictionary] ?? []
                
                let hasNextPage = res["hasNextPage"] as? Bool ?? false
                if(hasNextPage){ self.page += 1 }
                self.hasNextPage = hasNextPage
                
                self.eventCollectionView.reloadData()
                DispatchQueue.main.async {Spinner.stop()}
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {Spinner.stop()}
            }
        })
        
    }
    
    //254 167 53
    
    private func switchOn(button:UIButton){
        button.backgroundColor = UIColor(displayP3Red: 254/255, green: 167/255, blue: 53/255, alpha: 100)
    }
    private func switchOff(button:UIButton){
        button.backgroundColor = .none
    }
    
    @IBAction func switchToAllEvent(_ sender:Any){
        if(showMyEvent != true){return}
        self.showMyEvent = false
        self.page = 1
        self.hasNextPage = true
        self.eventList = []
        self.getEventList()
        self.switchOn(button: allEventButton)
        self.switchOff(button: myEventButton)
    }
    @IBAction func switchToMyEvent(_ sender:Any){
        if(showMyEvent == true){return}
        self.showMyEvent = true
        self.page = 1
        self.hasNextPage = true
        self.eventList = []
        self.getMyEventList()
        self.switchOn(button: myEventButton)
        self.switchOff(button: allEventButton)
    }
    
    
    
//    func initPicker(){
//        let toolBar = UIToolbar()
//        toolBar.sizeToFit()
//        let doneBtn = UIBarButtonItem(title: "確定", style: .plain, target: self, action: #selector(self.dismissPicker))
//        toolBar.setItems([doneBtn], animated: false)
//        toolBar.isUserInteractionEnabled = true
//
//        let DistrictPicker = UIPickerView()
//        DistrictPicker.restorationIdentifier = "DistrictPicker"
//        DistrictPicker.delegate = self
//        eventDisField.inputView = DistrictPicker
//        eventDisField.inputAccessoryView = toolBar
//
//        let CatPicker = UIPickerView()
//        CatPicker.restorationIdentifier = "CatPicker"
//        CatPicker.delegate = self
//        eventCatField.inputView = CatPicker
//        eventCatField.inputAccessoryView = toolBar
//    }
    
    
    

    
    
    @IBAction func closeSearchBox(_ sender: Any) {
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
//            NSLayoutConstraint.deactivate([self.searchBoxOpenConstraint!])
//            NSLayoutConstraint.activate([self.searchBoxCloseConstraint!])
//            self.view.layoutIfNeeded()
//        },completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

protocol ShowDetailDelegate {
    func show(Event:EventElement)->Void
}


protocol UpdateEventDelegate{
    func updateMyEvent()->Void
}


extension EventPageVC:UpdateEventDelegate{
    func updateMyEvent() {
        if(showMyEvent){
            self.page = 1
            self.hasNextPage = true
            self.eventList = []
            self.getMyEventList()
        }
    }
}


//
//extension EventPageVC:ShowDetailDelegate,UpdateEventDelegate{
//    func updateMyEvent() {
//        self.getMyEvent()
//    }
//
//    func show(Event: EventElement) {
//
//        let EventDetailPageVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventDetailPageVC") as! EventDetailPageVC
//        EventDetailPageVC.event = Event
//        EventDetailPageVC.updateEventDelegate = self
//        if(self.MyEventDic[Event.id!] != nil){
//            EventDetailPageVC.hasJoined = true
//        }
//
//        self.present(EventDetailPageVC, animated: true, completion: nil)
//
//    }
//
//}


//extension EventPageVC:UISearchBarDelegate{
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchText == "" {
//            self.allEvent = self.unSearchEvent
//        } else {
//
//            self.allEvent?.removeAll()
//            for arr in self.unSearchEvent! {
//                if (arr.title?.contains(searchText))! {
//                    self.allEvent!.append(arr)
//                }
//            }
//        }
//
//        self.switchToAll()
//    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print("SearchButtonCLicked")
//    }
    
//}

//extension EventPageVC:UIPickerViewDelegate,UIPickerViewDataSource{
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if(pickerView.restorationIdentifier == "DistrictPicker"){
//            return self.DisArray?.count ?? 0
//        }
//        if(pickerView.restorationIdentifier == "CatPicker"){
//            return self.CatArray?.count ?? 0
//        }
//        return 0
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if(pickerView.restorationIdentifier == "DistrictPicker"){
//            return self.DisArray?[row].name ?? "_"
//        }
//        if(pickerView.restorationIdentifier == "CatPicker"){
//            return self.CatArray?[row].name ?? "_"
//        }
//        return ""
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if(pickerView.restorationIdentifier == "DistrictPicker"){
//            self.eventDisField.text = self.DisArray?[row].name
//            if(row > 0){
//                self.SelectDisId = "\(self.DisArray?[row].id ?? 0)"
//            }else{
//                self.SelectDisId = ""
//            }
//        }
//        if(pickerView.restorationIdentifier == "CatPicker"){
//            self.eventCatField.text = self.CatArray?[row].name
//            if(row > 0){
//                self.SelectCatId = "\(self.CatArray?[row].id ?? 0)"
//            }else{
//                self.SelectCatId = ""
//            }
//        }
//
//        //get event request
//        self.getEvent()
//    }
//
//
//}



extension EventPageVC:UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.eventList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let eventCVC:EventCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCVC", for: indexPath) as! EventCVC
        eventCVC.setCell(event: self.eventList[indexPath.row])
        return eventCVC
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = self.eventList[indexPath.row]
        if let slug = event["slug"] as? String{
            self.presentEventDetail(slug: slug)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.eventCollectionView.frame.size.width
        return CGSize(width: width, height: 360.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(indexPath.row == eventList.count - 1 && hasNextPage){
            if(showMyEvent){
                self.getMyEventList()
            }else{
                self.getEventList()
            }
        }
    }
}
