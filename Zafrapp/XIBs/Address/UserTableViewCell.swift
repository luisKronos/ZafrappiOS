//
//  UserTableViewCell.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 21/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblInformation: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    var client : clientData?{
        didSet{
                lblName.text = client?.strName?[0 ..< 2]
                let bas = strHash(client?.strName ?? "ZP")
                let hash = bas % 4
                switch hash {
                case 0:
                    lblName.backgroundColor = UIColor.blue
                case 1:
                     lblName.backgroundColor = UIColor.green
                case 2:
                   lblName.backgroundColor = UIColor.red
                case 3:
                     lblName.backgroundColor = UIColor.yellow
                default:
                    return
                }
            var phoneOffice = ""
            var cell = ""
            shadowView()
            lblUser.text = client?.strName
            if client?.strIs_share_cel == "1"{
                cell = "\n\(client?.strCelphone ?? "")"
             }else {
                cell = ""
             }
            if client?.strNumber_office?.isEmpty ?? false || client?.strNumber_office == nil {
                  phoneOffice = ""
             }else {
                  phoneOffice = "\(client?.strNumber_office ?? "") Ext(\(client?.strExt ?? ""))"
                }
            lblInformation.text = "\(client?.strEmail ?? "")\n\(client?.strWork_place ?? "")\(cell)\n\(client?.strWork_deparment ?? "")\n\(phoneOffice)"
        }
    }
    
    func strHash(_ str: String) -> UInt64 {
       var result = UInt64 (5381)
       let buf = [UInt8](str.utf8)
       for b in buf {
           result = 127 * (result & 0x00ffffffffffffff) + UInt64(b)
       }
       return result
    }
    
    func shadowView () {
        viewBackground.layer.cornerRadius = 25
        viewBackground.layer.shadowColor = UIColor.lightGray.cgColor
        viewBackground.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        viewBackground.layer.shadowRadius = 5.0
        viewBackground.layer.shadowOpacity = 0.5
    }
}
