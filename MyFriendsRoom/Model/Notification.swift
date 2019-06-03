//
//  Notification.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 23.01.2019.
//  Copyright © 2019 UDx. All rights reserved.
//

import UIKit

class notification: NSObject {
    var name: String?
    var text: String?
    var timestamp: NSNumber?
    var seen: Bool?
    var profileImageUrl: String?
    var userId: String?
    var notificationID: String?
    init(dictionary: [String: AnyObject]) {
        super.init()
        text = dictionary["text"] as? String
        name = dictionary["name"] as? String
        profileImageUrl = dictionary["profileImageUrl"] as? String
        userId = dictionary["userId"] as? String
        notificationID = dictionary["notificationID"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        seen = dictionary["seen"] as? Bool
    }
}
