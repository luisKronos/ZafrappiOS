//
//  ShowPDFViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 29/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import WebKit

class ShowPDFViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var webKit: WKWebView!
    var urlStr : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

     let url = URL(string: urlStr ?? "")
      webKit.load(URLRequest(url: url!))
    }
    

}
