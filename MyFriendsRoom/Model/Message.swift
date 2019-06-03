//
//  Message.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 04.09.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    var messId: String?
    var sender: String?
    var readStatus: Int?
    var likeStatus: Bool?
    var date: String?
    var time: String?
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    init(dictionary: [String: AnyObject]) {
        super.init()
        fromId = dictionary["fromId"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        toId = dictionary["toId"] as? String
        messId = dictionary["messageId"] as? String
        sender = dictionary["sender"] as? String
        readStatus = dictionary["readStatus"] as? Int
        likeStatus = dictionary["likeStatus"] as? Bool
        date = dictionary["date"] as? String
        time = dictionary["time"] as? String
        
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        
        
    }
}
