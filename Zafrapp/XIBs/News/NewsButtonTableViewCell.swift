//
//  NewsBuTTonTableViewCell.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 22/07/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class NewsButtonTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var timeButton: UIButton!
    
    // MARK: - Properties
    
    var delegate: SelectButtonCellDelegate?
    
    var detailNews: NewsList? {
        didSet {
            descriptionLabel.text = detailNews?.description
            titleLabel.text = detailNews?.title
            let time = compareDate(strDate: detailNews?.publishedDate ?? "")
            timeButton.setTitle("  \(time)", for: .normal)
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func showContactAction(_ sender: UIButton) {
        delegate?.showContact()
    }
    
    @IBAction func shareData(_ sender: Any) {
        delegate?.shareData()
    }
    
    @IBAction func getLinkAction(_ sender: Any) {
        delegate?.getLinkAction()
    }
}

// MARK: - Private Methods

private extension NewsButtonTableViewCell {
    
    // MARK: - Date Methods
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: startDate)
        let date2 = calendar.startOfDay(for: endDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
    }
    
    func compareDate(strDate: String) -> String {
        let dateSended = strDate.toDate() ?? Date()
        let currentDate = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        let dias = daysBetweenDates(startDate: dateSended, endDate: currentDate)
        
        switch  dias{
        case 0:
            return "Hoy"
        default:
            return  strDate
        }
    }
}
