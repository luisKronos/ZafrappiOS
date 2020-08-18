//
//  ZpTextField.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 5/3/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation
import UIKit

private var __maxLengths = [UITextField: Int]()
@IBDesignable
public class ZPDesignableUITextField: UITextField {
    
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var imageRight: Bool = false{
        didSet{
            if imageRight {
                rightViewMode = UITextField.ViewMode.always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                let image = UIImage(named: "arrowDown")
                imageView.image = image
                rightView = imageView
            }
        }
    }
    
    
    @IBInspectable var leftSpace: Int = 0 {
        didSet {
            setLeftPaddingPoints(CGFloat(leftSpace))
        }
    }
    
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var underlineTxtfield: CGFloat = 0{
        didSet{
            setUnderLine()
            attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder!: "", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
    }
    
    @IBInspectable var color: UIColor = .lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
        
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder!: "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}
