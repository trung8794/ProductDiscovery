//
//  AppUtils.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/3/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import Foundation

/*
 * This class to define some common Functions in this App
 */

class AppUtils: NSObject {
    // Fuction to call  REst API to get data from service
    static func callCustomApi(_ url: String, completeAction: ((_ jsonData: String) -> ())?, errorAcion: ((_ error: String) -> ())? = nil) {
        print("\(AppUtils.getTimestamp()) - Request API: \n \(url)")
        // Set up the URL request
        let todoEndpoint: String = url
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 30
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                let strErr = "\(error!)"
                print(strErr)
                if let errorAct = errorAcion{
                    errorAct(strErr)
                }
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                if let errorAct = errorAcion{
                    errorAct("Error: did not receive data")
                }
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        if let errorAct = errorAcion{
                            errorAct("error trying to convert data to JSON")
                        }
                        return
                }
                
                // now we have the todo
                // let's just print it to prove we can access its
                
                let resultData = AppUtils.jsonToString(json: todo["result"] as AnyObject)
                let strData = "\(resultData)"
                
                // SHow logs to terminals
                print("\(AppUtils.getTimestamp())  - Respone from service for Request :\n\(url)\n\(strData)\n\n")
                
                // Process Completion Action when receive Data successfully
                if let completion = completeAction{
                    completion(strData)
                }
            } catch  {
                print("error trying to convert data to JSON")
                if let errorAct = errorAcion{
                    errorAct("error trying to convert data to JSON")
                }
                return
            }
        }
        task.resume()
    }
    
    
    // Timer functions
    static func getTimestamp() -> String {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        return timestamp
    }
    
    // Convert Json String from JsonObject
    static func jsonToString(json: AnyObject) -> String{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) ?? "" // the data will be converted to the string
            return convertedString
            
        } catch {
            return ""
        }
    }
}
