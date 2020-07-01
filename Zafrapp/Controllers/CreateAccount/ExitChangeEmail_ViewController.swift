//
//  ExitChangeEmail_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/5/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class ExitChangeEmail_ViewController: UIViewController {

    var delegate : returnRootDelegate?

    @IBAction func GoOnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.returnLogin()
    }
    
}
