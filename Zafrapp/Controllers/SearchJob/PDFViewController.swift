//
//  PDFViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 29/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import WebKit

class PDFViewController: UIViewController, WKUIDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet private var webView: WKWebView!
    
    // MARK: - Public Properties
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: urlString ?? "") {
            webView.load(URLRequest(url: url))
        }
    }
}
