//
//  NotificationCell.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 28.11.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase

class NotificationCell: UITableViewCell {
    let wishlistController = WishlistController()
    var item = Int()
    var notofication: notification?{
        didSet {
            setData()
        }
    }
    override func layoutSubviews() {
        //textLabel?.text = "...%usernaasdasme%..."
        super.layoutSubviews()
        setData()
//        NotificationCenter.default.addObserver(self, selector: #selector(resetSeen), name: NSNotification.Name(rawValue: "reloadNotificationSeenStatus"), object: nil)
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 20, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyavatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let newBadge: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 13)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = CustomColors.commonGrey1
        tv.isEditable = false
        tv.isUserInteractionEnabled = false
        return tv
    }()
    //    let addButton: UIButton = {
    //        let button = UIButton()
    //        button.setTitle("add friend", for: .normal)
    //        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        button.setTitleColor(CustomColors.commonBlue1, for: .normal)
    //        button.addTarget(self, action: #selector(WishlistController.addFriend), for: .touchUpInside)
    //        return button
    //    }()
    let viewButton: UIButton = {
        let button = UIButton()
        button.setTitle("view", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(CustomColors.commonBlue1, for: .normal)
        button.addTarget(self, action: #selector(WishlistController.viewProfile), for: .touchUpInside)
        return button
    }()
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("clear", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(CustomColors.commonBlue1, for: .normal)
        button.addTarget(self, action: #selector(WishlistController.deleteFromWishlist), for: .touchUpInside)
        return button
    }()
    func setTimeAgo(time: Int) -> String {
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week =  7 * day
        let month = 30 * day
        let year = 12 * month
        let timeInt = time
        let nowInt = Int(Date().timeIntervalSince1970)
        let timeInterval = nowInt - timeInt
        var agoString = String()
        if timeInterval < minute{
            agoString = "\(timeInterval) seconds ago"
        } else if timeInterval < hour {
            agoString = "\(timeInterval / minute) minutes ago"
        } else if timeInterval < day {
            agoString = "\(timeInterval / hour) hours ago"
        } else if timeInterval < week {
            agoString = "\(timeInterval / day) days ago"
        } else if timeInterval < month {
            agoString = "\(timeInterval / week) weeks ago"
        } else if timeInterval < year {
            agoString = "\(timeInterval / month) month ago"
        } else if timeInterval > year {
            agoString = "\(timeInterval / year) years ago"
        }
        return agoString
    }
//    @objc func resetSeen() {
//        let arrayIndexPathItem = notificationsArray[item] as AnyObject
//        let seen = arrayIndexPathItem.value(forKey: "seen") as? Bool
//        if seen == false {
//            newBadge.text = "NEW"
//        } else {
//            newBadge.text = ""
//        }
//    }
    func setData(){
        textLabel?.textColor = CustomColors.commonGrey1
        textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        print("ThisIsItem==: ", item)
//        let arrayIndexPathItem = notificationsArray[item] as AnyObject
//        let input_name = arrayIndexPathItem.value(forKey: "name") as? String
//        let profileImageUrl = arrayIndexPathItem.value(forKey: "profileImageUrl") as? String
//        let time = arrayIndexPathItem.value(forKey: "timestamp") as! Int
//        let text = arrayIndexPathItem.value(forKey: "text") as? String
//        let seen = arrayIndexPathItem.value(forKey: "seen") as? Bool
        let input_name = notofication?.name
        let profileImageUrl = notofication?.profileImageUrl
        let time = notofication?.timestamp
        let text = notofication?.text
        let seen = notofication?.seen
        print("input_name: ", input_name, ", profileImageUrl: ", profileImageUrl, ", time: ", time, ", text: ", text, ", seen: ", seen)
//        notofication = notifArray[item] as AnyObject as! notification.Type
//        let input_name = self.notofication.name //arrayIndexPathItem.value(forKey: "name") as? String
//        let profileImageUrl = arrayIndexPathItem.value(forKey: "profileImageUrl") as? String
//        let time = arrayIndexPathItem.value(forKey: "timestamp") as! Int
//        let text = arrayIndexPathItem.value(forKey: "text") as? String
//        let seen = arrayIndexPathItem.value(forKey: "seen") as? Bool
        textLabel?.text = input_name
        timeLabel.text = setTimeAgo(time: time as! Int)
        if profileImageUrl == "empty" {
            profileImageView.image = UIImage(named: "emptyavatar")
        } else if profileImageUrl == "deleted" {
            profileImageView.image = UIImage(named: "deletedprofile")
        } else if profileImageUrl == "admin" {
            profileImageView.image = UIImage(named: "profile")
        } else {
            profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
        }
        deleteButton.tag = item
        viewButton.tag = item
        textView.text = text
        if seen == false {
            newBadge.text = " NEW "
            newBadge.backgroundColor = CustomColors.lightOrange1
        } else {
            newBadge.text = ""
            newBadge.backgroundColor = UIColor.clear
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        addSubview(newBadge)
        //        addSubview(addButton)
        addSubview(viewButton)
        addSubview(textView)
        addSubview(deleteButton)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        newBadge.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        newBadge.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10).isActive = true
        newBadge.widthAnchor.constraint(equalToConstant: 35).isActive = true
        newBadge.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        //        addButton.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 0).isActive = true
        //        addButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        //        addButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        //        addButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        //        addButton.titleLabel?.bottomAnchor.constraint(equalTo: addButton.bottomAnchor).isActive = true
        
        //        viewButton.leftAnchor.constraint(equalTo: addButton.rightAnchor).isActive = true
        
        textView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7).isActive = true
        textView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 4).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 25).isActive = true;
        
        viewButton.leftAnchor.constraint(equalTo: profileImageView.rightAnchor).isActive = true
        viewButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10).isActive = true
        viewButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        viewButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        viewButton.titleLabel?.bottomAnchor.constraint(equalTo: viewButton.bottomAnchor).isActive = true
//        viewButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        deleteButton.leftAnchor.constraint(equalTo: viewButton.rightAnchor, constant: 30).isActive = true
        deleteButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        deleteButton.titleLabel?.bottomAnchor.constraint(equalTo: deleteButton.bottomAnchor).isActive = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
//        let notif = notifArray[item]
        //Reset label to clear color
//        let text = notif.text
        let seen = self.notofication?.seen
//        textView.text = text
        if seen == false {
            newBadge.text = "NEW"
        } else {
        newBadge.text = ""
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

