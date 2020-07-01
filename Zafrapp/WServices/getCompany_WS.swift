//
//  getCompany_WS.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 02/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

public class getCompany_WS : NSObject {
    
    public typealias CompletionBlock = (_ dictLog : responseLogIn? , Error?) -> Void
    
    var root = basePath().path(Complement: "get_companies")
    var serviceError = NSError(domain: "Error", code: 0, userInfo: nil)
    
    public func updateInfoProfile(mail: String,companyName : String, IsSearch : Bool,section : Int, with handler : @escaping CompletionBlock){
        var getInformation = ""
            if IsSearch{
                switch section {
                    case 1:
                        getInformation = "mail=\(mail)&state=\(companyName)"
                    case 3:
                        getInformation = "mail=\(mail)&service=\(companyName)"
                    default:
                        getInformation = "mail=\(mail)&company_name=\(companyName)"
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
                                handler(self.parseInformationCompany(fromDicResponse: json), self.serviceError)
                        }
                    } catch {
                            handler(nil, self.serviceError)
                        }
                    })
               
                }
            })
            dataTask.resume()
    }
    
        func parseInformationCompany (fromDicResponse dctResponse: [String : Any]) -> responseLogIn  {
             let data = responseLogIn()
             var companies : [company] = []
            data.strStatus = dctResponse["status"] as? String
            if let allCompanies = dctResponse["message"] as? NSArray {
                for Ocompany in allCompanies {
                let oneCompany = Ocompany as? NSDictionary
                let getData = company ()
                    getData.strCompany_name = oneCompany?["company_name"] as? String
                    getData.strMail = oneCompany?["mail"] as? String
                    getData.strService = oneCompany?["service"] as? String
                    getData.strId_address = oneCompany?["id_address"] as? String
                    getData.strImage = oneCompany?["image"] as? String
                    getData.strCelPhone = oneCompany?["tel"] as? String
                    getData.strId_client = oneCompany?["id_client"] as? String
                 
                   companies.append(getData)
                }
             }
        
            if let message = dctResponse["message"] as? String {
                       data.strMessage = message
                   }
            data.allCompanies = companies
           return data
         }
      
}
