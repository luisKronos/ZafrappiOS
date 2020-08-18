//
//  Funtions.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 4/29/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation
import UIKit

class basePath {
    func path(Complement:String) -> String{
        let path = "https://zafrapp.com/\(Complement).php"
        return path
    }
}

class changeLabel{
    func changeColorLabel(string:String, label: UILabel){
        label.text = string[0 ..< 2]
        let bas = hash(string)
        let hash = bas % 4
        switch hash {
        case 0:
            label.backgroundColor = .blue
        case 1:
            label.backgroundColor = .green
        case 2:
            label.backgroundColor = .red
        case 3:
            label.backgroundColor = .yellow
        default:
            return
        }
    }
    
    func hash(_ string: String) -> UInt64 {
        var result = UInt64 (5381)
        let buf = [UInt8](string.utf8)
        for b in buf {
            result = 127 * (result & 0x00ffffffffffffff) + UInt64(b)
        }
        return result
    }
}
