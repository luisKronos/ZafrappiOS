//
//  PositionService.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 26/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

class PositionService: NSObject {
    
    var root = BasePath.path(component: "save_positions")
    var serviceError = NSError(domain: "save_positions", code: 0, userInfo: nil)
    
    func savePosition(idVacant: String, idUser: String , with handler: @escaping ResponseCompletionClosure){
        
        let getInformation = "status=\(2)&id_user=\(idUser)&id_vacant=\(idVacant)"
        
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
