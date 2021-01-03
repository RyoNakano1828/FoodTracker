//
//  Meal.swift
//  FoodTracker
//
//  Created by NeppsStaff on 2021/01/03.
//

import Foundation
import UIKit

class Meal {
    //MARK: Proparties
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int) {
        
        guard !name.isEmpty else {
            return nil
        }
        
        guard rating >= 0 && rating <= 5 else {
            return nil
        }
        //Initialize stored proparties
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}
