//
//  CropImageViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/6/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import os

class CropImageViewController: ZPMasterViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let overlayMargin: CGFloat = 40.0
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var backgroundButtonView: UIView!
    @IBOutlet private var screenshotView: UIView!
    
    // MARK: - Private Properties
    
    private var panGesture = UIPanGestureRecognizer()
    private var indicator = UIActivityIndicatorView()
    private var informationProfile = UpdateProfileImage()
    private var overlayView: UIView?
    
    // MARK: - Public Properties
    
    var imageService: UIImage?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageService
        backgroundButtonView.layer.cornerRadius = backgroundButtonView.frame.size.height / 2
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // configure overlay here, to get the correct frame
        configureOverlay()
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        removeImage(at: "ProfilePicture\(InformationClasify.sharedInstance.data?.messageResponse?.userId ?? "").jpg")
        informationProfile.email = InformationClasify.sharedInstance.data?.messageResponse?.email
        informationProfile.profileImage = imageCropped
        executeService(data: informationProfile)
    }
    
}

// MARK: - Private Methods

private extension CropImageViewController {
    
    // MARK: - Computed Properties
    
    var imageCropped: UIImage? {
        // To avoid getting overlay on new image
        overlayView?.isHidden = true
    
        UIGraphicsBeginImageContextWithOptions(overlayCircleFrame.size, true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.translateBy(x: -overlayCircleFrame.origin.x, y: -overlayCircleFrame.origin.y)
        screenshotView.layer.render(in: context)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image = image?.trim()

        // Restore previuos state
        overlayView?.isHidden = false
        
        return image
    }
    
    var overlayCircleFrame: CGRect {
        let size = screenshotView.frame.width - Constants.overlayMargin * 2
        return CGRect(x: Constants.overlayMargin , y: screenshotView.bounds.midY - size / 2, width: size, height: size)
    }
    
    // MARK: - Configure methods
    
    func configureOverlay() {
        if let overlayView = overlayView {
            overlayView.removeFromSuperview()
            panGesture.removeTarget(self, action: nil)
        }
        
        overlayView = createOverlay(frame: CGRect(x: 0.0, y: 0.0, width: screenshotView.frame.width, height: screenshotView.frame.height),
                                    xOffset: screenshotView.frame.midX,
                                    yOffset: screenshotView.frame.midY,
                                    radius: screenshotView.frame.width / 2 - Constants.overlayMargin)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        overlayView?.isUserInteractionEnabled = true
        overlayView?.addGestureRecognizer(panGesture)
        
        if let overlayView = overlayView {
            screenshotView.addSubview(overlayView)
        }
    }
    
    @objc func draggedView(_ sender: UIPanGestureRecognizer){
        view.bringSubviewToFront(imageView)
        let translation = sender.translation(in: screenshotView)
        let overlayFrame: CGRect = self.overlayCircleFrame
        let oldCenter = imageView.center
        let center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)

        // set new center to update frame
        imageView.center = center
        
        let newImageViewFrame = imageView.frame
        
        // validates image view does not go out of overlay frame
        // if so, set old center
        if newImageViewFrame.maxX < overlayFrame.maxX ||
            newImageViewFrame.maxY < overlayFrame.maxY ||
            newImageViewFrame.minX > overlayFrame.minX ||
            newImageViewFrame.minY > overlayFrame.minY {
            imageView.center = oldCenter
        }
        
        sender.setTranslation(.zero, in: view)
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
                } else {
                    self.saveImage(imageFinal: data?.profileImage ?? UIImage())
                    self.present(ZPAlertGeneric.oneOption(title: "Foto actualizada", message: respService?.message, actionTitle: AppConstants.String.accept, actionHandler: {(_) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }),animated: true)
                }
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.accept),animated: true)
            } else {
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
                os_log("file saved")
            } catch {
                os_log("error saving file: %s", error.localizedDescription)
            }
        }
    }
    
    func adjustImage() -> UIImage {
        let image = screenshotView.screenshot()
        let size = screenshotView.frame.width - Constants.overlayMargin * 2
        let rect: CGRect = CGRect(x: -Constants.overlayMargin , y: screenshotView.bounds.midY - size / 2, width: size, height: size)
       
        return  image.cropped(rect: rect) ?? UIImage()
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
    
    // MARK: - Overlay View
    /// This overlay allow us to get a rect of circle position, to validate image view does not go beyond it
    
    func createOverlay(frame: CGRect, xOffset: CGFloat, yOffset: CGFloat, radius: CGFloat) -> UIView {
        let overlayView = UIView(frame: frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: frame.midX, y: frame.midY),
                    radius: radius,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
     
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillRule = .evenOdd
        
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true

        return overlayView
    }
}

