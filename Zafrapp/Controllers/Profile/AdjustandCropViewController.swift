//
//  AdjustandCropViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 27/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos

class AdjustandCropViewController: UIViewController {
    
    private enum Constants {
        enum Segue {
            static let cropImage = "cropImage"
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var gridImageView: UIImageView!
    @IBOutlet private var imageScrollView: UIScrollView! {
        didSet {
            imageScrollView.delegate = self
            imageScrollView.minimumZoomScale = 1
            imageScrollView.maximumZoomScale = 2
        }
    }
    @IBOutlet private var cropView: UIView!
    
    // MARK: - Private Properties
    
    private var imgToSend: UIImage?
    private var imagePick = UIImage()
    
    // MARK: - Public Properties
    
    var adjustedImage: UIImage?
    var isPhotoLibraryShown = false
    var isImageSelected = false
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isPhotoLibraryShown {
            photoLibrary()
        } else {
            imageView.image = adjustedImage
        }
        
        backgroundView.layer.cornerRadius = backgroundView.frame.size.height / 2
    }
    
    // MARK: - IBActions
    
    @IBAction func correctAction(_ sender: Any) {
        // Resize image because trimming white space makes uimage has a big size
        imgToSend = imageCropped?.resize(scaledToWidth: gridImageView.frame.width)
        
        if isImageSelected {
            performSegue(withIdentifier: "cropImage", sender: nil)
        } else  {
            present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: "Para continuar debes seleccionar una foto", actionTitle:AppConstants.String.accept, actionHandler: {(_) in
                self.photoLibrary()
            }),animated: true)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == Constants.Segue.cropImage, let viewController = segue.destination as? CropImageViewController {
            viewController.modalPresentationStyle = .fullScreen
            viewController.imageService = imgToSend
        }
    }
    
}

// MARK: - Private Methods

private extension AdjustandCropViewController {
    
    func photoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        present(myPickerController, animated: true, completion: nil)
    }
    
}

// MARK: - UIScrollViewDelegate

extension AdjustandCropViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

// MARK: - UIImagePickerControllerDelegate

extension AdjustandCropViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var newImage: UIImage
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        imagePick = newImage
        imageView.image = imagePick
        isImageSelected = true
        dismiss(animated: true)
    }
}

private extension AdjustandCropViewController {
    var imageCropped: UIImage? {
        // To avoid getting grid on new image
        gridImageView.isHidden = true
        // To get a white background and use trim methods to remove what is not necessary
        imageScrollView.backgroundColor = .white
        
        UIGraphicsBeginImageContextWithOptions(gridImageView.frame.size, true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.translateBy(x: -gridImageView.frame.origin.x, y: -gridImageView.frame.origin.y)
        cropView.layer.render(in: context)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image = image?.trim()

        // Restore previuos state
        imageScrollView.backgroundColor = .black
        gridImageView.isHidden = false
        
        return image
    }
}
