//
//  AccountSucces_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/5/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

protocol ReturnRootDelegate {
    func returnLogin()
}

class AccountSuccessViewController: UIViewController {
    
    var delegate: ReturnRootDelegate?
    
    // MARK: - IBActions
    
    @IBAction func continueAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.returnLogin()
    }
    
}
