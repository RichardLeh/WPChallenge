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
    let noResultsCellIdentifier = "NoResultsCell"
    
    let heigthNoResults:CGFloat = 120.0
    let heigthHostCell:CGFloat = 420.0
    
    var cachedImages = [String: UIImage]()
    
    var hosts = [Host]()
    var query:String = ""
    
    var nextPage:String?
    var page:Int = 1
    
    var firstTime:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = query
        self.navigationController?.hidesBarsOnSwipe = true
        getHost()
    }
    
    func getHost(){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Requests().requestApiSearch(withQuery: query, withPage: page) { [weak self] (result, error) in
        
            if let weakSelf = self {
                weakSelf.firstTime = false
                
                if let result = result as? Dictionary<String,Any>{
                    
                    if let hostsArr = result[Server.worldPackersSearchJSONResponseKeys.hits] as? [Dictionary<String, Any>]{
                        weakSelf.hosts.append(contentsOf: weakSelf.getHosts(fromArray: hostsArr))
                        
                        weakSelf.cacheImages()
                    }
                    
                    if let nextPage = result[Server.worldPackersSearchJSONResponseKeys.nextPageUrl] as? String{
                        weakSelf.nextPage = nextPage
                    }else{
                        weakSelf.nextPage = nil
                    }
                    
                    updatesOnMain {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        weakSelf.tableView.reloadData()
                    }
                    
                } else{
                    print("something was wrong getting hosts information \(error)")
                }
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
    
    // MARK: Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppSegues.showDetail.rawValue  {
            if let viewController = segue.destination as? DetailViewController {
                if let hostId = sender as? Int{
                    viewController.hostId = "\(hostId)"
                }
            }
        }
    }
}

// MARK: - ViewController: UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if hosts.count > 0 {
        
            let host = hosts[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HostListTableViewCell
            
            self.setCellValues(forCell: cell, withHost: host)
            
            if hosts.count - 1 == indexPath.row + 1 && nextPage?.isEmpty == false {
                page = page + 1
                self.getHost()
            }
            
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: noResultsCellIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if firstTime {
            return 0
        }
        
        return (hosts.count == 0) ? 1 : hosts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let host = hosts[indexPath.row]
        self.performSegue(withIdentifier: AppSegues.showDetail.rawValue, sender: host.id)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (hosts.count > 0) ? heigthHostCell : heigthNoResults
    }
    
    func setCellValues(forCell cell:HostListTableViewCell, withHost host:Host){
        
        cell.titleLabel.text = host.title
        cell.titleLabel.textColor = UIColor(hexString: Colors.defaultColor.rawValue)
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
            cell.photoImageUrl = photoUrl
            if let image = cachedImages[photoUrl] {
                cell.photoImageView.image = image
            }else{
                cell.photoImageView.image = nil
                
                downloadImage(fromStringUrl: photoUrl, completionHandler: { [weak self] image in
                    if let weakSelf = self{
                        if let image = image {
                            weakSelf.cachedImages[photoUrl] = image
                            if cell.photoImageUrl == photoUrl{
                                cell.photoImageView.image = image
                                cell.layoutIfNeeded()
                                cell.setNeedsLayout()
                            }
                        }
                    }
                })
            }
        }
        else{
            cell.photoImageView.image = nil
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
            cell.priceLabel.backgroundColor = UIColor(hexString: Colors.defaultColor.rawValue)
        }
        if let rating = host.rating {
            cell.ratingLabel.text = String(repeating: "★", count: rating) + String(repeating: "☆", count: AppConstants.ratingMax.rawValue - rating)
        }
    }
}

// MARK: ViewController Image Cache Controll
extension ViewController {
    
    func cacheImages(){
        
        for host in hosts{
            if let photoUrl = host.photoUrl{
                if cachedImages[photoUrl] == nil {
                    downloadImage(fromStringUrl: photoUrl) { [weak self] (image) in
                        if let image = image {
                            self?.cachedImages[photoUrl] = image
                        }
                    }
                }
            }
        }
    }
}
