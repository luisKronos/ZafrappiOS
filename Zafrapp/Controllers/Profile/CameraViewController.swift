//
//  CameraViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/6/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    private enum Constants {
        enum Segue {
            static let confirmPhoto = "confirmPhoto"
        }
    }
    // MARK: - IBOutlets
    
    @IBOutlet private var viewCamera: UIView!
    
    // MARK: - Private Properties
    
    private var captureSession: AVCaptureSession!
    private var stillImageOutput: AVCapturePhotoOutput!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var currentDirection: CameraDirection = .front
    private var imageSent: UIImage?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
    }
    
    // MARK: - IBActions
    
    @IBAction func takePhotoAction(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func switchCameraAction(_ sender: Any) {
        currentDirection = currentDirection == .front ? .back : .front
        showCameraInView()
    }
    
    // MARK: - Segue Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == Constants.Segue.confirmPhoto, let viewController = segue.destination as? ImageViewcontroller {
            viewController.modalPresentationStyle = .fullScreen
            viewController.imageSaved = imageSent
        }
    }
}

// MARK: - Private Methods

private extension CameraViewController {
    
    func previewPhoto() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "previewVC") as? ImageViewcontroller
        vc?.modalPresentationStyle = .fullScreen
        vc?.imageSaved = imageSent
        present(vc ?? EditProfileViewController(), animated: true, completion: nil)
    }
    
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        viewCamera.layer.addSublayer(videoPreviewLayer)
    }
    
    func showCameraInView() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        var camera: AVCaptureDevice?
        
        if currentDirection == .front {
            if let frontCamera = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.front){
                camera = frontCamera
            }
        } else {
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
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.videoPreviewLayer.frame = self.viewCamera.bounds
            }
            
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    func checkPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch (status)
        {
        case .authorized:
            self.showCameraInView()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                if granted {
                    self.showCameraInView()
                } else {
                    self.showAlertPermissionRequired()
                }
            }
        case .denied:
            self.showAlertPermissionRequired()
        case .restricted:
            return
        @unknown default:
            return
        }
    }
    
    func showAlertPermissionRequired() {
        DispatchQueue.main.async {
            var alertText = ""
            var alertButton = ""
            var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)
            
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
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
    
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        let image = UIImage(data: imageData)
        imageSent = image ?? UIImage()
        
        performSegue(withIdentifier: Constants.Segue.confirmPhoto, sender: nil)
    }
    
}
