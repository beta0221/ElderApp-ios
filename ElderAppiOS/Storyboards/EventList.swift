//
//  EventList.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/5.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit

class EventList: UIView {

    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var showDetailDelegate:ShowDetailDelegate?
    var CategoryDic:Dictionary<Int,String>?
    var DistrictDic:Dictionary<Int,String>?
    var Events:Event?
    
    required init?(_events:Event) {
        Events=_events
        super.init(frame:.zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(){
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("EventList", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        
        let nib = UINib(nibName: "EventCVC", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "EventCVC")
        collectionView.dataSource = self
        collectionView.delegate = self

    }
    
    
    func showEventDetail(){
        
    }
    
    
}


extension EventList:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Events!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCVC", for: indexPath) as? EventCVC else {
            fatalError("can't dequeue ProductCell")
        }
        cell.SetEventItem(event: Events![indexPath.row],catDic: self.CategoryDic!,disDic: self.DistrictDic!)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let showEvent = Events![indexPath.row]
        self.showDetailDelegate?.show(Event: showEvent)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.frame.width
        return CGSize(width: width, height: 200.0)
    }
    
    
}
