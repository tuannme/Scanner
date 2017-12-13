//
//  DUCameraViewController.swift
//  Scanner Plus
//
//  Created by TuanNM on 12/13/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia
import CoreVideo
import QuartzCore
import CoreImage
import ImageIO
import MobileCoreServices
import GLKit

struct Quadrangle{
    var topLeft:CGPoint?
    var topRight:CGPoint?
    var bottomRight:CGPoint?
    var bottomLeft:CGPoint?
}

class DUCameraViewController: UIViewController {

    enum CameraType{
        case BlackAndWhite
        case Normal
    }

    var isTorchEnabled = false
    var isBorderDetectionEnabled = false

    private var cameraType:CameraType = .Normal
    private var captureSession:AVCaptureSession = AVCaptureSession()
    private var captureDevice:AVCaptureDevice?
    
    private var context:EAGLContext = EAGLContext(api: .openGLES2)!
    private var stillImageOutput:AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    
    private let glkView:GLKView = GLKView(frame: UIScreen.main.bounds)
    private var coreImageContext:CIContext!
    private var ciContext = CIContext(options: [kCIContextWorkingColorSpace:NSNull()])
    
    private let captureQueue = DispatchQueue(label: "com.scan.AVCameraCaptureQueue")
    
    private var intrinsicContentSize:CGSize = CGSize.zero
    private var borderDetectTimeKeeper:Timer?
    
    private var forceStop = false
    private var isStopped = false
    private var borderDetectFrame = false
    private var isCapturing = false
    private var imageDedectionConfidence:CGFloat = 0
    private let bytesPerPixel = 8
    
    private var detector:CIDetector = CIDetector(ofType: CIDetectorTypeRectangle, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveForeGround), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @objc fileprivate func moveBackground(){
        forceStop = true
    }

    @objc fileprivate func moveForeGround(){
        forceStop = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("DUCameraViewController didReceiveMemoryWarning")
    }
    
    fileprivate func setUpGLKView(){
        glkView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        glkView.translatesAutoresizingMaskIntoConstraints = true
        glkView.context = context
        glkView.contentScaleFactor = 1
        glkView.drawableDepthFormat = .format24
        view.insertSubview(glkView, at: 0)
    }
    
    fileprivate func hideGLKView(hidden:Bool){
        UIView.animate(withDuration: 0.1) {
            self.glkView.alpha = hidden ? 0 : 1
        }
    }
    
    @objc fileprivate func enableBorderDetectFrame(){
        borderDetectFrame = true
    }
    
    fileprivate func filteredImageUsingEnhanceFilterOnImage(image:CIImage) -> CIImage?{
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(image, forKey: kCIInputImageKey)
        filter?.setValue(NSNumber(value: 0.0), forKey: "inputBrightness")
        filter?.setValue(NSNumber(value: 1.14), forKey: "inputContrast")
        filter?.setValue(NSNumber(value: 0.0), forKey: "inputSaturation")
        return filter?.outputImage
    }
    
    fileprivate func filteredImageUsingContrastFilterOnImage(image:CIImage) -> CIImage? {
        let filter = CIFilter(name: "CIColorControls", withInputParameters: [kCIInputImageKey:image,"kCIInputImageKey":1.1])
        return filter?.outputImage
    }
    
