//: Playground - noun: a place where people can play

import UIKit

let rating = 3

let ratingString = String(repeating: "★", count: rating) + String(repeating: "☆", count: 5 - rating)
print(ratingString)



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

let strDate = "2016-12-12".dateStringFormated
//print(strDate)

let days = 2

var responseTime = ""

switch days {
case 0:
    responseTime = " less than a day"
case 1:
    responseTime = " 1 day"
default:
    responseTime = " \(days) days"
}

print(responseTime)