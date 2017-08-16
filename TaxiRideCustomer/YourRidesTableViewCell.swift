//
//  YourRidesTableViewCell.swift
//  TaxiRideCustomer
//
//  Created by Umesh Chauhan on 08/08/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit

class YourRidesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDropAtAdd: UILabel!
    @IBOutlet weak var lblPickUpAdd: UILabel!
    @IBOutlet weak var dropAtDot: UIView!
    @IBOutlet weak var pickUpDot: UIView!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblRideInfo: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var imgDriver: UIImageView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var imgCancel: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
