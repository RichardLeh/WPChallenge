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
    
    @IBOutlet weak var photosScrollView: UIScrollView!
    @IBOutlet weak var photosPageControl: UIPageControl!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeCityCountryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var desciptionLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
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
    }
}

extension DetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        photosPageControl.currentPage = Int(pageNumber)
    }
}

