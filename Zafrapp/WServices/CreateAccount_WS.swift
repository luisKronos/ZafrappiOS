//
//  CreateAccount_WS.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 5/5/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation

public class CreateAccount_WS : NSObject {
    
    public typealias CompletionBlock = (_ dictLog : responseLogIn? , Error?) -> Void
    
    var root = basePath().path(Complement: "create_user")
    var serviceError = NSError(domain: "Error", code: 0, userInfo: nil)
    
    public func createAccount(Data: registerAccount , with handler : @escaping CompletionBlock){
         let bSearch_job = (Data.bIs_search_work ?? false) ? 1 : 0
         let share_cell = (Data.bShareCel ?? false) ? 1 : 0
        let getInformation = "name=\(Data.strName ?? "")&mail=\(Data.strEmail ?? "")&celphone=\(Data.intPhone ?? 0)&is_share_cel=\(share_cell)&birthdate=\(Data.strBirthDay ?? "")&current_job=\(Data.strCurrent_job ?? "")&is_search_work=\(bSearch_job)&work_place=\(Data.strWork_place ?? "")&work_deparment=\(Data.strWork_deparment ?? "")&password=\(Data.strPassword ?? "")"
        
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
                         handler(self.parseInformation(fromDicResponse: json), self.serviceError)
                        }
                    } catch {
                        handler(nil, self.serviceError)
                    }
                  })
                }
            })
            dataTask.resume()
    }
    
    func parseInformation (fromDicResponse dctResponse: [String : Any]) -> responseLogIn? {
        let data = responseLogIn ()
        data.strStatus = dctResponse["status"] as? String
        if let message = dctResponse["message"] as? String {
            data.strMessage = message
        }
        return data
    }
}
