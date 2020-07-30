//
//  imageSelected_Viewcontroller.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/6/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class imageSelected_Viewcontroller: UIViewController {

    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var backGroundButton: UIView!
    var imageSave : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGroundButton.layer.cornerRadius =  backGroundButton.frame.size.height/2
        imagePhoto.image = imageSave
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             super.prepare(for: segue, sender: sender)
         if (segue.identifier == "CropPhoto") {
            let vcLogin = segue.destination as? AdjustandCropViewController
            vcLogin?.modalPresentationStyle = .fullScreen
            vcLogin?.imageAdjust = imageSave
            vcLogin?.imgSelected = true
            }
         }


    @IBAction func selectPhoto(_ sender: Any) {
        self.performSegue(withIdentifier: "CropPhoto", sender: nil)
    }
    
    @IBAction func retakePhoto(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
