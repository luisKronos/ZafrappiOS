//
//  ExtensionViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 4/29/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

extension UIViewController {
    func configureKeyboard() {
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
}
