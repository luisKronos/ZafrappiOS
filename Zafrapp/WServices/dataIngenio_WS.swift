//
//  dataIngenio_WS.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 27/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation


public class getIngenio_WS : NSObject {
    
    public typealias CompletionBlock = (_ dictLog : responseLogIn? , Error?) -> Void
    
    var root = basePath().path(Complement: "get_ingenio")
    var serviceError = NSError(domain: "Error", code: 0, userInfo: nil)
    
    public func getDataIngenio(Id_Ingenio: String, with handler : @escaping CompletionBlock){
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
              var allUsers : [detailCompany] = []
              data.strStatus = dctResponse["status"] as? String
              
              if let arrAllData = dctResponse["message"] as? NSArray {
                for user in arrAllData {
                    let dataUser = user as? NSDictionary
                    let client = detailCompany()
                    
                    client.strName       = dataUser?["name"] as? String
                    client.strDescription       = dataUser?["description"] as? String
                    client.strImage     = dataUser?["image"] as? String
                    client.strMaps     = dataUser?["maps"] as? String
                    client.strState    = dataUser?["state"] as? String
                    client.strMunicipio       = dataUser?["municipio"] as? String
                    client.strStreet   = dataUser?["street"] as? String
                    client.strNumber_ST            = dataUser?["number_st"] as? String
                    client.strCP     = dataUser?["cp"] as? String
                
                    allUsers.append(client)
                   
                }

               }
        data.detailCompany = allUsers.first
              if let message = dctResponse["message"] as? String {
                  data.strMessage = message
              }
              
              return data
          }
      
}
