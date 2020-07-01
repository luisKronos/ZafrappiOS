//
//  getUsers_WS.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 02/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

public class getUsers_WS : NSObject {
    
    public typealias CompletionBlock = (_ dictLog : responseLogIn? , Error?) -> Void
    
    var root = basePath().path(Complement: "get_users")
    var serviceError = NSError(domain: "Error", code: 0, userInfo: nil)
    
    public func updateInfoProfile(mail: String, userName : String, IsSearch : Bool, section : Int, with handler : @escaping CompletionBlock){
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
        }else {
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
              var allUsers : [clientData] = []
              data.strStatus = dctResponse["status"] as? String
              
              if let arrAllData = dctResponse["message"] as? NSArray {
                for user in arrAllData {
                    let dataUser = user as? NSDictionary
                    let client = clientData()
                    
                    client.strName       = dataUser?["name"] as? String
                    client.strEmail       = dataUser?["mail"] as? String
                    client.strCelphone     = dataUser?["celphone"] as? String
                    client.strIs_share_cel    = dataUser?["is_share_cel"] as? String
                    client.strWork_place       = dataUser?["work_place"] as? String
                    client.strWork_deparment   = dataUser?["work_deparment"] as? String
                    client.strImage            = dataUser?["image"] as? String
                    client.strNumber_office     = dataUser?["number_office"] as? String
                    client.strExt               = dataUser?["ext"] as? String
                
                    allUsers.append(client)
                   
                }
                
                  
               }
              data.arrClientsData = allUsers
              if let message = dctResponse["message"] as? String {
                  data.strMessage = message
              }
              
              return data
          }
      
}
