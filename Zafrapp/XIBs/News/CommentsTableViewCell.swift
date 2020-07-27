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
    @IBOutlet weak var imgOtherUser: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    var aComent : comment?{
        didSet{
          
            if aComent?.id_user == getUserSaved() && (aComent?.bShowAnswer ?? false) {
                imgOtherUser.isHidden = true
                if let image = aComent?.user_image {
                imgProfile.downloaded(from: image, contentMode: .scaleToFill)
                    labelName.isHidden = true
                }else {
                    labelName.isHidden = false
                    changeColorLabel(Name: aComent?.name ?? "")
                }
            }
            if aComent?.id_user != getUserSaved() && (aComent?.bShowAnswer ?? false) {
                imgOtherUser.isHidden = false
                imgProfile.isHidden = true
                if let image = aComent?.user_image {
                imgOtherUser.downloaded(from: image, contentMode: .scaleToFill)
                    labelName.isHidden = true
                }else {
                   labelName.isHidden = false
                    changeColorLabel(Name: aComent?.name ?? "")
                }
            }
            if aComent?.bisMovSelected ?? false &&  aComent?.bShowAnswer ?? false {
                imgOtherUser.isHidden = false
                imgProfile.isHidden = true
                if let image = aComent?.image {
                imgOtherUser.downloaded(from: image, contentMode: .scaleToFill)
                    labelName.isHidden = true
                }else {
                    labelName.isHidden = false
                    changeColorLabel(Name: aComent?.name ?? "")
                }
            }
            
            if !(aComent?.bShowAnswer ?? false) {
             lblAnswers.text = Int(aComent?.HasComments ?? "0") ?? 0 > 0 ? "Ver respuestas" : ""
             imgOtherUser.isHidden = true
              if let imag = aComent?.image {
                    imgProfile.downloaded(from: imag, contentMode: .scaleToFill)
                labelName.isHidden = true
              }else {
                labelName.isHidden = false
                changeColorLabel(Name: aComent?.name ?? "")
                }
            }
            
            lblName.text = aComent?.name
            lblcomments.text = aComent?.text_comment
            let dateMonth = String(aComent?.date?.prefix(10) ?? "")
            lblDate.text = dateMonth
        }
    }
    
    func getUserSaved() -> String {
          let getUser =  informationClasify.sharedInstance.data
          return  getUser?.arrMessage?.strId_user ?? ""
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
        lblName.text = ""
        lblcomments.text = ""
        lblDate.text = ""
        lblAnswers.text = ""
        imgProfile.image = UIImage(contentsOfFile: "")
        imgOtherUser.image = UIImage(contentsOfFile: "")
        labelName.text = ""
    }
    
    func changeColorLabel (Name:String){
        labelName.text = Name[0 ..< 2]
        let bas = strHash(Name)
        let hash = bas % 4
             switch hash {
                case 0:
                    labelName.backgroundColor = UIColor.blue
                case 1:
                    labelName.backgroundColor = UIColor.green
                case 2:
                    labelName.backgroundColor = UIColor.red
                case 3:
                    labelName.backgroundColor = UIColor.yellow
                default:
                    return
                }
    }
}
