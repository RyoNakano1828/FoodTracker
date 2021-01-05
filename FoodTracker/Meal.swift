//
//  Meal.swift
//  FoodTracker
//
//  Created by NeppsStaff on 2021/01/03.
//

import Foundation
import UIKit
import os.log

class Meal: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(photo, forKey: PropertyKey.photo)
        coder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal Object.", log: OSLog.default, type: .debug)
            return nil
        }
        let photo = coder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = coder.decodeInteger(forKey: PropertyKey.rating)
        
        self.init(name: name, photo: photo, rating: rating)
        
    }
    
    //MARK: Proparties
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
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
