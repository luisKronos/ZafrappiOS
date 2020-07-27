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
            shadowView()
            lblUser.text = client?.strName
            if let url = URL(string: client?.strImage ?? "") {
            imgUser.downloaded(from: url, contentMode: .scaleAspectFit)
            imgUser.isHidden = false
            lblName.backgroundColor = UIColor.white
            }else {
             imgUser.isHidden = true
            }
     
            lblInformation.text = "\(client?.strWork_place ?? "")\n\(client?.strWork_deparment ?? "")"
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
    
    override func prepareForReuse() {
        lblUser.text = ""
        lblInformation.text = ""
        imgUser.image = UIImage(contentsOfFile: "")
        lblName.text = ""
    }
    func shadowView () {
        viewBackground.layer.cornerRadius = 25
        viewBackground.layer.shadowColor = UIColor.lightGray.cgColor
        viewBackground.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        viewBackground.layer.shadowRadius = 5.0
        viewBackground.layer.shadowOpacity = 0.5
    }
}
