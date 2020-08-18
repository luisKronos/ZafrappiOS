//
//  changePicture_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/6/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class ChangePictureViewController: UIViewController {
    
    private enum Constants {
        enum Segue {
            static let chooseImageLibrary = "chooseImageFromLybrary"
            static let initiateCamera = "InitCamera"
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var backgroundView: UIView!
    
    // MARK: - Private Properties
    
    private var panGesture = UITapGestureRecognizer()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - IBActions
    
    @IBAction func selectImageAction(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segue.chooseImageLibrary, sender: nil)
    }
    
    // MARK: - Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == Constants.Segue.chooseImageLibrary, let viewController = segue.destination as? AdjustandCropViewController {
            viewController.modalPresentationStyle = .fullScreen
            viewController.isPhotoLibraryShown = true
        }
    }
}

// MARK: - Private Methods

private extension ChangePictureViewController {
    
    // MARK: - Configure Methods
    
    func configureView() {
        backgroundView.layer.cornerRadius = backgroundView.frame.size.height / 2
        backgroundView.layer.borderColor = UIColor.white.cgColor
        backgroundView.layer.borderWidth = 2
        backgroundView.clipsToBounds = true
    }
    
    func configureGestureRecognizer() {
        panGesture = UITapGestureRecognizer(target: self, action: #selector(selectImageAction(_:)))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Gesture Methods
    
    @objc func selectPhoto(_ sender: UIPanGestureRecognizer) {
        performSegue(withIdentifier: Constants.Segue.initiateCamera, sender: nil)
    }
}
