//
//  ImageViewcontroller.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/6/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class ImageViewcontroller: UIViewController {
    
    private enum Constants {
        enum Segue {
            static let cropPhoto = "CropPhoto"
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var imagePhoto: UIImageView!
    @IBOutlet private var backGroundButton: UIView!
    
    // MARK: - Public Properties
    
    var imageSaved: UIImage?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGroundButton.layer.cornerRadius =  backGroundButton.frame.size.height/2
        imagePhoto.image = imageSaved
    }
    
    // MARK: - IBActions
    
    @IBAction func selectPhotoAction(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segue.cropPhoto, sender: nil)
    }
    
    @IBAction func retakePhotoAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == Constants.Segue.cropPhoto, let viewController = segue.destination as? AdjustandCropViewController {
            viewController.modalPresentationStyle = .fullScreen
            viewController.adjustedImage = imageSaved
            viewController.isImageSelected = true
        }
    }
    
}
