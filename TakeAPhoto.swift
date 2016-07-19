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
    
//     Saves the camera's output
    @IBAction func savePicture(sender: AnyObject) {
//        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
//            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
//                (imageDataSampleBuffer, error) -> Void in
//                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
//                let imageToSave = (UIImage(data: imageData))
//                
//                UIImageWriteToSavedPhotosAlbum(imageToSave!, nil, nil, nil)
//
//            }
//        }
//        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
//            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
//                (imageDataSampleBuffer, error) -> Void in
//                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
//                self.imageToSave = (UIImage(data: imageData))!
//            }
//        }
//        self.picture.image = self.imageToSave
//        
//        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("hi")
//        var imageToSave = UIImage()
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                self.imageToSave = (UIImage(data: imageData))!
            }
        }
        self.picture.image = self.imageToSave
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
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
        self.save.hidden = false
        self.cancel.hidden = false
    }
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
    
//        let path = NSBundle.mainBundle().pathForResource("redpanda3d", ofType: "png")
//        let redPandaImage = UIImage(contentsOfFile: path!)!
//
        let redPandaLayer = CALayer(layer: self.redPanda)
        
        self.preview.addSublayer(redPandaLayer)
        self.preview.insertSublayer(redPandaLayer, above: self.preview)
//        redPandaLayer.bounds = CGRect(x: 50, y: 50, width: 91, height: 86)
//        redPandaLayer.position = CGPoint(x: CGRectGetMidX(redPandaLayer.bounds), y: CGRectGetMidY(redPandaLayer.bounds))
//        
//        let redPandaAnimation = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: redPandaLayer, inLayer: self.preview)
//        self.view.layer.insertSublayer(preview, atIndex: 0)
        
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
