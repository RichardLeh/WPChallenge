//
//  Requests.swift
//  WPChallenge
//
//  Created by Richard Leh on 21/12/2016.
//  Copyright © 2016 Richard Leh. All rights reserved.
//

import Foundation

class Requests: NSObject{
    
    var session = URLSession.shared
    
    class func sharedInstance() -> Requests {
        struct Singleton {
            static var sharedInstance = Requests()
        }
        return Singleton.sharedInstance
    }
    
    override init() {
        super.init()
    }
    
    func requestApi(withQuery query:String, and page:Int = 1, completion: @escaping (_ result: Any?, _ error: NSError?) -> Void){
        let requestParameters = [Server.worldpackersApiKeys.query: query,
                                 Server.worldpackersApiKeys.page: page] as [String:Any]
        
        let movieURL = movieListURLFromParameters(requestParameters)
        let request = addHeaders(on: movieURL)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "requestApi", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // parse the data            
            do {
                //jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                
                let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,AnyObject>
                print(jsonDictionary)
                completion(jsonDictionary, nil)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                sendError("Could not parse the data as JSON: '\(data)'")
                return
            }
        }
        
        task.resume()
        
    }
    
    func showError(_ error: String){
        print(error)
        
        updatesOnMain{
            // TODO
            // FIX.ME("Atualizar a UI")
        }
    }
    
    private func movieListURLFromParameters(_ parameters: [String:Any]) -> URL {
        
        var components = URLComponents()
        components.scheme = Server.worldpackersApi.apiScheme
        components.host = Server.worldpackersApi.apiHost
        components.path = Server.worldpackersApi.apiPath + Server.worldpackersApi.apiMethod
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    private func addHeaders(on url:URL) -> URLRequest{
        var request = URLRequest(url: url)
        request.setValue(Server.worldPackersHeadersValues.accept, forHTTPHeaderField: Server.worldPackersHeadersKeys.accept)
        request.setValue(Server.worldPackersHeadersValues.authorization, forHTTPHeaderField: Server.worldPackersHeadersKeys.authorization)
        return request
    }
}
