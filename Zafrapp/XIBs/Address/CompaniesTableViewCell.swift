//
//  CompaniesTableViewCell.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 21/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class CompaniesTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var logoImageView: UIImageView!
    @IBOutlet private var companyNameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var phoneLabel: UILabel!
    @IBOutlet private var selectionImageView: UIImageView!
    
    // MARK: - Public Propeties
    
    var isCheckMarked = false
    
    var dataCompany: Company? {
        didSet{
            companyNameLabel.text = dataCompany?.companyName
            emailLabel.text = dataCompany?.mail
            phoneLabel.text = dataCompany?.cellphone
            shadowView()
        }
    }
    
    var dataVacancies: Postulation? {
        didSet{
         logoImageView.downloaded(from: dataVacancies?.image ?? "", contentMode: .scaleToFill)
            companyNameLabel.text = dataVacancies?.position
            emailLabel.text = "\(dataVacancies?.workPlace ?? "") - \(dataVacancies?.state ?? "")"
            phoneLabel.text = "\(dataVacancies?.salaryRange ?? "") - \(dataVacancies?.publishedDate ?? "")"
            shadowView()
            
            if dataVacancies?.isPostulated ?? false || dataVacancies?.isSaved ?? false || isCheckMarked {
             selectionImageView.image = UIImage(named: "check-circle")
            }
        }
    }
}

extension CompaniesTableViewCell {
    // MARK: - Configuration Methods
    
    func shadowView() {
        containerView.layer.cornerRadius = 15.0
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        containerView.layer.shadowRadius = 5.0
        containerView.layer.shadowOpacity = 0.5
    }
    
}
