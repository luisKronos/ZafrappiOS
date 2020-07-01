//
//  updateImage_WS.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 5/6/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import Foundation
import UIKit

public class Updateimage_WS : NSObject {
    
    public typealias CompletionBlock = (_ dictLog : responseLogIn? , Error?) -> Void
    
    var root = basePath().path(Complement: "update_image_user")
    var serviceError = NSError(domain: "update_image", code: 0, userInfo: nil)
    
    public func upDateImage(Data: updateProfileImage , with handler : @escaping CompletionBlock){
            let headers = ["Content-Type": "application/x-www-form-urlencoded"]
           let imageSend = convertImageToBase64(image: Data.ImgProfile ?? UIImage ())
            let postData = NSMutableData(data: "mail=\(Data.strEmail ?? "")&image=\(imageSend)".data(using: String.Encoding.utf8)!)
        
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
    
    func convertImageToBase64(image: UIImage) -> String {
           let imageData = image.pngData()!
           return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
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
