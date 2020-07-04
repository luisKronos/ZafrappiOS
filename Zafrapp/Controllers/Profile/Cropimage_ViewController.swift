//
//  Cropimage_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/6/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class Cropimage_ViewController: ZPMasterViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageCrop: UIImageView!
    @IBOutlet weak var vBackgroundButton: UIView!
    var imageService : UIImage?
    var panGesture       = UIPanGestureRecognizer()
    var indicator = UIActivityIndicatorView()
    var informationProfile = updateProfileImage ()
    @IBOutlet weak var vScreenShoot: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = imageService
        vBackgroundButton.layer.cornerRadius = vBackgroundButton.frame.size.height / 2
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(panGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageCrop.isHidden = false
    }
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
           self.view.bringSubviewToFront(image)
           let translation = sender.translation(in: self.view)
           image.center = CGPoint(x: image.center.x + translation.x, y: image.center.y + translation.y)
           sender.setTranslation(CGPoint.zero, in: self.view)
       }
    
func executeService (DataUser : updateProfileImage?) {
         self.activityIndicatorBegin()
       let ws = Updateimage_WS ()
        ws.upDateImage(Data: DataUser!) {[weak self] (respService, error) in
             guard let self = self else { return }
                self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.strStatus == "BAD" {
                        self.present(ZPAlertGeneric.OneOption(title : "Error", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                }else {
                        self.saveImage()
                        self.present(ZPAlertGeneric.OneOption(title : "Foto actualizada", message: respService?.strMessage, actionTitle: "Aceptar", actionHandler: {(_) in
                            self.navigationController?.popToRootViewController(animated: true)
                        }),animated: true)
                }
            } else if (error! as NSError).code == -1009 {
                self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar"),animated: true)
            }else {
                self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
            }
        }
    }
    
    func saveImage () {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "ProfilePicture\(informationClasify.sharedInstance.data?.arrMessage?.strId_user ?? "").jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if let data = image.image?.jpegData(compressionQuality:  1.0),
          !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    func removeImageLocalPath(localPathName:String) {
               let filemanager = FileManager.default
               let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
               let destinationPath = documentsPath.appendingPathComponent(localPathName)
    do {
           try filemanager.removeItem(atPath: destinationPath)
           print("Local path removed successfully")
       } catch let error as NSError {
           print("------Error",error.debugDescription)
       }
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
    
     @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
     }
    
    @IBAction func acceptAction(_ sender: Any) {
        self.imageCrop.isHidden = true
        let imageAdjust = adjustImage(View: vScreenShoot)
    
        removeImageLocalPath(localPathName: "ProfilePicture\(informationClasify.sharedInstance.data?.arrMessage?.strId_user ?? "").jpg")
        informationProfile.strEmail = informationClasify.sharedInstance.data?.arrMessage?.strEmail
        informationProfile.ImgProfile = imageAdjust
        self.executeService(DataUser: informationProfile)
        }
    
    func adjustImage (View : UIView) -> UIImage{
       let imageCut = View.screenshot()
        let rect: CGRect = CGRect(x: -70, y: 0, width: 200, height: 200)
        
        return  imageCut.cropped(rect: rect) ?? UIImage()
    }
}
