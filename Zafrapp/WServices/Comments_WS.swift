//
//  Comments_WS.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 25/07/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

public class getAllComments_WS : NSObject {

 typealias CompletionBlock = (_ dictLog : responseLogIn? , Error?) -> Void

    var root = basePath().path(Complement: "show_comments")
    var serviceError = NSError(domain: "Error", code: 0, userInfo: nil)

 func obtainComents(id_news : Int, bIsReply : Bool? = false , with handler : @escaping CompletionBlock){
    var getInformation = ""
    if bIsReply ?? false {
        root = basePath().path(Complement: "show_replies")
        getInformation = "id_comment=\(id_news)"
    }else {
        getInformation = "id_news=\(id_news)"
       
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
                    handler(self.parseInformation(fromDicResponse: json, bShowResponse: bIsReply!), self.serviceError)
                    }
                } catch {
                        handler(nil, self.serviceError)
                    }
                })
           
            }
        })
        dataTask.resume()
}

    
    func parseInformation (fromDicResponse dctResponse: [String : Any], bShowResponse : Bool) -> responseLogIn? {
              let data = responseLogIn ()
             var arrComments : [comment] = []
            data.strStatus = dctResponse["status"] as? String
        if let status = dctResponse["message"] as? NSArray{
                for coment in status {
                    let data = coment as? [String : Any]
                    let commentario = comment ()
                    commentario.id_comment = data?["id_comment"] as? String
                    commentario.text_comment = data?["text_comment"] as? String
                    commentario.id_news = data?["id_news"] as? String
                    commentario.id_client = data?["id_client"] as? String
                    commentario.id_user = data?["id_user"] as? String
                    commentario.reply_comment = data?["reply_comment"] as? String
                    commentario.date = data?["date"] as? String
                    commentario.image = data?["image"] as? String
                    commentario.name = data?["name"] as? String
                    commentario.HasComments = data?["HasComments"] as? String
                    
                    commentario.user_image = data?["user_image"] as? String
                    commentario.company_name = data?["company_name"] as? String
                    commentario.client_image = data?["client_image"] as? String
                    commentario.bShowAnswer = bShowResponse
                    arrComments.append(commentario)
                }
              }
              
          data.allComment = arrComments
          return data
          }
      
}
