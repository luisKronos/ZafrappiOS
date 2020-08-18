//
//  Comments_WS.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 25/07/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

class CommentService: NSObject {
    
    var root = basePath().path(Complement: "show_comments")
    var serviceError = NSError(domain: AppConstants.String.errorTitle, code: 0, userInfo: nil)
    
    func obtainComents(id_news: Int, isReply: Bool? = false , with handler: @escaping ResponseCompletionClosure){
        var getInformation = ""
        if isReply ?? false {
            root = basePath().path(Complement: "show_replies")
            getInformation = "id_comment=\(id_news)"
        } else {
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
                            handler(self.parseInformation(from: json, bShowResponse: isReply!), self.serviceError)
                        }
                    } catch {
                        handler(nil, self.serviceError)
                    }
                })
                
            }
        })
        dataTask.resume()
    }
    
    
    func parseInformation(from responseDictionary: [String: Any], bShowResponse: Bool) -> Response? {
        var data = Response()
        var arrComments: [Comment] = []
        data.status = responseDictionary["status"] as? String
        if let status = responseDictionary["message"] as? [Any]{
            for coment in status {
                let data = coment as? [String: Any]
                var comment = Comment()
                comment.commentId = data?["id_comment"] as? String
                comment.text = data?["text_comment"] as? String
                comment.newsId = data?["id_news"] as? String
                comment.clientId = data?["id_client"] as? String
                comment.userId = data?["id_user"] as? String
                comment.replyComment = data?["reply_comment"] as? String
                comment.date = data?["date"] as? String
                comment.image = data?["image"] as? String
                comment.name = data?["name"] as? String
                comment.hasCommentsString = data?["HasComments"] as? String
                
                comment.userImageString = data?["user_image"] as? String
                comment.companyName = data?["company_name"] as? String
                comment.clientImageString = data?["client_image"] as? String
                comment.isAnswerShown = bShowResponse
                arrComments.append(comment)
            }
        }
        
        data.comments = arrComments
        return data
    }
    
}
