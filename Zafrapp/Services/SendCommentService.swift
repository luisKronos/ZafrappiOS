//
//  SendCommentService.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 25/07/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation

public class SendCommentService: NSObject {
    
    var root = basePath().path(Complement: "add_comment")
    var serviceError = NSError(domain: AppConstants.String.errorTitle, code: 0, userInfo: nil)
    
    func sendComentario(id_news: Int, user_Id: Int, textcometaio: String, bisReply: Bool? = false , with handler: @escaping ResponseCompletionClosure){
        var getInformation = ""
        let getMail =  InformationClasify.sharedInstance.data
        let mail =  getMail?.messageResponse?.email ?? ""
        if bisReply! {
            root = basePath().path(Complement: "comment_reply")
            getInformation = "id_news=\(id_news)&id=\(user_Id)&text_comment=\(textcometaio)&mail=\(mail)&id_comment=\(id_news)"
        } else {
            getInformation = "id_news=\(id_news)&user_id=\(user_Id)&text_comment=\(textcometaio)"
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
        data.message  = responseDictionary["message"] as? String
        
        return data
    }
    
}
