//
//  HTTP.swift
//  wakerapper
//
//  Created by Shiv Kalola on 4/21/16.
//  Copyright © 2016 Nobel Apps. All rights reserved.
//

import UIKit

class HTTP: NSObject {
    
    /* HTTP POST REQUEST */
    func POST (url: String, requestJSON: NSData, postComplete: @escaping (_ success: Bool, _ msg: String) -> ()) {
        // Set up the request object
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.httpBody = requestJSON as Data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Initialize session object
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> () in
            
            if data == nil {
                postComplete(false, "ERROR")
                print("Error data is nil")
                return
            }
            
            let parsed = self.fromJSON(JSON: data! as NSData)
            if let responseData = parsed {
                let success = responseData["status"] as! String

                if (success == "Successfully uploaded!") {
                    postComplete(true, "SUCCESS")
                    print("\(responseData)")
                } else {
                    postComplete(false, "FAILURE")
                    print("\(responseData)")
                }
            } else {
                postComplete(false, "ERROR")
                print("Error in response!")
            }
        })
        task.resume()
    }
    
    /* JSON CONVERSION */
    
    func toJSON (dict: NSDictionary) -> NSData? {
        if JSONSerialization.isValidJSONObject(dict) {
            do {
                let json = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions())
                return json as NSData?
            } catch let error as NSError {
                print("ERROR: Unable to serialize json, error: \(error)")
            }
        }
        return nil
    }
    
    func fromJSON (JSON: NSData) -> NSDictionary? {
        do {
            return try JSONSerialization.jsonObject(with: JSON as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
        } catch {
            return nil
        }
    }

}
