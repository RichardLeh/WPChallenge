//
//  General.swift
//  WPChallenge
//
//  Created by Richard Leh on 21/12/2016.
//  Copyright © 2016 Richard Leh. All rights reserved.
//

import Foundation
import UIKit

func updatesOnMain(_ updatesToMake: @escaping () -> Void) {
    DispatchQueue.main.async {
        updatesToMake()
    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        if let urlDownload = URL(string: urlString){
            URLSession.shared.dataTask(with: urlDownload, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    //print(error)
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    self.image = image
                })
                
            }).resume()
        }
    }
}


extension String {
    
    var dateStringFormated: String{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: self)
            
            dateFormatter.dateFormat = "MMMM yyyy"
            let dateString = dateFormatter.string(from: date!)
            
            return dateString
        }
    }
}
