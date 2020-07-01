//
//  RegisterAccount.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/5/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

public class registerAccount : NSObject {
    public var strName              : String?
    public var strEmail             : String?
    public var intPhone             : Int?
    public var bShareCel            : Bool?
    public var strBirthDay          : String?
    public var strCurrent_job       : String?
    public var bIs_search_work      : Bool?
    public var strWork_place        : String?
    public var strWork_deparment    : String?
    public var strPassword          : String?
}

public class optionsProfile : NSObject {
    public var strTitle    : String?
    public var strImage    : String?
}

public class updateData : NSObject {
    public var strEmail             : String?
    public var strCurrent_job       : String?
    public var bIs_search_work      : Bool?
    public var bShow_Cell           : Bool?
    public var strWork_place        : String?
    public var strWork_deparment    : String?
    public var strInterest          : String?
    public var strState              : String?
    public var strMunicipio          : String?
    public var strStreet             : String?
    public var strNumberStreet       : String?
    public var intCP                 : Int?
    public var strId_Adress          : String?
    public var strId_user            : String?
    public var intCellPhone          : Int?
    public var intNumber_Office      : Int?
    public var intExt                : Int?
    
    public var strAreaDeInteres      : String?
}
