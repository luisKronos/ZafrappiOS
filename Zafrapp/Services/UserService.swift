//
//  UserService.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 02/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

class UserService: NSObject {
    
    var root = basePath().path(Complement: "get_users")
    var serviceError = NSError(domain: AppConstants.String.errorTitle, code: 0, userInfo: nil)
    
    func updateInfoProfile(mail: String, userName: String, IsSearch: Bool, section: Int, with handler: @escaping ResponseCompletionClosure){
        var getInformation = ""
        if IsSearch{
            switch section {
            case 1:
                getInformation = "mail=\(mail)&ingenio=\(userName)"
            case 3:
                getInformation = "mail=\(mail)&deparment=\(userName)"
            default:
                getInformation = "mail=\(mail)&name=\(userName)"
            }
        } else {
            getInformation = "mail=\(mail)"
        }
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
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
                    } catch {
                        handler(nil, self.serviceError)
                    }
                })
                
            }
        })
        dataTask.resume()
    }
    
    func parseInformation(from responseDictionary: [String: Any]) -> Response? {
        var data = Response()
        var allUsers: [ClientData] = []
        data.status = responseDictionary["status"] as? String
        
        if let arrAllData = responseDictionary["message"] as? [Any] {
            for user in arrAllData {
                guard let dataUser = user as? [AnyHashable: Any] else {
                    continue
                }
                var client = ClientData()
                client.name = dataUser["name"] as? String
                client.email = dataUser["mail"] as? String
                client.cellphone = dataUser["celphone"] as? String
                client.isSharedCellphoneString = dataUser["is_share_cel"] as? String
                client.workPlace = dataUser["work_place"] as? String
                client.workDepartment = dataUser["work_deparment"] as? String
                client.image = dataUser["image"] as? String
                client.officeNumber = dataUser["number_office"] as? String
                client.extension = dataUser["ext"] as? String
                
                allUsers.append(client)
                
            }
            
            
        }
        data.clientDataArray = allUsers
        if let message = responseDictionary["message"] as? String {
            data.message = message
        }
        
        return data
    }
    
}
