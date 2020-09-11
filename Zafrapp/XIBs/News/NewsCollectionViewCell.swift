//
//  NewsCollectionViewCell.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 19/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

protocol ShowNewSelectedDelegate {
    func show(new: NewsList)
}

class NewsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private IBOutlets
    
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    // MARK: - Public IBOutlets
    
    @IBOutlet var imageView: UIImageView!
    
    // MARK: - Public Properties
    
    var noticia: NewsList? {
        didSet{
            descriptionLabel.text = noticia?.description
            titleLabel.text = noticia?.title
            timeLabel.text = compareDate(dateString:  noticia?.publishedDate ?? "")
        }
    }
    
    var noticiaSecondary: NewsList? {
        didSet{
            timeLabel.font = UIFont(name: "Poppins-Regular", size: 8)
            titleLabel.font = UIFont(name: "Poppins-Bold", size: 8)
            descriptionLabel.font = UIFont(name: "Poppins-Light", size: 8)
            descriptionLabel.text = noticiaSecondary?.description
            titleLabel.text = noticiaSecondary?.title
            timeLabel.text = compareDate(dateString:  noticiaSecondary?.publishedDate ?? "")
        }
    }
    
}

private extension NewsCollectionViewCell {
    
    // MARK: - Date Methods
    
    func compareDate(dateString: String) -> String {
        let dateSended = dateString.toDate() ?? Date()
        let currentDate = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        let days = daysBetweenDates(startDate: dateSended, endDate: currentDate)
        
        switch days {
        case 0:
            return "Hoy"
        case 1:
            return "Ayer"
        default:
            return  dateString
        }
        
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: startDate)
        let date2 = calendar.startOfDay(for: endDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
    }
}
