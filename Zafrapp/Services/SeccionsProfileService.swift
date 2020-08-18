//
//  SeccionsProfileService.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 07/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

class SeccionsProfileService: NSObject {
    
    var root = basePath().path(Complement: "update_data_user")
    var serviceError = NSError(domain: AppConstants.String.errorTitle, code: 0, userInfo: nil)
    
    func updateInfoProfile(data: UpdateData, seccion: Int , with handler: @escaping ResponseCompletionClosure){
        
        var getInformation = ""
        if seccion == EditProfilePickerType.state.rawValue || seccion == EditProfilePickerType.suburb.rawValue ||  seccion == EditProfilePickerType.street.rawValue {
            getInformation = "state=\(data.state ?? "")&municipio=\(data.suburb ?? "")&street=\(data.street ?? "")&number_st=\(data.streetNumber ?? "")&cp=\(data.zip ?? 0)&id_user=\(Int(data.userId ?? "") ?? 0)&id_address=\(Int(data.addressId ?? "") ?? 0)"
        } else if seccion == EditProfilePickerType.work.rawValue || seccion == EditProfilePickerType.interestArea.rawValue || seccion == EditProfilePickerType.ingenio.rawValue || seccion == EditProfilePickerType.department.rawValue  || seccion == EditProfilePickerType.interestOptional.rawValue || seccion == EditProfilePickerType.ingenioOptional.rawValue || seccion == EditProfilePickerType.departmentOptional.rawValue{
            let bSearch_job = (data.isSearchingWork ?? false) ? 1: 0
            getInformation =  "mail=\(data.email ?? "")&current_job=\(data.currentJob ?? "")&is_search_work=\(bSearch_job)&work_place=\(data.workPlace ?? "")&work_deparment=\(data.workDepartment ?? "")&interest=\(data.interest ?? "")"
        } else if seccion == EditProfilePickerType.officePhone.rawValue{
            getInformation = "mail=\(data.email ?? "")&number_office=\(data.officeNumber ?? 0)&ext=\(data.extension ?? 0)"
        } else if seccion == EditProfilePickerType.cell.rawValue{
            let bShareCell = (data.isCellShown ?? false) ? 1: 0
            getInformation = "mail=\(data.email ?? "")&celphone=\(data.cellphone ?? 0)&is_share_cel=\(bShareCell)"
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
