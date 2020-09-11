//
//  ZpImage.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 5/3/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class ZPImageView: UIImageView {
    var imageLogo = UIImage(named: "Logo")
    
    @IBInspectable public var typeImage: String? {
        didSet {
            if typeImage == "Logo" {
                //self.image = imageLogo
                self.layer.cornerRadius = 60
                self.backgroundColor = .white
            }
        }
    }
}

class getImageFromDocument {
    func fileInDocumentsDirectory(filename: String) -> UIImage {
        var imageReturn: UIImage?
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        if let dirPath = paths.first {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("\(filename).jpg")
            let image    = UIImage(contentsOfFile: imageURL.path) ?? UIImage()
            // Do whatever you want with the image
            imageReturn = image
        }
        return imageReturn ?? UIImage()
    }
}
