//
//  HostListTableViewCell.swift
//  WPChallenge
//
//  Created by Richard Leh on 23/12/2016.
//  Copyright © 2016 Richard Leh. All rights reserved.
//

import UIKit

class HostListTableViewCell: UITableViewCell {
    
    @IBOutlet var backgroundColoredViews: [UIView]!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var hostingLabel: UILabel!
    
    @IBOutlet weak var accomodationLabel: UILabel!
    @IBOutlet weak var mealsLabel: UILabel!
    @IBOutlet weak var wishLabel: UILabel!
    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        clear()
        
        for view in backgroundColoredViews {
            view.backgroundColor = UIColor.clear
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clear()
    }
    
    func clear(){
        
        photoImageView.image = nil
        
        titleLabel.text = ""
        cityLabel.text = ""
        ratingLabel.text = ""
        hostingLabel.text = ""
        accomodationLabel.text = ""
        mealsLabel.text = ""
        wishLabel.text = ""
        tripLabel.text = ""
        priceLabel.text = ""
    }
}
