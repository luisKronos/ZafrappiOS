//
//  LogIn.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 4/29/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation
import UIKit

struct LogInData {
    var name: String?
    var password: String?
}

struct UpdateProfileImage {
    var email: String?
    var profileImage: UIImage?
}

struct Response {
    var status: String?
    var messageResponse: MessageResponse?
    var message: String?
    var newsListArray: [NewsList]?
    var companyDetail: CompanyDetail?
    var allCompanies: [Company]?
    var clientDataArray: [ClientData]?
    var vacants: [Postulation]?
    var comments: [Comment]?
}

struct MessageResponse {
    var userId: String?
    var name: String?
    var email: String?
    var cellphone: String?
    var isCellPhoneSharedString: String?
    var birthdate: String?
    var currentJob: String?
    var isSearchWorkString: String?
    var workPlace: String?
    var wordDepartment: String?
    var password: String?
    var image: String?
    var officeNumber: String?
    var `extension`: String?
    var interest: String?
    var addressId: String?
    var status: String?
    var cv: String?
    
    var state: String?
    var suburb: String?
    var street: String?
    var placeNumber: String?
    var zip: String?
    
    var interestArea: String?
}

struct NewsList {
    var type: String?
    var title: String?
    var image: String?
    var publishedDate: String?
    var description: String?
    var video: String?
    var clientId: String?
    var url: String?
    var intNews: String?
}

struct CompanyDetail {
    var description: String?
    var state: String?
    var suburb: String?
    var clientId: String?
    var addressId: String?
    var street: String?
    var companyName: String?
    var contractName: String?
    var image: String?
    var stNumber: String?
    var service: String?
    var zip: String?
    var telephone: String?
    var map: String?
    var mail: String?
    var name: String?
}

struct Company {
    var companyName: String?
    var mail: String?
    var service: String?
    var addressId: String?
    var image: String?
    var cellphone: String?
    var clientId: String?
}

struct ClientData {
    var userId: String?
    var name: String?
    var email: String?
    var cellphone: String?
    var isSharedCellphoneString: String?
    var workPlace: String?
    var workDepartment: String?
    var image: String?
    var officeNumber: String?
    var `extension`: String?
}

struct Comment {
    var commentId: String?
    var text: String?
    var newsId: String?
    var clientId: String?
    var userId: String?
    var replyComment: String?
    var date: String?
    var image: String?
    var name: String?
    var hasCommentsString: String?
    
    var userImageString: String?
    var companyName: String?
    var clientImageString: String?
    var isAnswerShown: Bool?
    var isMovSelected: Bool?
}
