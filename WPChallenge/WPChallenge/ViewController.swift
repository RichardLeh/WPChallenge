//
//  ViewController.swift
//  WPChallenge
//
//  Created by Richard Leh on 21/12/2016.
//  Copyright © 2016 Richard Leh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "HostCell"
    var hosts = [Host]()
    var query:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getHost()
    }
    
    func getHost(){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Requests().requestApi(withQuery: query){ (result, error) in
            
            if let result = result as? Dictionary<String,Any>{
                
                if let hostsArr = result["hits"] as? [Dictionary<String, Any>]{
                    self.hosts = self.getHosts(fromArray: hostsArr)
                }
                /*for hostDic in result{
                 print(hostDic)
                 }*/
                
                updatesOnMain {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    self.tableView.reloadData()
                }
                
            } else{
                print(error)
            }
            
        }
    }
    
    func getHosts(fromArray hostsArr:[Dictionary<String, Any>]) -> [Host]{
        
        var hosts = [Host]()
        for hostDic in hostsArr{
            let host = Host.init(dictionary: hostDic)
            hosts.append(host)
        
        }
        return hosts
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// MARK: - ViewController: UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let host = hosts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HostListTableViewCell
        
        cell.titleLabel.text = host.title
        var cityCountry = ""
        if let city = host.city{
            cityCountry += city
        }
        if !(cityCountry.isEmpty){
           cityCountry += ", "
        }
        if let country = host.country{
            cityCountry += country
        }
        cell.cityLabel.text = cityCountry
        
        if let photoUrl = host.photoUrl{
            cell.photoImageView.image = nil
            cell.photoImageView.imageFromServerURL(urlString: photoUrl)
        }
        
        if let hostingSince = host.hostingSince{
            cell.hostingLabel.text = "Hosting since \(hostingSince.dateStringFormated)"
        }
        
        cell.accomodationLabel.text = host.accommodationTypeSlug?.replacingOccurrences(of: "_", with: " ").capitalized
        
        if let meals = host.mealsCount{
            cell.mealsLabel.text = String(meals)
        }
        if let wishList = host.wishListCount{
            cell.wishLabel.text = String(wishList)
        }
        if let trip = host.tripsCount{
            cell.tripLabel.text = String(trip)
        }
        if let price = host.price{
            cell.priceLabel.text = "US$ " + String(price)
        }
        
        if let rating = host.rating {
            cell.ratingLabel.text = String(repeating: "★", count: rating) + String(repeating: "☆", count: AppConstants.ratingMax.rawValue - rating)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hosts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let host = hosts[indexPath.row]
        //let controller = storyboard!.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        //controller.host = host
        //navigationController!.pushViewController(controller, animated: true)
    }
}
