//
//  TakeAPhoto.swift
//
//
//  Created by Jordan Kiley on 7/18/16.
//
//

import Foundation
import CameraManager
import AVFoundation

class TakeAPhoto : UIViewController {
    let stillImageOutput = AVCaptureStillImageOutput()

    @IBOutlet weak var redPanda: UIImageView!
//    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var save: UIButton!
//    @IBOutlet weak var takePicture: UIButton!
    @IBOutlet weak var cancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraSession()
        view.layer.addSublayer(previewLayer)
        cameraSession.startRunning()
        self.view.bringSubviewToFront(redPanda)
        self.view.bringSubviewToFront(cancel)
//        self.view.bringSubviewToFront(takePicture)
        self.view.bringSubviewToFront(save)
    }
    
    // Saves the camera's output
    @IBAction func savePicture(sender: AnyObject) {
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
            }
        }
    }
    
    func viewDidAppear() {

        
    }
    
    lazy var cameraSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        return session
    }()
    
    //Makes the video appear
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
        preview.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        preview.position = CGPoint(x: CGRectGetMidX(self.view.bounds), y: CGRectGetMidY(self.view.bounds))
        preview.videoGravity = AVLayerVideoGravityResize
        self.view.layer.insertSublayer(preview, atIndex: 0)
        return preview
    }()
    
    func setupCameraSession() {
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo) as AVCaptureDevice
        print(captureDevice)
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            cameraSession.beginConfiguration()
            
            if (cameraSession.canAddInput(deviceInput) == true) {
                cameraSession.addInput(deviceInput)
            }
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(unsignedInt: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if (cameraSession.canAddOutput(dataOutput) == true) {
                cameraSession.addOutput(dataOutput)
            }
            cameraSession.commitConfiguration()
            
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
        //Makes camera session's output a StillImage
        if cameraSession.canAddOutput(stillImageOutput) {
            cameraSession.addOutput(stillImageOutput)
        }

    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
}


}
