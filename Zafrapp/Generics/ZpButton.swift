//
//  ZPButton.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 4/28/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class ZPDesignableUIButton : UIButton {
    
    public enum Style: Int {
          case login              = 0
          case next               = 1
      }
    
    @IBInspectable public var style: Int = 0 {
        didSet { set(style: Style(rawValue: style) ?? .login) }
    }
    
    private func set(style: Style) {
        switch style {
        case .login:
            self.backgroundColor = #colorLiteral(red: 0, green: 0.6883265376, blue: 0.9128565192, alpha: 1)
            self.layer.cornerRadius = self.frame.size.height / 2
        case .next :
            self.backgroundColor = UIColor.blue
            self.layer.cornerRadius = self.frame.size.height / 2
        }
    }
}
