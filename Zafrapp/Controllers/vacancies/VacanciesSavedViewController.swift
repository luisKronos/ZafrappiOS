//
//  VacanciesSavedViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 28/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class VacanciesSavedViewController: UIViewController {

    @IBOutlet weak var viewSelection: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSegmentedControled()
    }
    
    func addSegmentedControled () {
           let codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: self.viewSelection.frame.width , height: self.viewSelection.frame.height), buttonTitle: ["Mis vacantes marcadas","Mis postulaciones"])
           codeSegmented.delegate = self
           codeSegmented.backgroundColor = .clear
           self.viewSelection.addSubview(codeSegmented)
       }
}

extension VacanciesSavedViewController : CustomSegmentedControlDelegate{
    
    func changeToIndex(index: Int) {

    }
}
