//: Playground - noun: a place where people can play

import UIKit

let rating = 1

let ratingString = String(repeating: "★", count: rating) + String(repeating: "☆", count: 5 - rating)
print(ratingString)