//
//  DetailViewController.swift
//  WPChallenge
//
//  Created by Richard Leh on 27/12/2016.
//  Copyright © 2016 Richard Leh. All rights reserved.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {

    @IBOutlet weak var photosScrollView: UIScrollView!
    @IBOutlet weak var photosPageControl: UIPageControl!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeCityCountryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var hostId:String?
    //fileprivate var hostDetail:HostDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        clear()
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
            typeCityCountry += ", "
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
        
        if let price = hostDetail.price{
            priceLabel.text = "US$ " + String(price)
            priceLabel.backgroundColor = UIColor(hexString: Colors.defaultColor.rawValue)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
