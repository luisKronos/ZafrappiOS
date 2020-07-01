//
//  Login_WS.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 4/29/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation

public class LogIn_WC : NSObject {
    
    public typealias CompletionBlock = (_ dictLog : responseLogIn? , Error?) -> Void
    
    var root = basePath().path(Complement: "login_user")
    var serviceError = NSError(domain: "Error", code: 0, userInfo: nil)
    
    public func logInClient(Data: LogInData , with handler : @escaping CompletionBlock){
            
            let headers = ["Content-Type": "application/x-www-form-urlencoded"]
            let getInformation = "mail=\(Data.strName ?? "")&password=\(Data.strPass ?? "")"
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
                        }catch {
                            handler(nil, error)
                            }
                    })
                }
            })
            dataTask.resume()
    }
    
    func parseInformation (fromDicResponse dctResponse: [String : Any]) -> responseLogIn? {
        let data = responseLogIn ()
        let arrMessage = messageResponse ()
        data.strStatus = dctResponse["status"] as? String
        
        if let arrAllData = dctResponse["message"] as? NSArray {
            let dictionary = arrAllData[0] as? [String: Any]
            arrMessage.strId_user   = dictionary?["id_user"] as? String
            arrMessage.strName       = dictionary?["name"] as? String
            arrMessage.strEmail       = dictionary?["mail"] as? String
            arrMessage.strCelphone     = dictionary?["celphone"] as? String
            arrMessage.strIs_share_cel    = dictionary?["is_share_cel"] as? String
            arrMessage.strBirthdate     = dictionary?["birthdate"] as? String
            arrMessage.strCurrent_job  = dictionary?["current_job"] as? String
            arrMessage.strIs_search_work   = dictionary?["is_search_work"] as? String
            arrMessage.strWork_place       = dictionary?["work_place"] as? String
            arrMessage.strWork_deparment   = dictionary?["work_deparment"] as? String
            arrMessage.strPassword         = dictionary?["password"] as? String
            arrMessage.strImage            = dictionary?["image"] as? String
            arrMessage.strNumber_office     = dictionary?["number_office"] as? String
            arrMessage.strExt               = dictionary?["ext"] as? String
            arrMessage.strInterest         = dictionary?["interest"] as? String
            arrMessage.strId_address        = dictionary?["id_address"] as? String
            arrMessage.strStatus            = dictionary?["status"] as? String
            arrMessage.strCv                = dictionary?["cv"] as? String
            arrMessage.strCP                = dictionary?["cp"] as? String
            arrMessage.strMunicipio         = dictionary?["municipio"] as? String
            arrMessage.strCalle         = dictionary?["street"] as? String
            arrMessage.strNumero         = dictionary?["number_st"] as? String
            arrMessage.strEstado         = dictionary?["state"] as? String
            
            data.arrMessage = arrMessage
         }
        
        if let message = dctResponse["message"] as? String {
            data.strMessage = message
        }
        
        return data
    }
}

