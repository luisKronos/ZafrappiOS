//
//  CropImageViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/6/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class CropImageViewController: ZPMasterViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var cropImageView: UIImageView!
    @IBOutlet private var backgroundButtonView: UIView!
    @IBOutlet private var screenshotView: UIView!
    
    // MARK: - Private Properties
    
    private var panGesture = UIPanGestureRecognizer()
    private var indicator = UIActivityIndicatorView()
    private var informationProfile = UpdateProfileImage()
    
    // MARK: - Public Properties
    
    var imageService: UIImage?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageService
        backgroundButtonView.layer.cornerRadius = backgroundButtonView.frame.size.height / 2
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(panGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cropImageView.isHidden = false
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        self.cropImageView.isHidden = true
        let imageAdjust = adjustImage(View: screenshotView)
        
        removeImage(at: "ProfilePicture\(InformationClasify.sharedInstance.data?.messageResponse?.userId ?? "").jpg")
        informationProfile.email = InformationClasify.sharedInstance.data?.messageResponse?.email
        informationProfile.profileImage = imageAdjust
        executeService(data: informationProfile)
    }
    
}

// MARK: - Private Methods

private extension CropImageViewController {
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.view.bringSubviewToFront(imageView)
        let translation = sender.translation(in: self.view)
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func executeService(data: UpdateProfileImage?) {
        activityIndicatorBegin()
        let service = UpdateimageService()
        
        service.upDateImage(data: data!) {[weak self] (respService, error) in
            guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.status == AppConstants.ErrorCode.bad {
                    self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: respService?.message, actionTitle: AppConstants.String.accept),animated: true)
                    self.cropImageView.isHidden = false
                } else {
                    self.saveImage(imageFinal: data?.profileImage ?? UIImage())
                    self.present(ZPAlertGeneric.oneOption(title: "Foto actualizada", message: respService?.message, actionTitle: AppConstants.String.accept, actionHandler: {(_) in
                        self.cropImageView.isHidden = false
                        self.navigationController?.popToRootViewController(animated: true)
                    }),animated: true)
                }
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection {
                self.cropImageView.isHidden = false
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.accept),animated: true)
            } else {
                self.cropImageView.isHidden = false
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
            }
        }
    }
    
    func saveImage(imageFinal: UIImage) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "ProfilePicture\(InformationClasify.sharedInstance.data?.messageResponse?.userId ?? "").jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if let data = imageFinal.jpegData(compressionQuality:  1.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    func adjustImage(View: UIView) -> UIImage{
        let imageCut = View.screenshot()
        let rect: CGRect = CGRect(x: -40, y: 30, width: 300, height: 300)
        
        return  imageCut.cropped(rect: rect) ?? UIImage()
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func removeImage(at path: String) {
        let filemanager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
        let destinationPath = documentsPath.appendingPathComponent(path)
        do {
            try filemanager.removeItem(atPath: destinationPath)
            print("Local path removed successfully")
        } catch let error as NSError {
            print("------Error",error.debugDescription)
        }
    }
    
}
