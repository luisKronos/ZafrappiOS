//
//  ExtSwitch.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 11/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation
import UIKit

extension UISwitch {

    func set(width: CGFloat, height: CGFloat) {

        let standardHeight: CGFloat = 20
        let standardWidth: CGFloat = 20

        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
   
}
