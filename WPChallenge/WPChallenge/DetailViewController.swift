//
//  DetailViewController.swift
//  WPChallenge
//
//  Created by Richard Leh on 27/12/2016.
//  Copyright © 2016 Richard Leh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController {
    
    @IBOutlet var backgroundColoredViews: [UIView]!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    // photos
    @IBOutlet weak var photosScrollView: UIScrollView!
    @IBOutlet weak var photosPageControl: UIPageControl!
    
    // title
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeCityCountryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // the experience
    @IBOutlet weak var desciptionLabel: UILabel!
    
    // what we ask for
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var daysOffLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var stayLabel: UILabel!
    
    // map
    @IBOutlet weak var mapView: MKMapView!
    
    // the host
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var responseRateLabel: UILabel!
    @IBOutlet weak var hostDescriptionLabel: UILabel!
    @IBOutlet weak var responseTimeLabel: UILabel!
    
    @IBOutlet weak var lastStack: UIStackView!
    
    var hostId:String?
    //fileprivate var hostDetail:HostDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        clear()
        
        for view in backgroundColoredViews {
            view.backgroundColor = UIColor.clear
        }
    }
    
    func clear(){
        
        for v in photosScrollView.subviews{
            v.removeFromSuperview()
        }
        
        titleLabel.text = ""
        typeCityCountryLabel.text = ""
        ratingLabel.text = ""
        priceLabel.text = ""
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let hostId = hostId{
            Requests().requestApiDetail(withId: hostId){ [weak self] (result, error) in
                if let weakSelf = self {
                    
                    if let result = result as? Dictionary<String,Any>{
                        
                        let hostDetail = HostDetail(dictionary: result)
                        
                        updatesOnMain {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            
                            weakSelf.fillView(withHostDetail: hostDetail)
                        }
                        
                    } else{
                        print("something was wrong getting host information \(error)")
                    }
                }

            }
        }
    }
    
    func fillView(withHostDetail hostDetail:HostDetail){
        
        print(lastStack.frame.origin.y)
        print(lastStack.frame.size.height)
        
        // photos
        if let photosUrl = hostDetail.photos{
            
            let width = Int(photosScrollView.frame.size.width)
            let height = Int(photosScrollView.frame.size.height)
            
            for i in 0..<photosUrl.count{
                let uiPhoto = UIImageView()
                uiPhoto.contentMode = .scaleAspectFill
                uiPhoto.frame = CGRect(x: i * width, y: 0, width: width, height: height)
                photosScrollView.addSubview(uiPhoto)
                downloadImage(fromStringUrl: photosUrl[i], completionHandler: { [weak uiPhoto] image in
                    //if let weakSelf = self{
                    if let image = image {
                        //weakSelf.cachedImages[photoUrl] = image
                        uiPhoto?.image = image
                    }
                    //}
                })
            }
            photosPageControl.numberOfPages = photosUrl.count
            photosScrollView.contentSize = CGSize(width: width * photosUrl.count, height: 0)
        }

        // title
        titleLabel.text = hostDetail.title
        titleLabel.textColor = UIColor(hexString: Colors.defaultColor.rawValue)
        
        var typeCityCountry = ""
        if let type = hostDetail.type{
            typeCityCountry += type
        }
        if !(typeCityCountry.isEmpty){
            typeCityCountry += " • "
        }
        if let city = hostDetail.city{
            typeCityCountry += city
        }
        if !(typeCityCountry.isEmpty){
            typeCityCountry += ", "
        }
        if let country = hostDetail.country{
            typeCityCountry += country
        }
        typeCityCountryLabel.text = typeCityCountry

        if let rating = hostDetail.rating {
            ratingLabel.text = String(repeating: "★", count: rating) + String(repeating: "☆", count: AppConstants.ratingMax.rawValue - rating)
        }
        
        priceLabel.backgroundColor = UIColor(hexString: Colors.defaultColor.rawValue)
        if let price = hostDetail.price{
            priceLabel.text = "US$ " + String(price)
            
        }
        
        // the experience
        desciptionLabel.text = hostDetail.description
        
        // what we ask for
        
        if let hours = hostDetail.hours{
            hoursLabel.text = getValuePeriodString(from: hours)
        }
        if let daysOff = hostDetail.daysOff{
            daysOffLabel.text = String(daysOff)
        }
        var timeToStay = ""
        if let minimum = hostDetail.minimumTimeToStay{
            timeToStay = "At least " + getValuePeriodString(from: minimum)
        }
        if let maximum = hostDetail.maximumTimeToStay{
            if !timeToStay.isEmpty{
                timeToStay = timeToStay + "\r\n"
            }
            timeToStay = timeToStay + "Up to " + getValuePeriodString(from: maximum)
        }
        stayLabel.text = timeToStay
        if let requiredLanguages = hostDetail.requiredLanguages{
            languagesLabel.text = getLanguageProeficiency(from: requiredLanguages)
        }
        
        if let geolocation = hostDetail.geolocation{
            let annotation = MKPointAnnotation()
            annotation.coordinate = geolocation
            let span = MKCoordinateSpanMake(0.075, 0.075)
            let region = MKCoordinateRegion(center: geolocation, span: span)
            mapView.addAnnotation(annotation)
            mapView.setRegion(region, animated: false)
        }
        
        print(lastStack.frame.origin.y)
        print(lastStack.frame.size.height)
        
        print(self.view.frame.size.height)
        self.view.sizeToFit()
        print(self.view.frame.size.height)
    }
    
    func getValuePeriodString(from dic:Dictionary<String, Any>) -> String{
        if  let value = dic["value"] as? Int,
            let period = dic["period"] as? String {
            
            return String(value) + " " + period
        }
        
        return ""
    }
    
    func getLanguageProeficiency(from arrDic:[Dictionary<String, Any>]) -> String{
        var languagesString = ""
        
        for languageDic in arrDic{
            var langString = ""
            if let p = languageDic["proficiency"] as? Dictionary<String, Any>, let pName = p["name"] as? String{
                langString = pName
            }
            
            if let l = languageDic["language"] as? Dictionary<String, Any>, let lName = l["name"] as? String{
                if !langString.isEmpty{
                    langString = langString + " "
                }
                langString = langString + lName + "\r\n"
            }
            
            languagesString = languagesString + langString
        }
        
        if !languagesString.isEmpty{
            languagesString = languagesString.trim()
        }
        
        return languagesString
    }
}

extension DetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        photosPageControl.currentPage = Int(pageNumber)
    }
}

