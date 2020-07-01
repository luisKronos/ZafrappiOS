//
//  ZpLabel.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 12/05/20.
//  Copyright © 2020 Mayte Dominguez. All rights reserved.
//

import Foundation
import UIKit


public class ZpLabel : UILabel {
    @IBInspectable var showUnderline: Int = 0 {
        didSet {
            if showUnderline == 1 {
                setUnderLine()
            }
        }
    }

}
