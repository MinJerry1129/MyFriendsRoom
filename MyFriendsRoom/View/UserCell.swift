//
//  UserCell.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 04.09.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    var message: Message? {
        didSet {
            let minute = 60
            let hour = 60 * minute
            let day = 24 * hour
            let week =  7 * day
            let month = 30 * day
            let year = 12 * month
            setupNameAndProfileImage()
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: message!.timestamp!.doubleValue)
                let timeDouble = message!.timestamp!.doubleValue
                let timeInt = Int(timeDouble)
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
                timeLabel.text = agoString
            }
            print("The message:", message?.text)
            if let messageText = message?.text {
                textMessage.text = messageText
            }
        }
    }
    private func setupNameAndProfileImage() {
        if let id = message?.chatPartnerId() {
            let unreadMesegesCount = unreadCountersDict[id]
            var unreadMessages = "  " + String(unreadMesegesCount!) + "  "
            if unreadMesegesCount == 0 {
                unreadMessages = ""
                counterBadge.backgroundColor = UIColor.clear
            } else {
                
                let size = CGSize(width: 200, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let frame =  NSString(string: unreadMessages).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13)], context: nil) as CGRect
                let width = frame.width + 1
                //            cell.bubbleWidthAnchor?.constant = width + 55
                counterBadgeWidthAnchor?.isActive = false
                counterBadgeWidthAnchor = counterBadge.widthAnchor.constraint(equalToConstant: width)
                counterBadgeWidthAnchor?.isActive = true
                counterBadge.backgroundColor = CustomColors.lightOrange1
            }
            counterBadge.text = unreadMessages
            let ref = Database.database().reference().child("users").child(id)
            ref.observe(.value, with: {(snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["name"] as? String
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String{
                        if profileImageUrl == "empty" {
                            self.profileImageView.image = UIImage(named: "emptyavatar")
                        } else if profileImageUrl == "deleted" {
                            self.profileImageView.image = UIImage(named: "deletedprofile")
                        } else {
                            self.profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl)
                        }
//                        self.profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
            }, withCancel: nil)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
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
    let counterBadge: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let textMessage: UITextField = {
        let t = UITextField()
        t.textColor = CustomColors.commonGrey1
        t.font = UIFont.systemFont(ofSize: 15)
        t.translatesAutoresizingMaskIntoConstraints = false
        t.isUserInteractionEnabled = false
        return t
    }()
    let viewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(MessagesController.viewProfile), for: .touchUpInside)
        return button
    }()
    var counterBadgeWidthAnchor: NSLayoutConstraint?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        addSubview(counterBadge)
        addSubview(textMessage)
        addSubview(viewButton)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        counterBadge.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        counterBadge.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10).isActive = true
        counterBadgeWidthAnchor = counterBadge.widthAnchor.constraint(equalToConstant: 10)
        counterBadgeWidthAnchor?.isActive = true
        counterBadge.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        textMessage.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        textMessage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        textMessage.widthAnchor.constraint(equalToConstant: 250).isActive = true
        textMessage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        viewButton.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        viewButton.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        viewButton.widthAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        viewButton.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        viewButton.titleLabel?.bottomAnchor.constraint(equalTo: viewButton.bottomAnchor).isActive = true

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

