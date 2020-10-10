//
//  ZPMasterViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 4/29/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation
import UIKit

class ZPMasterViewController: UIViewController {
    
    // MARK: - Properties
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let greyView = UIView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboard()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Activity Indicator Methods
    
    func activityIndicatorBegin() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 50,height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        
        greyView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        greyView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        greyView.alpha = 0.5
        view.addSubview(greyView)
    }
    
    func activityIndicatorEnd() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
        greyView.removeFromSuperview()
    }
}
