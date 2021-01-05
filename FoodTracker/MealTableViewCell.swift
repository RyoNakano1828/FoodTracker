//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by NeppsStaff on 2021/01/04.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    //MARK: Proparties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
