//
//  EventRewardScannerVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/6.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit
import AVFoundation

class EventRewardScannerVC: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    
    var captureSession:AVCaptureSession?
    var previewLayer:AVCaptureVideoPreviewLayer!
    
    var rewardMode = true
    
    @IBOutlet weak var camWindow: UIView!
    
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var arriveLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissButton()
        if(!rewardMode){
            rewardLabel.isHidden = true
            arriveLabel.isHidden = false
        }
        
        
        

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {return}

        
        let videoInput:AVCaptureDeviceInput
        do{
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }catch let error{
            print(error)
            return
        }

        if(captureSession?.canAddInput(videoInput) ?? false){
            captureSession?.addInput(videoInput)
        }else{
            return
        }
        
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if(captureSession?.canAddOutput(metadataOutput) ?? false){
            captureSession?.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr,.ean8,.ean13,.pdf417]
        }else{
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = camWindow.layer.bounds

        camWindow.layer.addSublayer(previewLayer)
        captureSession?.startRunning()
        
    }
    
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
           captureSession?.stopRunning()
           
           if let metadataObject = metadataObjects.first{
               guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else{return}
               guard let stringValue = readableObject.stringValue else {
                   return
               }
               
               print("\(stringValue)")
            
            let str = stringValue.split(separator: ",")
            
            if (str.count != 2){
                Common.SystemAlert(Title: "錯誤", Body: "條碼錯誤", SingleBtn: "確定", viewController: self,handler: {_ in
                self.captureSession?.startRunning()
                })
            }
            
            if(String(str[0]) == "reward"){
                self.getReward(stringValue: String(str[1]))
            }else if(String(str[0]) == "arrive"){
                self.arriveEvent(stringValue: String(str[1]))
            }
               
        }
           
    }
    
    
    
    func getReward(stringValue:String){
        AD.service.RrawEventReward(event_slug: stringValue, completion: {result in
            switch result{
            case .success(let res):
                if(res["s"] as! Int == 1){
                    
                    Common.SystemAlert(Title: "成功", Body: (res["m"] as! String), SingleBtn: "確定", viewController: self,handler: {_ in self.captureSession?.startRunning()})
                    
                }else{
                    Common.SystemAlert(Title: "錯誤", Body: (res["m"] as! String), SingleBtn: "確定", viewController: self,handler: {_ in
                        self.captureSession?.startRunning()
                    })
                    
                }
            case .failure(let error):
                Common.SystemAlert(Title: "錯誤", Body: "\(error)", SingleBtn: "確定", viewController: self)
            }
        })
    }
    
    func arriveEvent(stringValue:String){
        AD.service.ArriveEvent(slug: stringValue, completion: {result in
            switch result{
            case .success(let res):
                
                if(res["s"] as! Int == 1){
                    self.showPassPermitVC(title: res["name"] as? String ?? "")
                }else{
                    Common.SystemAlert(Title: "錯誤", Body: (res["m"] as! String), SingleBtn: "確定", viewController: self,handler: {_ in
                        self.captureSession?.startRunning()
                    })
                }
                
                break
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func showPassPermitVC(title:String){
        if let controller = storyboard?.instantiateViewController(withIdentifier: "PassPermitVC") as? PassPermitVC{
            controller.eventTitle = title
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    


}
