//
//  AdjustandCropViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 27/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import AVFoundation
import  MobileCoreServices
import Photos

class AdjustandCropViewController: UIViewController {

    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var scrollImage: UIScrollView!{
        didSet {
               scrollImage.delegate = self
               scrollImage.minimumZoomScale = 1
               scrollImage.maximumZoomScale = 2
           }
    }
    
    @IBOutlet weak var imageGrid: UIImageView!
    var imageAdjust : UIImage?
    var imagePick = UIImage ()
    var bShowPhotoLibrary = false
    var imgToSend : UIImage?
    var imgSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if bShowPhotoLibrary {
           photoLibrary()
        }else {
           image.image = imageAdjust
        }
       
        viewBackGround.layer.cornerRadius = viewBackGround.frame.size.height/2
    }
    func photoLibrary()
         {
             if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                 let myPickerController = UIImagePickerController()
                 myPickerController.delegate = self
                 myPickerController.sourceType = .photoLibrary
                 self.present(myPickerController, animated: true, completion: nil)
             }
         }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         super.prepare(for: segue, sender: sender)
     if (segue.identifier == "cropImage") {
           let vcLogin = segue.destination as? Cropimage_ViewController
             vcLogin?.modalPresentationStyle = .fullScreen
             vcLogin?.imageService = imgToSend
      }
    }
    
    @IBAction func btnCorrect(_ sender: Any) {
        imgToSend = scrollImage.screenshot()
        if imgSelected {
          performSegue(withIdentifier: "cropImage", sender: nil)
        }else  {
            self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Para continuar debes seleccionar una foto", actionTitle:"Aceptar", actionHandler: {(_) in
                    self.photoLibrary()
            }),animated: true)
        }
       
    }
   
    
    @IBAction func btnCancel(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - UIScrollViewDelegate
extension AdjustandCropViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return image
    }
}
extension AdjustandCropViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          var newImage: UIImage
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
         imagePick = newImage
         image.image = imagePick
         imgSelected = true
         dismiss(animated: true)
    }
}
