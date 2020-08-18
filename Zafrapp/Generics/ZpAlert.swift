//
//  ZpAlert.swift
//  Zafrapp
//  Created by Mayte Dominguez Gomez on 4/29/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation
import UIKit

class ZPAlertGeneric {
    
    static public func oneOption(title: String?,
                                 message: String?,
                                 actionTitle: String?,
                                 actionHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle,
                                                style: .default,
                                                handler: actionHandler))
        return alertController
    }
    
    static public func twoOption(title: String?,
                                 message: String?,
                                 firstActionTitle: String?,
                                 firstActionHandler: ((UIAlertAction) -> Void)? = nil,
                                 secondActionTitle: String?,
                                 secondActionHandler: ((UIAlertAction) -> Void)? = nil,
                                 folio: String? = nil) -> UIAlertController {
        let alertController = ZPAlertGeneric.oneOption(title: title,
                                                       message: message,
                                                       actionTitle: firstActionTitle,
                                                       actionHandler: firstActionHandler)
        alertController.addAction(UIAlertAction(title : secondActionTitle,
                                                style : .default,
                                                handler: secondActionHandler))
        return alertController
    }
}

