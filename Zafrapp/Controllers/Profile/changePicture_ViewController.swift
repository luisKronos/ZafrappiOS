//
//  changePicture_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/6/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class changePicture_ViewController: UIViewController {
    
    @IBOutlet weak var viewBackground: UIView!
    var panGesture       = UITapGestureRecognizer()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        roundView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panGesture = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        viewBackground.isUserInteractionEnabled = true
        viewBackground.addGestureRecognizer(panGesture)
    }
    @objc func selectPhoto(_ sender:UIPanGestureRecognizer){
    self.performSegue(withIdentifier: "InitCamera", sender: nil)
    }
    
    func roundView () {
        self.viewBackground.layer.cornerRadius = viewBackground.frame.size.height / 2
      self.viewBackground.layer.borderColor = UIColor.white.cgColor
        self.viewBackground.layer.borderWidth = 2
        self.viewBackground.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             super.prepare(for: segue, sender: sender)
         if (segue.identifier == "chooseImageFromLybrary") {
               let vcLogin = segue.destination as? AdjustandCropViewController
                 vcLogin?.modalPresentationStyle = .fullScreen
                 vcLogin?.bShowPhotoLibrary = true
                 }
         }
    
    @IBAction func btnSelectImage(_ sender: Any) {
         self.performSegue(withIdentifier: "chooseImageFromLybrary", sender: nil)
    }
    

    @IBAction func btnContinuar(_ sender: Any) {
       
    }
}
