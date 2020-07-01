//
//  News_WS.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 20/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

public class getNews_WS : NSObject {
    
    public typealias CompletionBlock = (_ dictLog : responseLogIn? , Error?) -> Void
    
    var root = basePath().path(Complement: "get_news")
    var serviceError = NSError(domain: "Error", code: 0, userInfo: nil)
    
    public func getNews(interest: String , with handler : @escaping CompletionBlock){
            
            let headers = ["Content-Type": "application/x-www-form-urlencoded"]
            let getInformation = "interest=\(interest)"
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
                        }catch {
                            handler(nil, error)
                            }
                    })
                }
            })
            dataTask.resume()
    }
    
    func parseInformation (fromDicResponse dctResponse: [String : Any]) -> responseLogIn? {
        let data = responseLogIn ()
        var arrMov : [listaNews] = []
        data.strStatus = dctResponse["status"] as? String
        
        if let arrAllData = dctResponse["news"] as? NSArray {
            
        for mov in arrAllData {
            let dataNews = listaNews ()
            let dictionary = mov as! NSDictionary
            dataNews.strType               = dictionary["type"] as? String
            dataNews.strTitle              = dictionary["title"] as? String
            dataNews.strImage              = dictionary["image"] as? String
            dataNews.strPublish_date       = dictionary["publish_date"] as? String
            dataNews.strDescription        = dictionary["description"] as? String
            dataNews.strVideo              = dictionary["video"] as? String
            dataNews.strClient_id          = dictionary["client_id"] as? String
            dataNews.strUrl                = dictionary["url"] as? String
            
            arrMov.append(dataNews)
                
            }
            data.arrList = arrMov
         }
        
        return data
    }
}

