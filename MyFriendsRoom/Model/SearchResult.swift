//
//  SearchResult.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 28.01.2019.
//  Copyright © 2019 UDx. All rights reserved.
//
import UIKit

class searchResult: NSObject, NSCoding {
    var name: String?
    var userId: String?
    var meetChecked: Bool?
    var dateChecked: Bool?
    var acceptingGuests: String?
    var email: String?
    var loc: String?
    var profileImageUrl: String?
    var occupation: String?
    var age: String?
    var inWishlist: Bool?
    var currentLoc: String?
    var priority: Int?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        name = dictionary["name"] as? String
        userId = dictionary["userId"] as? String
        meetChecked = dictionary["meetChecked"] as? Bool
        dateChecked = dictionary["dateChecked"] as? Bool
        acceptingGuests = dictionary["acceptingGuests"] as? String
        email = dictionary["email"] as? String
        loc = dictionary["loc"] as? String
        profileImageUrl = dictionary["profileImageUrl"] as? String
        occupation = dictionary["occupation"] as? String
        age = dictionary["age"] as? String
        inWishlist = dictionary["inWishlist"] as? Bool
        currentLoc = dictionary["currentLoc"] as? String
        priority = dictionary["priority"] as? Int
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as? String
        let userId = aDecoder.decodeObject(forKey: "userId") as? String
        let meetChecked = aDecoder.decodeObject(forKey: "meetChecked") as? Bool
        let dateChecked = aDecoder.decodeObject(forKey: "dateChecked") as? Bool
        let acceptingGuests = aDecoder.decodeObject(forKey: "acceptingGuests") as? String
        let email = aDecoder.decodeObject(forKey: "email") as? String
        let loc = aDecoder.decodeObject(forKey: "loc") as? String
        let profileImageUrl = aDecoder.decodeObject(forKey: "profileImageUrl") as? String
        let occupation = aDecoder.decodeObject(forKey: "occupation") as? String
        let age = aDecoder.decodeObject(forKey: "age") as? String
        let inWishlist = aDecoder.decodeObject(forKey: "inWishlist") as? Bool
        let currentLoc = aDecoder.decodeObject(forKey: "currentLoc") as? String
        let priority = aDecoder.decodeObject(forKey: "priority") as? String
        self.init(dictionary: ["name": name as AnyObject, "userId": userId as AnyObject, "meetChecked": meetChecked as AnyObject, "dateChecked": dateChecked as AnyObject, "acceptingGuests": acceptingGuests as AnyObject, "email": email as AnyObject, "loc": loc as AnyObject, "profileImageUrl": profileImageUrl as AnyObject, "occupation": occupation as AnyObject, "age": age as AnyObject, "inWishlist": inWishlist as AnyObject, "currentLoc": currentLoc as AnyObject, "priority": priority as AnyObject])
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(meetChecked, forKey: "meetChecked")
        aCoder.encode(dateChecked, forKey: "dateChecked")
        aCoder.encode(acceptingGuests, forKey: "acceptingGuests")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(loc, forKey: "loc")
        aCoder.encode(profileImageUrl, forKey: "profileImageUrl")
        aCoder.encode(occupation, forKey: "occupation")
        aCoder.encode(age, forKey: "age")
        aCoder.encode(inWishlist, forKey: "inWishlist")
        aCoder.encode(priority, forKey: "priority")
    }
}
