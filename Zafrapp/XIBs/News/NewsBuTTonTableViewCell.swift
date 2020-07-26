//
//  NewsBuTTonTableViewCell.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 22/07/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class NewsBuTTonTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var strTime: UIButton!
    
    var delegate : selectButtonCellDelegate?
    
    var detailNews : listaNews? {
        didSet {
            lblDescription.text = detailNews?.strDescription
            lblTitle.text = detailNews?.strTitle
            let time = compareDate(strDate: detailNews?.strPublish_date ?? "")
            strTime.setTitle("  \(time)", for: .normal)
        }
    }
    
       func daysBetweenDates(startDate: Date, endDate: Date) -> Int
          {
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
    
    @IBAction func ActionShowContact(_ sender: UIButton) {
        delegate?.showContact()
    }
    
    @IBAction func shareData(_ sender: Any) {
        delegate?.shareData()
    }
    @IBAction func getLinkAction(_ sender: Any) {
        delegate?.getLinkAction()
    }
}
