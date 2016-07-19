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
    var preview =  AVCaptureVideoPreviewLayer()
    var imageToSave = UIImage()
    @IBOutlet weak var redPanda: UIImageView!
    @IBOutlet weak var picture: UIImageView!
    //    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var save: UIButton!
    //    @IBOutlet weak var takePicture: UIButton!
    @IBOutlet weak var cancel: UIButton!
    
    @IBOutlet weak var openPreview: UIButton!
    
    @IBAction func openPreview(sender: AnyObject) {
//        self.redPanda.center = self.lastLocation
        self.save.hidden = false
        self.view.bringSubviewToFront(save)
        self.openPreview.hidden = true
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                self.imageToSave = (UIImage(data: imageData))!
            }
        
        }
//        self.lastLocation = self.redPanda.center
        self.picture.image = self.imageToSave
        cameraSession.stopRunning()
    }
//    var lastLocation = CGPoint()
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if let touch = touches.first {
//            self.lastLocation = touch.locationInView(self.view)
//        }
//    }
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if let touch = touches.first {
//            let location = touch.locationInView(self.view)
//            self.redPanda.center = CGPoint(x: (location.x - self.lastLocation.x) + self.redPanda.center.x, y: (location.y - self.lastLocation.y) + self.redPanda.center.y)
//            lastLocation = touch.locationInView(self.view)
//        }
//    }
    

    //     Saves the camera's output
        @IBAction func savePicture(sender: AnyObject) {
//            self.redPanda.center = self.lastLocation
            self.picture.image = self.imageToSave
            let layer = UIApplication.sharedApplication().keyWindow!.layer
            self.save.hidden = true
            self.cancel.hidden = true
            let scale = UIScreen.mainScreen().scale
            
            UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
            
            layer.renderInContext(UIGraphicsGetCurrentContext()!)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            //Save it to the camera roll
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//            let alertView = UIAlertController(title: "Yay!", message: "Picture Saved To Camera Roll", preferredStyle: .Alert)
//            self.save.hidden = false
            self.cancel.hidden = false
            viewDidLoad()
            self.openPreview.hidden = false
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraSession()
        view.layer.addSublayer(previewLayer)
        cameraSession.startRunning()
        self.view.bringSubviewToFront(redPanda)
        //        self.view.bringSubviewToFront(takePicture)
        self.save.hidden = true
        self.view.bringSubviewToFront(openPreview)
        self.view.bringSubviewToFront(cancel)
//        self.lastLocation = self.redPanda.center
        
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
        self.preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
        self.preview.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.preview.position = CGPoint(x: CGRectGetMidX(self.view.bounds), y: CGRectGetMidY(self.view.bounds))
        self.preview.videoGravity = AVLayerVideoGravityResize
        
        let redPandaLayer = CALayer(layer: self.redPanda)
        
        self.preview.addSublayer(redPandaLayer)
        self.preview.insertSublayer(redPandaLayer, above: self.preview)
        
        return self.preview
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
    //    func getImageSize(image : UIImage) -> CGSize {
    //        var imagex = image.size
    //        
    //    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