    fileprivate func _biggestRectangleInRectangles(rectangles:[CIFeature]) -> CIRectangleFeature?{
        
        if rectangles.count == 0 {return nil}
        var halfPerimiterValue:CGFloat = 0
        if var biggestRectangle = rectangles.first as? CIRectangleFeature{
            for rect in rectangles{
                if let _rect = rect as? CIRectangleFeature{
                    let p1 = _rect.topLeft
                    let p2 = _rect.topRight
                    let width = hypot(p1.x - p2.x, p1.y - p2.y)
                    
                    let p3 = _rect.topLeft
                    let p4 = _rect.bottomLeft
                    let height = hypot(p3.x - p4.x, p3.y - p4.y)
                    
                    let currentHalfPerimiterValue = width + height
                    
                    if  halfPerimiterValue < currentHalfPerimiterValue{
                        halfPerimiterValue = currentHalfPerimiterValue
                        biggestRectangle = _rect
                    }
                }
            }
            return biggestRectangle
        }
        return nil
    }
    
    
    fileprivate func biggestRectangleInRectangles(rectangles:[CIFeature]) -> Quadrangle?{
        guard let rectangleFeature = _biggestRectangleInRectangles(rectangles: rectangles) else{return nil}
        
        let points:[CGPoint] = [rectangleFeature.topLeft,rectangleFeature.topRight,rectangleFeature.bottomLeft,rectangleFeature.bottomRight]
        var min:CGPoint = points[0]
        var max:CGPoint = min
        for point in points{
            min.x = fmin(point.x, min.x)
            min.y = fmin(point.y, min.y)
            max.x = fmin(point.x, max.x)
            max.y = fmin(point.y, max.y)
        }
        
        let center = CGPoint(x: 0.5*(min.x + max.x), y: 0.5*(min.y + max.y))
        
        let sortedPoints = points.sorted {
            (point1, point2) -> Bool in
            return angleFromPoint(point: point1, center: center) > angleFromPoint(point: point2, center: center)
        }
        
        let rectangle:Quadrangle = Quadrangle(topLeft: sortedPoints[3],
                                                        topRight: sortedPoints[2],
                                                        bottomRight: sortedPoints[1],
                                                        bottomLeft: sortedPoints[0])
        
        return rectangle
        
    }

    fileprivate func angleFromPoint(point:CGPoint,center:CGPoint) -> Float{
        let theta:Float = atan2f(Float(point.y - center.y), Float(point.x - center.x))
        let angle = fmodf(Float(Double.pi) - Float(Double.pi/4) + theta, 2*Float(Double.pi))
        return angle
    }

}

extension DUCameraViewController{
    // setup camera
    open func setUpCamera(){
        setUpGLKView()
        coreImageContext = CIContext(cgContext: context as! CGContext, options: [kCIContextWorkingColorSpace:NSNull(),kCIContextUseSoftwareRenderer:false])
        
        guard let device = AVCaptureDevice.devices(for: .video).last else{return}
        captureDevice = device
        
        do{
            //create input
            let deviceInput = try AVCaptureDeviceInput(device: device)
            captureSession.addInput(deviceInput)
        }catch let error{
            print("create input" + error.localizedDescription)
        }
        
        // create ouput
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.alwaysDiscardsLateVideoFrames = true
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]
        dataOutput.setSampleBufferDelegate(self, queue: captureQueue)
        //add configuration
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo
        
        captureSession.addOutput(dataOutput)
        captureSession.addOutput(stillImageOutput)
        
        let connection = dataOutput.connections.first
        connection?.videoOrientation = .portrait
        
        do{
            if device.isFlashActive{
                try device.lockForConfiguration()
                device.flashMode = .off
                device.unlockForConfiguration()
                
                if device.isFocusModeSupported(.autoFocus){
                    try device.lockForConfiguration()
                    device.focusMode = .autoFocus
                    device.unlockForConfiguration()
                }
            }
        }catch let error{
            print(error.localizedDescription)
        }
        
