//
//  DetailViewController.swift
//  WPChallenge
//
//  Created by Richard Leh on 27/12/2016.
//  Copyright © 2016 Richard Leh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var photosScrollView: UIScrollView!
    @IBOutlet weak var photosPageControl: UIPageControl!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeCityCountryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var hostId:String?
    fileprivate var hostDetail:HostDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
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
                        
                        weakSelf.hostDetail = HostDetail(dictionary: result)
                        
                        updatesOnMain {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            
                            weakSelf.titleLabel.text = weakSelf.hostDetail?.title
                            //weakSelf.priceLabel.text = weakSelf.hostDetail?.price
                            
                            //weakSelf.ratingLabel.text = weakSelf.hostDetail?.ra
                        }
                        
                    } else{
                        print("something was wrong getting host information \(error)")
                    }
                }

            }
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
