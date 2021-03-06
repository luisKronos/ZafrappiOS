//
//  CreateAccountService.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 5/5/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import Foundation

class CreateAccountService: NSObject {
    
    var root = BasePath.path(component: "create_user")
    var serviceError = NSError(domain: AppConstants.String.errorTitle, code: 0, userInfo: nil)
    
    func createAccount(data: RegisterAccount , with handler: @escaping ResponseCompletionClosure){
        let bSearch_job = (data.isSearchingJob ?? false) ? 1: 0
        let share_cell = (data.isCellphoneShared ?? false) ? 1: 0
        let getInformation = "name=\(data.name ?? "")&mail=\(data.email ?? "")&celphone=\(data.phone ?? 0)&is_share_cel=\(share_cell)&birthdate=\(data.birthdate ?? "")&current_job=\(data.currentJob ?? "")&is_search_work=\(bSearch_job)&work_place=\(data.workPlace ?? "")&work_deparment=\(data.workDepartment ?? "")&password=\(data.password ?? "")"
        
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
