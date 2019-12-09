//
//  GiveMoneyVC.swift
//  ElderAppiOS
//
//  Created by 林奕儒 on 2019/11/4.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit
import AVFoundation

class GiveMoneyVC: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    
    var captureSession:AVCaptureSession?
    var previewLayer:AVCaptureVideoPreviewLayer!
    
    var take_id:Int?
    var take_email:String?
    var take_name:String?
    
    @IBOutlet weak var camWindow: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissButton()
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "goto_GiveMoneyFormVC")
        {
            let GiveMoneyFormVC = segue.destination as! GiveMoneyFormVC
            
            GiveMoneyFormVC.take_id = self.take_id
            GiveMoneyFormVC.take_email = self.take_email
            GiveMoneyFormVC.take_name = self.take_name
            
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        
        if let metadataObject = metadataObjects.first{
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else{return}
            guard let stringValue = readableObject.stringValue else {
                return
            }
            
            print("\(stringValue)")
            
            let temp = stringValue.components(separatedBy: ",")
            if(temp.count == 3){
                self.take_id = Int(temp[0])
                self.take_email = temp[2]
                self.take_name = temp[1]
                
                self.performSegue(withIdentifier: "goto_GiveMoneyFormVC", sender: nil)
                
            }else{
                Common.SystemAlert(Title: "錯誤", Body: "無效的QRcode", SingleBtn: "確定", viewController: self, handler: {_ in
                    DispatchQueue.main.async {
                        self.captureSession?.startRunning()
                    }
                })
            }
            
            
            
            
            
        }
        
    }
    

}
