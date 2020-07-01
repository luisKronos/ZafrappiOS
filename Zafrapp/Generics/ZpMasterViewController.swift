//
//  ZPMasterViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 4/29/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation
import UIKit

class ZPMasterViewController : UIViewController {
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let greyView = UIView()
    
    override func viewDidLoad() {
          super.viewDidLoad()
          hideKeyboardWhenTapped()
      }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func activityIndicatorBegin() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 50,height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        greyView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        greyView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        greyView.alpha = 0.5
        self.view.addSubview(greyView)
    }
    func activityIndicatorEnd() {
           self.activityIndicator.stopAnimating()
           self.view.isUserInteractionEnabled = true
           self.greyView.removeFromSuperview()
       }
}
