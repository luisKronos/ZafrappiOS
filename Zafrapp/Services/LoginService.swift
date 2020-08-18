//
//  LoginService.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 4/29/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation

typealias ResponseCompletionClosure = (_ dictLog: Response? , Error?) -> Void

class LoginService {
    
    var root = BasePath.path(component: "login_user")
    var serviceError = NSError(domain: AppConstants.String.errorTitle, code: 0, userInfo: nil)
    
    func logInClient(Data: LogInData , with handler: @escaping ResponseCompletionClosure){
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let getInformation = "mail=\(Data.name ?? "")&password=\(Data.password ?? "")"
        let postData = NSMutableData(data: getInformation.data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: root)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                DispatchQueue.main.async(execute: {
                    handler(nil, error)
                })
            } else {
                DispatchQueue.main.async(execute: {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any] {
                            handler(self.parseInformation(from: json), self.serviceError)
                        }
                    }catch {
                        handler(nil, error)
                    }
                })
            }
        })
        dataTask.resume()
    }
    
    func parseInformation(from responseDictionary: [String: Any]) -> Response? {
        var data = Response()
        var arrMessage = MessageResponse()
        data.status = responseDictionary["status"] as? String
        
        if let arrAllData = responseDictionary["message"] as? [Any] {
            let dictionary = arrAllData[0] as? [String: Any]
            arrMessage.userId = dictionary?["id_user"] as? String
            arrMessage.name = dictionary?["name"] as? String
            arrMessage.email = dictionary?["mail"] as? String
            arrMessage.cellphone = dictionary?["celphone"] as? String
            arrMessage.isCellPhoneSharedString = dictionary?["is_share_cel"] as? String
            arrMessage.birthdate = dictionary?["birthdate"] as? String
            arrMessage.currentJob = dictionary?["current_job"] as? String
            arrMessage.isSearchWorkString = dictionary?["is_search_work"] as? String
            arrMessage.workPlace = dictionary?["work_place"] as? String
            arrMessage.wordDepartment = dictionary?["work_deparment"] as? String
            arrMessage.password = dictionary?["password"] as? String
            arrMessage.image = dictionary?["image"] as? String
            arrMessage.officeNumber = dictionary?["number_office"] as? String
            arrMessage.extension = dictionary?["ext"] as? String
            arrMessage.interest = dictionary?["interest"] as? String
            arrMessage.addressId = dictionary?["id_address"] as? String
            arrMessage.status = dictionary?["status"] as? String
            arrMessage.cv = dictionary?["cv"] as? String
            arrMessage.zip = dictionary?["cp"] as? String
            arrMessage.suburb = dictionary?["municipio"] as? String
            arrMessage.street = dictionary?["street"] as? String
            arrMessage.placeNumber = dictionary?["number_st"] as? String
            arrMessage.state = dictionary?["state"] as? String
            
            data.messageResponse = arrMessage
        }
        
        if let message = responseDictionary["message"] as? String {
            data.message = message
        }
        
        return data
    }
}

