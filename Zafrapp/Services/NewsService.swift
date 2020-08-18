//
//  NewsService.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 20/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

class NewsService: NSObject {
    
    var root = basePath().path(Complement: "get_news")
    var serviceError = NSError(domain: AppConstants.String.errorTitle, code: 0, userInfo: nil)
    
    func newsList(interest: String , with handler: @escaping ResponseCompletionClosure){
        
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
                            handler(self.parseInformation(from: json), self.serviceError)
                        }
                    }catch {
                        handler(nil, error)
                    }
                })
            }
        })
        dataTask.resume()
    }
    
    func parseInformation(from responseDictionary: [String: Any]) -> Response? {
        var data = Response()
        var arrMov: [NewsList] = []
        data.status = responseDictionary["status"] as? String
        
        if let arrAllData = responseDictionary["news"] as? [Any] {
            
            for mov in arrAllData {
                guard let dictionary = mov as? [AnyHashable: Any] else {
                    continue
                }
                
                var dataNews = NewsList()
                dataNews.type = dictionary["type"] as? String
                dataNews.title = dictionary["title"] as? String
                dataNews.image = dictionary["image"] as? String
                dataNews.publishedDate = dictionary["publish_date"] as? String
                dataNews.description = dictionary["description"] as? String
                dataNews.video = dictionary["video"] as? String
                dataNews.clientId = dictionary["client_id"] as? String
                dataNews.url = dictionary["url"] as? String
                dataNews.intNews = dictionary["id_news"] as? String
                
                arrMov.append(dataNews)
                
            }
            data.newsListArray = arrMov
        }
        
        return data
    }
}

