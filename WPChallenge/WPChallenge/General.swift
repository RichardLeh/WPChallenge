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
                    // show default image
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

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
