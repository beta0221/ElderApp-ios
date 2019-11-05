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
    
    
    @IBOutlet weak var camWindow: UIView!
    
    var service = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            
            service.RrawEventReward(event_slug: stringValue, completion: {result in
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
           
       }
    
    
    
    


}
