//
//  ProfileCompany_WS.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 02/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

public class ProfileCompany_WS : NSObject {
    
    public typealias CompletionBlock = (_ dictLog : responseLogIn? , Error?) -> Void
    
    var root = basePath().path(Complement: "get_companies")
    var serviceError = NSError(domain: "Error", code: 0, userInfo: nil)
    
    public func updateInfoProfile(mail: String, clienID : String, isIngenio: Bool , with handler : @escaping CompletionBlock){
        var getInformation = ""
        if isIngenio {
           root = basePath().path(Complement: "get_ingenio")
            getInformation =  "mail=\(mail)&id_ingenio=\(clienID)"
        }else {
           getInformation =  "mail=\(mail)&id_client=\(clienID)"
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
                        if isIngenio {
                           handler(self.parseInformationIngenio(fromDicResponse: json), self.serviceError)
                        }else {
                            handler(self.parseInformation(fromDicResponse: json), self.serviceError)
                        }
                        }
                    } catch {
                            handler(nil, self.serviceError)
                        }
                    })
               
                }
            })
            dataTask.resume()
    }
    
     func parseInformation (fromDicResponse dctResponse: [String : Any]) -> responseLogIn?{
              var company : [detailCompany] = []
              let data = responseLogIn()
              data.strStatus = dctResponse["status"] as? String
        
        if  let arrCompany = dctResponse["message"] as? NSArray{
            for mov in arrCompany {
                             let movs = mov as! NSDictionary
                             let detail = detailCompany ()
                             detail.strDescription = movs["description"] as? String
                             detail.strState = movs["state"] as? String
                             detail.strMunicipio = movs["municipio"] as? String
                             detail.strId_client = movs["id_client"] as? String
                             detail.strId_Adress = movs["id_address"] as? String
                             detail.strStreet = movs["street"] as? String
                             detail.strCompany_name = movs["company_name"] as? String
                             detail.strName_Contact = movs["name_contact"] as? String
                             detail.strImage = movs["image"] as? String
                             detail.strNumber_ST = movs["number_st"] as? String
                             detail.strService = movs["service"] as? String
                             detail.strCP = movs["cp"] as? String
                             detail.strtel = movs["tel"] as? String
                             detail.strMaps = movs["maps"] as? String
                             detail.strMail = movs["mail"] as? String
                             
                             company.append(detail)
                         }
              data.detailCompany = company[0]
           }
              return data
          }
    
    func parseInformationIngenio (fromDicResponse dctResponse: [String : Any]) -> responseLogIn?{
                var company : [detailCompany] = []
                let data = responseLogIn()
                data.strStatus = dctResponse["status"] as? String
          
          if  let arrCompany = dctResponse["message"] as? NSArray{
              for mov in arrCompany {
                               let movs = mov as! NSDictionary
                               let detail = detailCompany ()
                               detail.strDescription = movs["description"] as? String
                               detail.strState = movs["state"] as? String
                               detail.strMunicipio = movs["municipio"] as? String
                               detail.strId_client = movs["id_client"] as? String
                               detail.strId_Adress = movs["id_address"] as? String
                               detail.strStreet = movs["street"] as? String
                               detail.strCompany_name = movs["company_name"] as? String
                               detail.strName_Contact = movs["name"] as? String
                               detail.strImage = movs["image"] as? String
                               detail.strNumber_ST = movs["number_st"] as? String
                               detail.strService = movs["service"] as? String
                               detail.strCP = movs["cp"] as? String
                               detail.strtel = movs["tel"] as? String
                               detail.strMaps = movs["maps"] as? String
                               detail.strMail = movs["mail"] as? String
                               
                               company.append(detail)
                           }
                data.detailCompany = company[0]
             }
                return data
            }
      
}
