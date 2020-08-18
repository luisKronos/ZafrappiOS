//
//  ExtensionViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 4/29/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public func hideKeyboardWhenTapped() {
          let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                   action: #selector(dismissKeyboard))
          tap.cancelsTouchesInView = false
          view.addGestureRecognizer(tap)
      }
    
    @objc public func dismissKeyboard() {
          view.endEditing(true)
      }
      
}
