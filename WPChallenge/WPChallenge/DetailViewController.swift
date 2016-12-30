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
    @IBOutlet weak var hostResponseRateLabel: UILabel!
    @IBOutlet weak var hostResponseTimeLabel: UILabel!
    @IBOutlet weak var hostDescriptionLabel: UILabel!
    @IBOutlet weak var hostPhotoImageView: UIImageView!
    
    @IBOutlet weak var mapStack: UIStackView!
    @IBOutlet weak var lastStack: UIStackView!
    @IBOutlet weak var viewView: UIView!
    
    @IBOutlet weak var mapHeigthLayout: NSLayoutConstraint!
    
    var hostId:String? = "23"
    //fileprivate var hostDetail:HostDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        clear()
        
        for view in backgroundColoredViews {
            view.backgroundColor = UIColor.clear
        }
        print(viewView.frame.size)
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
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            Requests().requestApiDetail(withId: hostId){ [weak self] (result, error) in
                if let weakSelf = self {
                    
                    if let result = result as? Dictionary<String,Any>{
                        
                        print(result)
                        
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
                    if let image = image {
                        uiPhoto?.image = image
                    }
                })
            }
            photosPageControl.numberOfPages = photosUrl.count
            photosScrollView.contentSize = CGSize(width: width * photosUrl.count, height: 0)
        }

        // title
        titleLabel.text = hostDetail.title
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
            if let tupleHours = getValuePeriodString(from: hours){
                if tupleHours.0 == 1{
                    hoursLabel.text = String(tupleHours.0) + " hour/" + tupleHours.1
                }
                else{
                    hoursLabel.text = String(tupleHours.0) + " hours/" + tupleHours.1
                }
            }
        }
        if let daysOff = hostDetail.daysOff{
            if daysOff == 1{
                daysOffLabel.text = String(daysOff) + " day off"
            }
            else{
                daysOffLabel.text = String(daysOff) + " days off"
            }
        }
        var timeToStay = ""
        if let minimum = hostDetail.minimumTimeToStay{
            if let atLeast = getValuePeriodString(from: minimum){
                timeToStay = "At least \(atLeast.0) \(atLeast.1)"
            }
        }
        if let maximum = hostDetail.maximumTimeToStay{
            if !timeToStay.isEmpty{
                timeToStay = timeToStay + "\r\n"
            }
            if let upTo = getValuePeriodString(from: maximum){
                timeToStay = "Up to \(upTo.0) \(upTo.1)"
            }
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
        else{
            mapHeigthLayout.isActive = false
            //mapView.heightAnchor.constraint(equalToConstant: 1)
        }
        
        //host
        if let hostName = hostDetail.hostName{
            hostNameLabel.text = hostName
        }
        if let hostResponseRate = hostDetail.hostResponseRate{
            hostResponseRateLabel.text = String(Int(hostResponseRate)) + "%"
        }
        if let hostResponseTime = hostDetail.hostResponseTime{
            let date = Date(timeIntervalSince1970: hostResponseTime)
            hostResponseTimeLabel.text = "\(date)"
        }
        if let hostDescription = hostDetail.hostDescription{
            hostDescriptionLabel.text = hostDescription
        }
        if let hostPhotoUrl = hostDetail.hostPhotoUrl{
            downloadImage(fromStringUrl: hostPhotoUrl, completionHandler: { [weak hostPhotoImageView] image in
                if let image = image {
                    hostPhotoImageView?.image = image
                }
            })
        }
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateSizeScroll), userInfo: nil, repeats: false);
        
    }
    func updateSizeScroll(){
        self.scrollView.contentSize = CGSize(width: 0, height: viewView.frame.size.height)
        
    }
    func getValuePeriodString(from dic:Dictionary<String, Any>) -> (Int, String)?{
        if  let value = dic["value"] as? Int,
            let period = dic["period"] as? String {
            
            return (value, period)
        }
        
        return nil
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
        if scrollView == self.photosScrollView{
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            photosPageControl.currentPage = Int(pageNumber)
        }
        print(viewView.frame.size)
    }
}

