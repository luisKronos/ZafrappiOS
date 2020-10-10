//
//  ZafrappTheme.swift
//  Zafrapp
//
//  Created by Ing. Jorge Ivan Estrada Torres on 05/10/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

enum ZafrappTheme {}

// MARK: - Colors
extension ZafrappTheme {
    enum Color {
        static var blue: UIColor {
            UIColor(red: 0.0, green: 159.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0)
        }
        
        static var darkBlue: UIColor {
            UIColor(red: 34.0 / 255, green: 36.0 / 255, blue: 85.0 / 255, alpha: 1.0)
        }
        
        static var grayLight: UIColor {
            UIColor(red: 245.0 / 255, green: 246.0 / 255, blue: 249.0 / 255, alpha: 1.0)
        }
        
        static var greenBackground: UIColor {
            UIColor(red: 27.0 / 255, green: 72.0 / 255, blue: 4.0 / 255, alpha: 0.52)
        }
        
        static var green: UIColor {
            UIColor(red: 59.0 / 255, green: 170.0 / 255, blue: 52.0 / 255, alpha: 1.0)
        }
        
        static var gray: UIColor {
            UIColor(red: 112.0 / 255, green: 112.0 / 255, blue: 112.0 / 255, alpha: 1.0)
        }
        
        static var purple: UIColor {
                UIColor(red: 86.0 / 255, green: 95.0 / 255, blue: 225.0 / 255, alpha: 1.0)
        }
    }
}

extension ZafrappTheme {
    enum Font {
        enum Profile {
            static let emptyMessage = UIFont.preferredFont(forTextStyle: .title2)
            static let instruction = UIFont.preferredFont(forTextStyle: .caption1)
        }
    }
}
