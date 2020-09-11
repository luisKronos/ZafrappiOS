//
//  CommentsTableViewCell.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 22/07/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var commentLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var answerLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var otherUserImageView: UIImageView!
    @IBOutlet private var initialLabel: UILabel!
    
    // MARK: - Properties
    
    var aComent: Comment? {
        didSet{
            if aComent?.userId == getUserSaved() && (aComent?.isAnswerShown ?? false) {
                otherUserImageView.isHidden = true
                if let image = aComent?.userImageString {
                    profileImageView.downloaded(from: image, contentMode: .scaleToFill)
                    initialLabel.isHidden = true
                } else {
                    initialLabel.isHidden = false
                    changeColorLabel(name: aComent?.name ?? "")
                }
            }
            if aComent?.userId != getUserSaved() && (aComent?.isAnswerShown ?? false) {
                otherUserImageView.isHidden = false
                profileImageView.isHidden = true
                if let image = aComent?.userImageString {
                    otherUserImageView.downloaded(from: image, contentMode: .scaleToFill)
                    initialLabel.isHidden = true
                } else {
                    initialLabel.isHidden = false
                    changeColorLabel(name: aComent?.name ?? "")
                }
            }
            if aComent?.isMovSelected ?? false &&  aComent?.isAnswerShown ?? false {
                otherUserImageView.isHidden = false
                profileImageView.isHidden = true
                if let image = aComent?.image {
                    otherUserImageView.downloaded(from: image, contentMode: .scaleToFill)
                    initialLabel.isHidden = true
                } else {
                    initialLabel.isHidden = false
                    changeColorLabel(name: aComent?.name ?? "")
                }
            }
            
            if !(aComent?.isAnswerShown ?? false) {
                answerLabel.text = Int(aComent?.hasCommentsString ?? "0") ?? 0 > 0 ? "Ver respuestas": ""
                otherUserImageView.isHidden = true
                if let imag = aComent?.image {
                    profileImageView.downloaded(from: imag, contentMode: .scaleToFill)
                    initialLabel.isHidden = true
                } else {
                    initialLabel.isHidden = false
                    changeColorLabel(name: aComent?.name ?? "")
                }
            }
            
            nameLabel.text = aComent?.name
            commentLabel.text = aComent?.text
            let dateMonth = String(aComent?.date?.prefix(10) ?? "")
            dateLabel.text = dateMonth
        }
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        commentLabel.text = ""
        dateLabel.text = ""
        answerLabel.text = ""
        profileImageView.image = UIImage(contentsOfFile: "")
        otherUserImageView.image = UIImage(contentsOfFile: "")
        initialLabel.text = ""
    }
    
}

// MARK: - Private Methods

private extension CommentsTableViewCell {
    
    func getUserSaved() -> String {
        let getUser =  InformationClasify.sharedInstance.data
        return  getUser?.messageResponse?.userId ?? ""
    }
    
    func hash(for string: String) -> UInt64 {
        var result = UInt64(5381)
        let buf = [UInt8](string.utf8)
        for b in buf {
            result = 127 * (result & 0x00ffffffffffffff) + UInt64(b)
        }
        return result
    }
    
    func changeColorLabel(name:String){
        initialLabel.text = name[0 ..< 2]
        let bas = hash(for: name)
        let hash = bas % 4
        switch hash {
        case 0:
            initialLabel.backgroundColor = .blue
        case 1:
            initialLabel.backgroundColor = .green
        case 2:
            initialLabel.backgroundColor = .red
        case 3:
            initialLabel.backgroundColor = .yellow
        default:
            return
        }
    }
}
