//
//  CompanyService.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 02/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

class CompanyService: NSObject {
    
    var root = BasePath.path(component: "get_companies")
    var serviceError = NSError(domain: AppConstants.String.errorTitle, code: 0, userInfo: nil)
    
    func updateInfoProfile(mail: String,companyName: String, IsSearch: Bool,section: Int, with handler: @escaping ResponseCompletionClosure){
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
                            handler(self.parseInformationCompany(from: json), self.serviceError)
                        }
                    } catch {
                        handler(nil, self.serviceError)
                    }
                })
                
            }
        })
        dataTask.resume()
    }
    
    func parseInformationCompany(from responseDictionary: [String: Any]) -> Response  {
        var data = Response()
        var companies: [Company] = []
        data.status = responseDictionary["status"] as? String
        if let allCompanies = responseDictionary["message"] as? [Any] {
            for Ocompany in allCompanies {
                let oneCompany = Ocompany as? NSDictionary
                var getData = Company()
                getData.companyName = oneCompany?["company_name"] as? String
                getData.mail = oneCompany?["mail"] as? String
                getData.service = oneCompany?["service"] as? String
                getData.addressId = oneCompany?["id_address"] as? String
                getData.image = oneCompany?["image"] as? String
                getData.cellphone = oneCompany?["tel"] as? String
                getData.clientId = oneCompany?["id_client"] as? String
                
                companies.append(getData)
            }
        }
        
        if let message = responseDictionary["message"] as? String {
            data.message = message
        }
        data.allCompanies = companies
        return data
    }
    
}
