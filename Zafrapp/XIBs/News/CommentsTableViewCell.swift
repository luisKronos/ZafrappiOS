//
//  CommentsTableViewCell.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 22/07/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblcomments: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAnswers: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lycHeigh: NSLayoutConstraint!
    @IBOutlet weak var lycWidth: NSLayoutConstraint!
    
    var aComent : comment?{
        didSet{
//            if aComent?.id_user == getUserSaved() && !(aComent?.user_image?.isEmpty ?? false) {
//                lycHeigh.constant = 70
//                lycWidth.constant = 70
//            }
//            if !(aComent?.user_image?.isEmpty ?? false) {
//             lblAnswers.text = Int(aComent?.HasComments ?? "0") ?? 0 > 0 ? "Ver respuestas" : ""
//            }
            imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
            lblName.text = aComent?.name
            lblcomments.text = aComent?.text_comment
            let dateMonth = String(aComent?.date?.prefix(10) ?? "")
            lblDate.text = dateMonth
            if let imag = aComent?.image {
                imgProfile.downloaded(from: imag, contentMode: .scaleToFill)
            }else {
                imgProfile.downloaded(from: aComent?.user_image ?? "", contentMode: .scaleToFill)
            }
        }
    }
    
    func getUserSaved() -> String {
          let getUser =  informationClasify.sharedInstance.data
          return  getUser?.arrMessage?.strId_user ?? ""
            }
}
