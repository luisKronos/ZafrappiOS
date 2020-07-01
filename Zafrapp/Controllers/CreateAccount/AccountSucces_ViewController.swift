//
//  AccountSucces_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/5/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

protocol returnRootDelegate {
    func returnLogin ()
}

class AccountSucces_ViewController: UIViewController {

    var delegate : returnRootDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
   
    @IBAction func Continue(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.returnLogin()
    }

}
