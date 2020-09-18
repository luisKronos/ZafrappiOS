//
//  Postulations_WS.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 20/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

class PostulationService: NSObject {
    
    var root = BasePath.path(component: "get_positions")
    var serviceError = NSError(domain: AppConstants.String.errorTitle, code: 0, userInfo: nil)
    
    func obtainPostulations(mail: String, status: Int? = 0 , userId: Int? = 0, with handler: @escaping ResponseCompletionClosure){
        var getInformation = ""
        if status == 0 {
            getInformation = "mail=\(mail)"
        } else {
            getInformation = "mail=\(mail)&status=\(status ?? 0)&id_user=\(userId ?? 0)"
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
                            handler(self.parseInformation(from: json, status: status ?? 0), self.serviceError)
                        }
                    } catch {
                        handler(nil, self.serviceError)
                    }
                })
                
            }
        })
        dataTask.resume()
    }
    
    func getMinAndmaxSalari(salary: String) -> [Int] {
        var stre = salary
        stre = stre.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range:nil)
        let component = stre.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let list = component.filter({ $0 != "" })
        let uno = Int(list.first ?? "0")
        let dos = Int(list.last ?? "0")
        
        return [uno!,dos!]
    }
    
    func parseInformation(from responseDictionary: [String: Any], status: Int) -> Response? {
        var data = Response()
        var allPostulations: [Postulation] = []
        data.status = responseDictionary["status"] as? String
        
        if let arrAllPostulations = responseDictionary["vacants"] as? [Any] {
            for postulation in arrAllPostulations {
                let dataUser = postulation as? NSDictionary
                let dataJob = Postulation()
                
                dataJob.vacant       = dataUser?["id_vacant"] as? String
                dataJob.position      = dataUser?["position"] as? String
                dataJob.workPlace     = dataUser?["work_place"] as? String
                dataJob.salaryRange    = dataUser?["range_salary"] as? String
                dataJob.publishedDate       = dataUser?["publish_date"] as? String
                dataJob.interestArea   = dataUser?["interest_area"] as? String
                dataJob.description            = dataUser?["description"] as? String
                dataJob.activities     = dataUser?["activities"] as? String
                dataJob.requirements       = dataUser?["requirements"] as? String
                dataJob.scheduleWork      = dataUser?["schedule_work"] as? String
                dataJob.workingTime     = dataUser?["working_time"] as? String
                dataJob.status    = dataUser?["status"] as? String
                dataJob.ingenioId       = dataUser?["id_ingenio"] as? String
                dataJob.image   = dataUser?["image"] as? String
                dataJob.name            = dataUser?["name"] as? String
                dataJob.state     = dataUser?["state"] as? String
                let rangeSalari  = dataUser?["range_salary"] as? String ?? ""
                let range = getMinAndmaxSalari (salary: rangeSalari)
                dataJob.salaryMinimum = range.first ?? 10
                dataJob.salaryMaximum = range.last ?? 20
                if status == 1 || status == 2 {
                    dataJob.isSaved     = true
                }
                allPostulations.append(dataJob)
            }
            
            
        }
        data.vacants = allPostulations
        
        if let message = responseDictionary["message"] as? String {
            data.message = message
        }
        
        return data
    }
    
}