        captureSession.commitConfiguration()
    }
    open func setCameraType(cameraType:CameraType){
        
        let effect = UIBlurEffect(style: .dark)
        let blurredBackgroundView = UIVisualEffectView(effect: effect)
        blurredBackgroundView.frame = view.bounds
        view.insertSubview(blurredBackgroundView, aboveSubview: glkView)
        self.cameraType = cameraType
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            blurredBackgroundView.removeFromSuperview()
        }
    }
    
    open func startCamera(){
        isStopped = false
        captureSession.startRunning()
        borderDetectTimeKeeper = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.enableBorderDetectFrame), userInfo: nil, repeats: true)
        hideGLKView(hidden: false)
    }
    
    open func stopCamera(){
        isStopped = true
        captureSession.stopRunning()
        borderDetectTimeKeeper?.invalidate()
        hideGLKView(hidden: true)
    }
    
    open func setEnableTorch(enableTorch:Bool){
        self.isTorchEnabled = enableTorch
        guard let device = captureDevice else{return}
        do{
            if device.hasTorch && device.hasFlash{
                try device.lockForConfiguration()
                device.torchMode =  enableTorch ? .on : .off
                device.unlockForConfiguration()
            }
        }catch let error{
            print("setEnableTorch" + error.localizedDescription)
        }
    }
    
    open func focusAtPoint(point:CGPoint,completionHandle:()->()){
        
        guard let device = captureDevice else{return}
        
        let frameSize = view.bounds.size
        
        do{
            let pointOfInterest = CGPoint(x: point.y/frameSize.height, y: 1 - point.x/frameSize.width)
            if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.autoFocus){
                try device.lockForConfiguration()
                if device.isFocusModeSupported(.autoFocus){
                    device.focusMode = .autoFocus
                    device.focusPointOfInterest = pointOfInterest
                }
                if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(.autoExpose){
                    device.exposurePointOfInterest = pointOfInterest
                    device.exposureMode = .autoExpose
                    completionHandle()
                }
                device.unlockForConfiguration()
            }
        }catch let error{
            print("focusAtPoint" + error.localizedDescription)
        }
    }
    open func captureImageWith(completionHander:(_ image:UIImage)->()){
        captureQueue.suspend()
        
        var videoConnection:AVCaptureConnection?
        var rectange:Quadrangle?
        
        for connection in stillImageOutput.connections{
            for port in connection.inputPorts{
                if port.mediaType == .video{
                    videoConnection = connection
                    break
                }
            }
            if videoConnection != nil{
                break
            }
        }
        
        if videoConnection == nil {return}
        
        stillImageOutput.captureStillImageAsynchronously(from: videoConnection!) {
            [weak self] (buffer, error) in
            guard let _self = self else{return}
            if error != nil{
                _self.captureQueue.resume()
                return
            }
            guard let buffer = buffer else{return}
            guard let imgData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer) else{return}
            guard var enhancedImage = CIImage(data: imgData, options: [kCIImageColorSpace:NSNull()]) else{return}
            
            if _self.cameraType == .BlackAndWhite{
                if let _enhancedImage = _self.filteredImageUsingEnhanceFilterOnImage(image: enhancedImage){
                    enhancedImage = _enhancedImage
                }
            }else{
                if let _enhancedImage = _self.filteredImageUsingContrastFilterOnImage(image: enhancedImage){
                    enhancedImage = _enhancedImage
                }
            }
            
            if _self.isBorderDetectionEnabled && _self.imageDedectionConfidence > 1{
                rectange = _self.biggestRectangleInRectangles(rectangles: _self.detector.features(in: enhancedImage))
            }
            
            
            let transform = CIFilter(name: "CIAffineTransform")
            transform?.setValue(enhancedImage, forKey: kCIInputImageKey)
            
            let rotation = CGAffineTransform(rotationAngle: CGFloat(-90 * Double.pi/180))
            transform?.setValue(rotation, forKey: "inputTransform")
            
            if let outputImage = transform?.outputImage{
                enhancedImage = outputImage

            }
            
            if enhancedImage.extent.isEmpty {return}
            
            var bounds = enhancedImage.extent.size
            bounds = CGSize(width: floorf(Float(bounds.width/4)) * 4, height: floorf(Float(bounds.height/4)) * 4)
            let extent = CGRect(x: enhancedImage.extent.origin.x, y: enhancedImage.extent.origin.y, width: bounds.width, height: bounds.height)
            
            let rowBytes:uint = bytesPerPixel * bounds.width
            let totalBytes:uint = rowBytes * bounds.height
            let byteBuffer = malloc(totalBytes)
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
        }
        
        
    }
    
}

extension DUCameraViewController:AVCaptureVideoDataOutputSampleBufferDelegate{
    
}

