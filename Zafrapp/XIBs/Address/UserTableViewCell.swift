//
//  UserTableViewCell.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 21/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var userLabel: UILabel!
    @IBOutlet private var informationLabel: UILabel!
    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    
    // MARK: - Properties
    
    var client: ClientData? {
        didSet{
            nameLabel.text = client?.name?[0 ..< 2]
            let bas = hash(string: client?.name ?? "ZP")
            let hash = bas % 4
            switch hash {
            case 0:
                nameLabel.backgroundColor = .blue
            case 1:
                nameLabel.backgroundColor = .green
            case 2:
                nameLabel.backgroundColor = .red
            case 3:
                nameLabel.backgroundColor = .yellow
            default:
                return
            }
            shadowView()
            userLabel.text = client?.name
            
            if let url = URL(string: client?.image ?? "") {
                userImageView.downloaded(from: url, contentMode: .scaleAspectFit)
                userImageView.isHidden = false
                nameLabel.backgroundColor = .white
            } else {
                userImageView.isHidden = true
            }
            
            informationLabel.text = "\(client?.workPlace ?? "")\n\(client?.workDepartment ?? "")"
        }
    }
    
    override func prepareForReuse() {
        userLabel.text = ""
        informationLabel.text = ""
        userImageView.image = UIImage(contentsOfFile: "")
        nameLabel.text = ""
    }
}

// MARK: - Private Methods

private extension UserTableViewCell {
    
    // MARK: - Configuration methods
    
    func shadowView() {
        containerView.layer.cornerRadius = 25
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        containerView.layer.shadowRadius = 5.0
        containerView.layer.shadowOpacity = 0.5
    }
    
    // MARK: - Hash methods
    
    func hash(string: String) -> UInt64 {
        var result = UInt64(5381)
        let buffer = [UInt8](string.utf8)
        for byte in buffer {
            result = 127 * (result & 0x00ffffffffffffff) + UInt64(byte)
        }
        return result
    }
    
}
