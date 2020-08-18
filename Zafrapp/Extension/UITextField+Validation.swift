//
//  ExtTextField.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 4/28/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    static func validateAll(textFields: [UITextField]) -> Bool {
        // Check each field for nil and not empty.
        for field in textFields {
            // Remove space and new lines while unwrapping.
            guard let fieldText = field.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                return false
            }
            // Are there no other charaters?
            if (fieldText.isEmpty) {
                return false
            }
            
        }
        // All fields passed.
        return true
    }
    
    //A function that validates the email address...
    func validateEmail(field: UITextField) -> String? {
        guard let trimmedText = field.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return nil
        }
        
        
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return nil
        }
        
        let range = NSMakeRange(0, NSString(string: trimmedText).length)
        let allMatches = dataDetector.matches(in: trimmedText,
                                              options: [],
                                              range: range)
        
        if allMatches.count == 1,
            allMatches.first?.url?.absoluteString.contains("mailto:") == true
        {
            return trimmedText
        }
        return nil
    }
    
    func validateUserName(field: UITextField) -> String? {
        
        guard let text:String = field.text else {
            return nil
        }
        
        /* 3 to 12 characters, no numbers or special characters */
        let RegEx = "^[^\\d!@#£$%^&*<>()/\\\\~\\[\\]\\{\\}\\?\\_\\.\\`\\'\\,\\:\\;|\"+=-]+$"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        let isValid = Test.evaluate(with: text)
        
        if (isValid) {
            return text
        }
        
        return nil
    }
    
    /*6 to 16 Characters */
    func validatePassword(field: UITextField) -> String? {
        guard let text:String = field.text else {
            return nil
        }
        /*6-16 charaters, and at least one number*/
        let RegEx = "^(?=.*\\d)(.+){6,16}$"
        let Test = NSPredicate(format:"SELF MATCHES%@", RegEx)
        let isValid = Test.evaluate(with: text)
        
        if (isValid) {
            return text
        }
        
        return nil
        
    }
    
    func setUnderLine() {
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor(named: "GreyZafrapp")?.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width - 10, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
