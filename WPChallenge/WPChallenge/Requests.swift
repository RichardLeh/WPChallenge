//
//  Requests.swift
//  WPChallenge
//
//  Created by Richard Leh on 21/12/2016.
//  Copyright © 2016 Richard Leh. All rights reserved.
//

import Foundation

// https://staging-worldpackersplatform.herokuapp.com/api/search/?q=BR&page=1
// https://staging-worldpackersplatform.herokuapp.com/api/search?page=2&per_page=20&q=
// https://staging-worldpackersplatform.herokuapp.com/api/volunteer_positions/10

typealias CompletionResultError = (_ result: Any?, _ error: NSError?) -> Void

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
    
    func requestApiDetail(withId id:String, completion: @escaping CompletionResultError){
        let detailHostURL = hostListURLFromParameters(nil, withMethod: Server.worldpackersApi.apiMethodDetail + id)
        
        requestApi(withUrl: detailHostURL, completion: completion)
    }
    func requestApiSearch(withQuery query:String, withPage page:Int = 1, completion: @escaping CompletionResultError){
        let requestParameters = [Server.worldpackersApiKeysSearch.query: query,
                                 Server.worldpackersApiKeysSearch.page: page] as [String:Any]
        
        let hostsURL = hostListURLFromParameters(requestParameters, withMethod: Server.worldpackersApi.apiMethodSearch)
        
        requestApi(withUrl: hostsURL, completion: completion)
    }
    
    func requestApi(withUrl url:URL, completion: @escaping CompletionResultError){
        
        let request = addHeaders(on: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            /*
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
            */
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                //sendError("No data was returned by the request!")
                return
            }
 
            // parse the data
            var jsonDictionary:Dictionary<String, Any>
            do {
                jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                //sendError("Could not parse the data as JSON: '\(data)'")
                return
            }
            completion(jsonDictionary, nil)
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
    
    private func hostListURLFromParameters(_ parameters: [String:Any]?, withMethod method:String) -> URL {
        
        var components = URLComponents()
        components.scheme = Server.worldpackersApi.apiScheme
        components.host = Server.worldpackersApi.apiHost
        components.path = Server.worldpackersApi.apiPath + method
        
        if let parameters = parameters{
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
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
