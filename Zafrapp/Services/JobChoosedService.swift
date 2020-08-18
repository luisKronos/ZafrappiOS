//
//  JobChoosedService.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 29/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

class JobChoosedService: NSObject {
    
    var root = basePath().path(Complement: "save_positions")
    var serviceError = NSError(domain: AppConstants.String.errorTitle, code: 0, userInfo: nil)
    
    func obtainPostulations(idVacante: Int ,id_user: Int , id_ingenio: Int,  with handler: @escaping ResponseCompletionClosure){
        var getInformation = ""
        let status  = 1
        getInformation = "status=\(status)&id_vacant=\(idVacante)&id_user=\(id_user)&id_ingenio=\(id_ingenio)"
        
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
        data.status = responseDictionary["status"] as? String
        if let message = responseDictionary["message"] as? String {
            data.message = message
        }
        
        return data
    }
    
}
