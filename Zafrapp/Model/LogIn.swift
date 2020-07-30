//
//  LogIn.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 4/29/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation
import UIKit

public class LogInData : NSObject {
    public var strName      : String?
    public var strPass      : String?
}
public class updateProfileImage : NSObject {
    public var strEmail   : String?
    public var ImgProfile      : UIImage?
}
public class responseLogIn: NSObject {
    public var strStatus   : String?
    public var arrMessage  : messageResponse?
    public var strMessage  : String?
    public var arrList     : [listaNews]?
    public var detailCompany : detailCompany?
    public var allCompanies : [company]?
    public var arrClientsData : [clientData]?
    public var allVacants : [postulations]?
    var allComment : [comment]?
}

public class messageResponse : NSObject {
    public var strId_user           : String?
    public var strName              : String?
    public var strEmail             : String?
    public var strCelphone          : String?
    public var strIs_share_cel      : String?
    public var strBirthdate         : String?
    public var strCurrent_job       : String?
    public var strIs_search_work    : String?
    public var strWork_place        : String?
    public var strWork_deparment    : String?
    public var strPassword          : String?
    public var strImage             : String?
    public var strNumber_office     : String?
    public var strExt               : String?
    public var strInterest          : String?
    public var strId_address        : String?
    public var strStatus            : String?
    public var strCv                : String?
    
    public var strEstado            : String?
    public var strMunicipio         : String?
    public var strCalle             : String?
    public var strNumero            : String?
    public var strCP                : String?
    
    public var strAreaInteres       : String?
}

public class listaNews : NSObject {
    public var strType            : String?
    public var strTitle           : String?
    public var strImage           : String?
    public var strPublish_date    : String?
    public var strDescription     : String?
    public var strVideo           : String?
    public var strClient_id       : String?
    public var strUrl             : String?
    public var intNews            : String?
}

public class detailCompany {
    public var strDescription : String?
    public var strState : String?
    public var strMunicipio : String?
    public var strId_client : String?
    public var strId_Adress : String?
    public var strStreet : String?
    public var strCompany_name: String?
    public var strName_Contact : String?
    public var strImage : String?
    public var strNumber_ST : String?
    public var strService : String?
    public var strCP : String?
    public var strtel : String?
    public var strMaps : String?
    public var strMail : String?
    public var strName : String?
}

public class company {
    public var strCompany_name : String?
    public var strMail : String?
    public var strService : String?
    public var strId_address : String?
    public var strImage : String?
    public var strCelPhone : String?
    public var strId_client : String?
}

public class clientData : NSObject {
    public var strId_user           : String?
    public var strName              : String?
    public var strEmail             : String?
    public var strCelphone          : String?
    public var strIs_share_cel      : String?
    public var strWork_place        : String?
    public var strWork_deparment    : String?
    public var strImage             : String?
    public var strNumber_office     : String?
    public var strExt               : String?
}

class comment  {
    var id_comment: String?
    var text_comment:String?
    var id_news:String?
    var id_client:String?
    var id_user:String?
    var reply_comment:String?
    var date:String?
    var image:String?
    var name:String?
    var HasComments:String?
    
    var user_image:String?
    var company_name : String?
    var client_image : String?
    var bShowAnswer : Bool?
    var bisMovSelected : Bool?
}
