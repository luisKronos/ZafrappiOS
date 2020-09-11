//
//  IngenioService.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 27/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

class IngenioService: NSObject {
    
    var root = BasePath.path(component: "get_ingenio")
    var serviceError = NSError(domain: AppConstants.String.errorTitle, code: 0, userInfo: nil)
    
    func getDataIngenio(Id_Ingenio: String, with handler: @escaping ResponseCompletionClosure){
        let idIngenio = Int(Id_Ingenio)
        let getInformation = "id_ingenio=\(idIngenio ?? 1)"
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
        var allUsers: [CompanyDetail] = []
        data.status = responseDictionary["status"] as? String
        
        if let arrAllData = responseDictionary["message"] as? [Any] {
            for user in arrAllData {
                let dataUser = user as? NSDictionary
                var client = CompanyDetail()
                
                client.name = dataUser?["name"] as? String
                client.description = dataUser?["description"] as? String
                client.image = dataUser?["image"] as? String
                client.map = dataUser?["maps"] as? String
                client.state = dataUser?["state"] as? String
                client.suburb = dataUser?["municipio"] as? String
                client.street = dataUser?["street"] as? String
                client.stNumber = dataUser?["number_st"] as? String
                client.zip = dataUser?["cp"] as? String
                
                allUsers.append(client)
                
            }
            
        }
        data.companyDetail = allUsers.first
        if let message = responseDictionary["message"] as? String {
            data.message = message
        }
        
        return data
    }
    
}
