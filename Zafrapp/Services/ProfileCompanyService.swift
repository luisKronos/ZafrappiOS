//
//  ProfileCompanyService.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 02/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

class ProfileCompanyService: NSObject {
    
    var root = BasePath.path(component: "get_companies")
    var serviceError = NSError(domain: AppConstants.String.errorTitle, code: 0, userInfo: nil)
    
    func updateInfoProfile(mail: String, clienID: String, isIngenio: Bool , with handler: @escaping ResponseCompletionClosure){
        var getInformation = ""
        if isIngenio {
            root = BasePath.path(component: "get_ingenio")
            getInformation =  "mail=\(mail)&id_ingenio=\(clienID)"
        } else {
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
                                handler(self.parseInformationIngenio(from: json), self.serviceError)
                            } else {
                                handler(self.parseInformation(from: json), self.serviceError)
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
    
    func parseInformation(from responseDictionary: [String: Any]) -> Response? {
        var company: [CompanyDetail] = []
        var data = Response()
        data.status = responseDictionary["status"] as? String
        
        if  let arrCompany = responseDictionary["message"] as? [Any]{
            for mov in arrCompany {
                let movs = mov as! NSDictionary
                var detail = CompanyDetail()
                detail.description = movs["description"] as? String
                detail.state = movs["state"] as? String
                detail.suburb = movs["municipio"] as? String
                detail.clientId = movs["id_client"] as? String
                detail.addressId = movs["id_address"] as? String
                detail.street = movs["street"] as? String
                detail.companyName = movs["company_name"] as? String
                detail.contractName = movs["name_contact"] as? String
                detail.image = movs["image"] as? String
                detail.stNumber = movs["number_st"] as? String
                detail.service = movs["service"] as? String
                detail.zip = movs["cp"] as? String
                detail.telephone = movs["tel"] as? String
                detail.map = movs["maps"] as? String
                detail.mail = movs["mail"] as? String
                
                company.append(detail)
            }
            data.companyDetail = company[0]
        }
        return data
    }
    
    func parseInformationIngenio(from responseDictionary: [String: Any]) -> Response? {
        var company: [CompanyDetail] = []
        var data = Response()
        data.status = responseDictionary["status"] as? String
        
        if  let arrCompany = responseDictionary["message"] as? [Any]{
            for mov in arrCompany {
                let movs = mov as! NSDictionary
                var detail = CompanyDetail()
                detail.description = movs["description"] as? String
                detail.state = movs["state"] as? String
                detail.suburb = movs["municipio"] as? String
                detail.clientId = movs["id_client"] as? String
                detail.addressId = movs["id_address"] as? String
                detail.street = movs["street"] as? String
                detail.companyName = movs["company_name"] as? String
                detail.contractName = movs["name"] as? String
                detail.image = movs["image"] as? String
                detail.stNumber = movs["number_st"] as? String
                detail.service = movs["service"] as? String
                detail.zip = movs["cp"] as? String
                detail.telephone = movs["tel"] as? String
                detail.map = movs["maps"] as? String
                detail.mail = movs["mail"] as? String
                
                company.append(detail)
            }
            data.companyDetail = company[0]
        }
        return data
    }
    
}
