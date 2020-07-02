//
//  CompaniesTableViewCell.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 21/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class CompaniesTableViewCell: UITableViewCell {

    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblNameCompany: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var imgSelection: UIImageView!
    var imageChecK = false
    
    var dataCompany : company? {
        didSet{
            lblNameCompany.text = dataCompany?.strCompany_name
            lblEmail.text = dataCompany?.strMail
            lblPhone.text = dataCompany?.strCelPhone
            shadowView()
        }
    }
    
    var dataVacancies : postulations? {
        didSet{
         imgLogo.downloaded(from: dataVacancies?.strImage ?? "")
            lblNameCompany.text = dataVacancies?.strPosition
            lblEmail.text = "\(dataVacancies?.strWork_Place ?? "") - \(dataVacancies?.strState ?? "")"
            lblPhone.text = "\(dataVacancies?.strRange_Salary ?? "") - \(dataVacancies?.strPucblishDate ?? "")"
            shadowView()
            
            if dataVacancies?.bIsPostulated ?? false || dataVacancies?.bisSaved ?? false || imageChecK {
             imgSelection.image = UIImage(named: "check-circle")
            }
        }
    }
    
    func shadowView () {
         vBackground.layer.cornerRadius = 25
         vBackground.layer.shadowColor = UIColor.lightGray.cgColor
         vBackground.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
         vBackground.layer.shadowRadius = 5.0
         vBackground.layer.shadowOpacity = 0.5
     }
    
}
