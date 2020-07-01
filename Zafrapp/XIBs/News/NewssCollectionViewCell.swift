//
//  NewssCollectionViewCell.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 19/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

protocol showNewSelectedDelegate {
    func show(New:listaNews)
}

class NewssCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    
    var noticia : listaNews? {
        didSet{
            lblDescription.text = noticia?.strDescription
            lblTitle.text = noticia?.strTitle
            lblTime.text = compareDate(strDate:  noticia?.strPublish_date ?? "29/05/2020")
        }
    }
        
        var noticiaSecondary : listaNews? {
            didSet{
                lblTime.font = UIFont(name: "Poppins-Regular", size: 8)
                lblTitle.font = UIFont(name: "Poppins-Bold", size: 8)
                lblDescription.font = UIFont(name: "Poppins-Light", size: 8)
                lblDescription.text = noticiaSecondary?.strDescription
                lblTitle.text = noticiaSecondary?.strTitle
                lblTime.text = compareDate(strDate:  noticiaSecondary?.strPublish_date ?? "29/05/2020")
            }
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
        case 1:
            return "Ayer"
        default:
            return  strDate
        }
         
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int
    {
      let calendar = Calendar.current

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: startDate)
        let date2 = calendar.startOfDay(for: endDate)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
    }
}
