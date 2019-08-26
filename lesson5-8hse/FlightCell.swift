//
//  FlightCell.swift
//  Lesson5Task
//
//  Created by Анастасия Распутняк on 16.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

class FlightCell: UITableViewCell {
    
    @IBOutlet weak var flightNumberLabel: UILabel!
    @IBOutlet weak var flightAirlineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
