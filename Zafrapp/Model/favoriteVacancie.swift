//
//  favoriteVacancie.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 26/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

class checkDay {
    var strDay : String?
    var bCheck : Bool?
    init(day : String, bcheck : Bool) {
        strDay = day
        bCheck = bcheck
    }
}

class UpdateProfile: Codable {
    var strID : String?
    var bisSaved : Bool?
    var bHeApplied : Bool?


    
}
