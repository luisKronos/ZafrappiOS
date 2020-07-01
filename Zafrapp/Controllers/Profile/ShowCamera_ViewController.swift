//
//  ShowCamera_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/6/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import AVFoundation

class ShowCamera_ViewController: UIViewController, AVCapturePhotoCaptureDelegate{
    
    @IBOutlet weak var viewCamera: UIView!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
     var currentDirection: CameraDirection = .front
    var imageSend : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     checkPermission()
    }
    
    func checkPermission () {
    let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
       switch (status)
       {
       case .authorized:
        self.showCameraInView()

       case .notDetermined:
           AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
               if (granted)
               {
                self.showCameraInView()
               }
               else
               {
                   self.camDenied()
               }
           }

       case .denied:
           self.camDenied()
       case .restricted:
           return
       @unknown default:
         return
        }
    }
    
    func camDenied()
    {
        DispatchQueue.main.async
            {
                var alertText = ""
                var alertButton = ""
                var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)

                if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!)
                {
                    alertText = "Necesitamos que actives los permisos de la cámara para usarla."
                    alertButton = "Ir a configuración"

                    goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    })
                }

                let alert = UIAlertController(title: "Cambiar permisos", message: alertText, preferredStyle: .alert)
                alert.addAction(goAction)
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showCameraInView () {
     captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        var camera : AVCaptureDevice?
        
        if currentDirection == .front {
            if let frontCamera = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.front){
                camera = frontCamera
            }
        }else {
            if let backCamera = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.back) {
               camera = backCamera
            }
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera!)
              stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
            DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
                      self.captureSession.startRunning()
                      //Step 13
                  }
                   DispatchQueue.main.async {
                       self.videoPreviewLayer.frame = self.viewCamera.bounds
                   }
            
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
          
          guard let imageData = photo.fileDataRepresentation()
              else { return }
          
          let image = UIImage(data: imageData)
         imageSend = image ?? UIImage()
          //previewPhoto()
        self.performSegue(withIdentifier: "confirmPhoto", sender: nil)
      }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             super.prepare(for: segue, sender: sender)
         if (segue.identifier == "confirmPhoto") {
               let vcLogin = segue.destination as? imageSelected_Viewcontroller
                 vcLogin?.modalPresentationStyle = .fullScreen
            vcLogin?.imageSave = imageSend
                 }
         }
    
    func previewPhoto() {
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "previewVC") as? imageSelected_Viewcontroller
           vc?.modalPresentationStyle = .fullScreen
        vc?.imageSave = imageSend
           self.present(vc ?? EditProfile_ViewController(), animated: true, completion: nil)
       }
    
    func setupLivePreview() {
           videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
           videoPreviewLayer.videoGravity = .resizeAspect
           videoPreviewLayer.connection?.videoOrientation = .portrait
           viewCamera.layer.addSublayer(videoPreviewLayer)
       }
       
    
    @IBAction func takePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                     stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func switchcamera(_ sender: Any) {
      if (currentDirection == .front) {
            currentDirection = .back
        } else {
            currentDirection = .front
        }
        showCameraInView ()
    }
}
