//
//  ExitChangeEmailViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/5/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class ExitChangeEmailViewController: UIViewController {

    // MARK: - Public Properties
    
    var delegate: ReturnRootDelegate?

    // MARK: - IBActions
    
    @IBAction func goAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.returnLogin()
    }
    
}
