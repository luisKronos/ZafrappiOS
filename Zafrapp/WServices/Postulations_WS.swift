//
//  Postulations_WS.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 20/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

public class getPostulations_WS : NSObject {
    
    public typealias CompletionBlock = (_ dictLog : responseLogIn? , Error?) -> Void
    
    var root = basePath().path(Complement: "get_positions")
    var serviceError = NSError(domain: "Error", code: 0, userInfo: nil)
    
    public func obtainPostulations(mail: String, status : Int? = 0 , id_user : Int? = 0, with handler : @escaping CompletionBlock){
          var getInformation = ""
        if status == 0 {
           getInformation = "mail=\(mail)"
        }else {
            getInformation = "mail=\(mail)&status=\(status ?? 0)&id_user=\(id_user ?? 0)"
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
                        handler(self.parseInformation(fromDicResponse: json, status: status ?? 0), self.serviceError)
                        }
                    } catch {
                            handler(nil, self.serviceError)
                        }
                    })
               
                }
            })
            dataTask.resume()
    }
    
    func getMinAndmaxSalari (salary : String) -> [Int] {
        var stre = salary
        stre = stre.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range:nil)
        let component = stre.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let list = component.filter({ $0 != "" })
        let uno = Int(list.first ?? "0")
        let dos = Int(list.last ?? "0")
        
        return [uno!,dos!]
    }
    
    func parseInformation (fromDicResponse dctResponse: [String : Any], status : Int) -> responseLogIn? {
              let data = responseLogIn ()
              var allPostulations : [postulations] = []
              data.strStatus = dctResponse["status"] as? String
              
              if let arrAllPostulations = dctResponse["vacants"] as? NSArray {
                for postulation in arrAllPostulations {
                    let dataUser = postulation as? NSDictionary
                    let dataJob = postulations()
                    
                    dataJob.strVacant       = dataUser?["id_vacant"] as? String
                    dataJob.strPosition      = dataUser?["position"] as? String
                    dataJob.strWork_Place     = dataUser?["work_place"] as? String
                    dataJob.strRange_Salary    = dataUser?["range_salary"] as? String
                    dataJob.strPucblishDate       = dataUser?["publish_date"] as? String
                    dataJob.strInterest_Area   = dataUser?["interest_area"] as? String
                    dataJob.strDescription            = dataUser?["description"] as? String
                    dataJob.strActivities     = dataUser?["activities"] as? String
                    dataJob.strRequirements       = dataUser?["requirements"] as? String
                    dataJob.strSchedule_work      = dataUser?["schedule_work"] as? String
                    dataJob.strWorking_time     = dataUser?["working_time"] as? String
                    dataJob.strStatus    = dataUser?["status"] as? String
                    dataJob.strId_Ingenio       = dataUser?["id_ingenio"] as? String
                    dataJob.strImage   = dataUser?["image"] as? String
                    dataJob.strName            = dataUser?["name"] as? String
                    dataJob.strState     = dataUser?["state"] as? String
                    let rangeSalari  = dataUser?["range_salary"] as? String ?? ""
                    let range = getMinAndmaxSalari (salary : rangeSalari)
                    dataJob.minSalari = range.first ?? 10
                    dataJob.maxSalari = range.last ?? 20
                    if status == 1 || status == 2 {
                     dataJob.bisSaved     = true
                    }
                    allPostulations.append(dataJob)
                  }
                
                  
               }
              data.allVacants = allPostulations
        
              if let message = dctResponse["message"] as? String {
                  data.strMessage = message
              }
              
              return data
          }
      
}
