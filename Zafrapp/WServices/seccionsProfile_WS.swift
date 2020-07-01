//
//  seccionsProfile_WS.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 07/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

public class SeccionsProfile_WS : NSObject {
    
    public typealias CompletionBlock = (_ dictLog : responseLogIn? , Error?) -> Void
    
    var root = basePath().path(Complement: "update_data_user")
    var serviceError = NSError(domain: "Error", code: 0, userInfo: nil)
    
    public func updateInfoProfile(Data: updateData, seccion : Int , with handler : @escaping CompletionBlock){
        
        var getInformation = ""
        if seccion == typeOfPickerEditProfile_Enum.Estado.rawValue || seccion == typeOfPickerEditProfile_Enum.Municipio.rawValue ||  seccion == typeOfPickerEditProfile_Enum.Calle.rawValue {
            getInformation = "state=\(Data.strState ?? "")&municipio=\(Data.strMunicipio ?? "")&street=\(Data.strStreet ?? "")&number_st=\(Data.strNumberStreet ?? "")&cp=\(Data.intCP ?? 0)&id_user=\(Int(Data.strId_user ?? "") ?? 0)&id_address=\(Int(Data.strId_Adress ?? "") ?? 0)"
        }else if seccion == typeOfPickerEditProfile_Enum.Trabajo.rawValue || seccion == typeOfPickerEditProfile_Enum.AreaDeInteres.rawValue || seccion == typeOfPickerEditProfile_Enum.Ingenio.rawValue || seccion == typeOfPickerEditProfile_Enum.departamento.rawValue  || seccion == typeOfPickerEditProfile_Enum.interesOpcional.rawValue || seccion == typeOfPickerEditProfile_Enum.optionaIngenio.rawValue || seccion == typeOfPickerEditProfile_Enum.optionalDepartment.rawValue{
             let bSearch_job = (Data.bIs_search_work ?? false) ? 1 : 0
           getInformation =  "mail=\(Data.strEmail ?? "")&current_job=\(Data.strCurrent_job ?? "")&is_search_work=\(bSearch_job)&work_place=\(Data.strWork_place ?? "")&work_deparment=\(Data.strWork_deparment ?? "")&interest=\(Data.strInterest ?? "")"
        }else if seccion == typeOfPickerEditProfile_Enum.PhoneOffice.rawValue{
           getInformation = "mail=\(Data.strEmail ?? "")&number_office=\(Data.intNumber_Office ?? 0)&ext=\(Data.intExt ?? 0)"
        }else if seccion == typeOfPickerEditProfile_Enum.Cell.rawValue{
            let bShareCell = (Data.bShow_Cell ?? false) ? 1 : 0
           getInformation = "mail=\(Data.strEmail ?? "")&celphone=\(Data.intCellPhone ?? 0)&is_share_cel=\(bShareCell)"
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
        data.strStatus = dctResponse["status"] as? String
        if let message = dctResponse["message"] as? String {
            data.strMessage = message
        }
        return data
    }
}
