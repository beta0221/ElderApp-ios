//
//  InviterScannerPageVC.swift
//  ElderAppiOS
//
//  Created by Movark on 2019/11/6.
//  Copyright © 2019 林奕儒. All rights reserved.
//

import UIKit
import AVFoundation

class InviterScannerPageVC: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    var captureSession:AVCaptureSession?
    var previewLayer:AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var camWindow: UIView!
    
    var getInviterIdCode:GetInviterIdCode?
    
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
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        
        if let metadataObject = metadataObjects.first{
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else{return}
            guard let stringValue = readableObject.stringValue else {
                return
            }

            getInviterIdCode?.get(idCode: stringValue)

            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    

}
