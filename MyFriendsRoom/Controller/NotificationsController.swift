//
//  NotificationsController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 28.11.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

var notificationsArray = [[:]]
var notifArray = [notification]()
class NotificationsController: UITableViewController {
    var youAreBanned = false
    
    let ref = Database.database().reference(fromURL: "https://myfriendsroomtest.firebaseio.com/")
    //    var addButtonsExclusions = [String]()
//    var notificationsArray: Array = Array<Any>()//[[:]]
//    var notificationsArray = [[:]]
    let cellId = "cellId"
    
    @objc func reloadNotifications(){
        takeWisglist()
//        seeAllNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfYouAreBanned()
        takeWisglist()
        setupNavBarItems()
        seeAllNotifications()
        tableView.register(NotificationCell.self, forCellReuseIdentifier: cellId)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNotifications), name: NSNotification.Name(rawValue: "newSignin"), object: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifArray.count
    }
//
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        seeAllNotifications()
        print("apear")
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidAppear(animated)
////        resetAndReload()
////        see()
//        print("disapear")
//    }
    @objc func resetAndReload(){
    
        print("reloaded")
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadNotificationSeenStatus"), object: nil)
            self.tableView.reloadData()
        }
    }
    @objc func seeAllNotifications(){
        print("=++=+=++")
        reloadTable()
//        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.see), userInfo: nil, repeats: false)
    }
    @objc func see(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let wishList = Database.database().reference().child("users-notifications").child(uid)
        wishList.observeSingleEvent(of: .value) { (snap) in
            let array = snap.children.allObjects as! [DataSnapshot]
            for single in array {
                let values = single.value as! [String:Any]
                let key = single.key
                if let some = values["seen"] {
                } else {
                    let update = ["seen": 1]
                    wishList.child(key).updateChildValues(update)
                    var count = 0
//                    for sngl in notificationsArray {
//                        if sngl["notificationID"] as! String == key {
//                            print("sngl: ", sngl)
//                            notificationsArray[count]["seen"] = true
//                            break
//                        }
//                        count += 1
//                    }
                    for sngl in notifArray {
                        if sngl.notificationID as! String == key {
                            print("sngl: ", sngl)
                            notifArray[count].seen = true
                            break
                        }
                        count += 1
                    }
                    
                    unseenNotificationsCount = count
//                    print("sngl: ", notificationsArray)
                }
            }
        }
    }
    func singleSee(id: String, row: Int){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let wishList = Database.database().reference().child("users-notifications").child(uid).child(id)
        
        let update = ["seen": 1]
        wishList.updateChildValues(update)
        let notif = notifArray[row]
        notif.seen = true
//        wishList.observeSingleEvent(of: .value) { (snap) in
//            let array = snap.children.allObjects as! [DataSnapshot]
//            for single in array {
//                let values = single.value as! [String:Any]
//                let key = single.key
//                if let some = values["seen"] {
//                } else {
//                    let update = ["seen": 1]
//                    wishList.child(key).updateChildValues(update)
//                    var count = 0
//                    for sngl in notifArray {
//                        if sngl.notificationID as! String == key {
//                            print("sngl: ", sngl)
//                            notifArray[count].seen = true
//                            break
//                        }
//                        count += 1
//                    }
//                }
//            }
//        }
    }
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NotificationCell
//        cell.textLabel?.textColor = CustomColors.commonGrey1
//        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//        let arrayIndexPathItem = notificationsArray[indexPath.row] as AnyObject
//        let input_name = arrayIndexPathItem.value(forKey: "name") as? String
//        let profileImageUrl = arrayIndexPathItem.value(forKey: "profileImageUrl") as? String
//        let time = arrayIndexPathItem.value(forKey: "timestamp") as! Int
//        let text = arrayIndexPathItem.value(forKey: "text") as? String
//        let seen = arrayIndexPathItem.value(forKey: "seen") as? Bool
//        cell.textLabel?.text = input_name
//        cell.timeLabel.text = setTimeAgo(time: time)
//        if profileImageUrl == "empty" {
//            cell.profileImageView.image = UIImage(named: "emptyavatar")
//        } else if profileImageUrl == "deleted" {
//            cell.profileImageView.image = UIImage(named: "deletedprofile")
//        } else if profileImageUrl == "admin" {
//            cell.profileImageView.image = UIImage(named: "profile")
//        } else {
//            cell.profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
//        }
//        cell.deleteButton.tag = indexPath.row
//        cell.viewButton.tag = indexPath.row
//        cell.textView.text = text
//        if seen == false {
//            cell.newBadge.text = "NEW"
//        }
        cell.item = indexPath.row
        let notification = notifArray[indexPath.row]
        cell.notofication = notification
        return cell
    }
    var wishList: DatabaseReference!
    func takeWisglist() {
        print("take wish func")
//        notificationsArray = []
        if wishList != nil {
           wishList.removeAllObservers()
        }
        notifArray = [notification]()
        let uid = Auth.auth().currentUser!.uid
        wishList = Database.database().reference().child("users-notifications").child(uid)
        wishList.observe(.childAdded, with: { (snapshot) in
//            let wishlistItem = snapshot.key
            guard var dictionary = snapshot.value as? [String: Any] else {
                return
            }
            var singleNotificationArray = [String:Any]()
            print(dictionary)
            let notificationID = snapshot.key
            let senderUid = dictionary["senderUid"]
            let notifText = dictionary["text"]
            let timestamp = dictionary["timestamp"]
            var seen = false
            if let s = dictionary["seen"] {
                seen = true
            }
            print("======\(notifText)======")
            if senderUid as! String == "admin" {
                let profileImageUrl = "admin"
                let name = "MyFriendsRoom"
//                singleNotificationArray.updateValue(senderUid, forKey: "userId")
//                singleNotificationArray.updateValue(seen, forKey: "seen")
//                singleNotificationArray.updateValue(name, forKey: "name")
//                singleNotificationArray.updateValue(profileImageUrl, forKey: "profileImageUrl")
//                singleNotificationArray.updateValue(notifText, forKey: "text")
//                singleNotificationArray.updateValue(timestamp, forKey: "timestamp")
//                singleNotificationArray.updateValue(notificationID, forKey: "notificationID")
//                notificationsArray.insert(singleNotificationArray, at: 0)
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
                let notif = notification(dictionary: dictionary as [String : AnyObject])
                //                notifArray[notificationID] = notif
                notif.name = name
                notif.seen = seen
                notif.profileImageUrl = profileImageUrl
                notif.userId = senderUid as! String
                notif.text = notifText as! String
                notif.timestamp = timestamp as! NSNumber
                notif.notificationID = notificationID
                notifArray.insert(notif, at: 0)
                notifArray = notifArray.sorted(by: { $0.timestamp as! Int > $1.timestamp as! Int })
//                DispatchQueue.main.async {
                counterbadge = unreadMessagesCount + unseenNotificationsCount
                    self.reloadTable()
//                }
            } else {
                let ref = Database.database().reference().child("users").child(senderUid as! String)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    var value = snapshot.value as? [String: Any]
                    let profileImageUrl = value!["profileImageUrl"]
                    let name = value!["name"]
//                    singleNotificationArray.updateValue(senderUid, forKey: "userId")
//                    singleNotificationArray.updateValue(name, forKey: "name")
//                    singleNotificationArray.updateValue(seen, forKey: "seen")
//                    singleNotificationArray.updateValue(profileImageUrl, forKey: "profileImageUrl")
//                    singleNotificationArray.updateValue(notifText, forKey: "text")
//                    singleNotificationArray.updateValue(timestamp, forKey: "timestamp")
//                    singleNotificationArray.updateValue(notificationID, forKey: "notificationID")
//                    notificationsArray.insert(singleNotificationArray, at: 0)
                    notifArray = notifArray.sorted(by: { $0.timestamp as! Int > $1.timestamp as! Int })
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
                    let notif = notification(dictionary: dictionary as [String : AnyObject])
                    //                notifArray[notificationID] = notif
                    notif.name = name as! String
                    notif.seen = seen
                    notif.profileImageUrl = profileImageUrl as! String
                    notif.userId = senderUid as! String
                    notif.text = notifText as! String
                    notif.timestamp = timestamp as! NSNumber
                    notif.notificationID = notificationID
                    notifArray.insert(notif, at: 0)
                    notifArray = notifArray.sorted(by: { $0.timestamp as! Int > $1.timestamp as! Int })
                    print("name: ", name, ", seen: ", seen, ", notificationID: ", notificationID, ", timestamp: ", timestamp, ", time: ", self.setTimeAgo(time: timestamp as! Int))
//                    DispatchQueue.main.async {
                        self.reloadTable()
                    counterbadge = unreadMessagesCount + unseenNotificationsCount
//                    }
//                    print("notificationsArray: ", notificationsArray)
                })
            }
//            Database.database().reference().child("users-notifications").observe(.childAdded, with: { (snap) in
//                let id = snap.key
//                Database.database().reference().child("users-notifications").child(uid).observe(.childAdded, with: { (snap1) in
//                    print("---", snap1)
//                    let id =
//                })
//            })
            
            
//            if let dict = snapshot.value as? [String: AnyObject] {
//                let notif = notification(dictionary: dict as [String : AnyObject])
////                notifArray[notificationID] = notif
//                notifArray.insert(notif, at: 0)
//                print("дичь: ", notifArray)
//            }
            //            if let dictionary = snapshot.value as? [String: AnyObject] {
            //                let message = Message(dictionary: dictionary as [String : AnyObject])
            //                if let chatPartnerId = message.chatPartnerId() {
            //                    let uid = Auth.auth().currentUser?.uid
            //                    if message.fromId == chatPartnerId {
            //                        message.sender = "partner"
            //                    } else {
            //                        message.sender = "me"
            //                    }
            //
            //                    message.readStatus = readStatus
            //                    print("chatPartnerId: ", chatPartnerId, ", uid: ", uid, ", sender: ", message.sender, ", readStatus: ", message.readStatus)
            //                    self.messagesDictionary[chatPartnerId] = message
            //                    let dialogs = self.messagesDictionary.keys
            //                    if message.sender == "partner" && message.readStatus == 1 {
            //                        unreadCounter += 1
            //
            //                        //                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "globalBadgeCount"), object: nil)
            //                        //                        let singleDialogCounterArray = [chatPartnerId: 0]
            //                        if unreadCountersDict[chatPartnerId] != nil {
            //                            var currentCount = unreadCountersDict[chatPartnerId]?.hashValue as! Int
            //                            currentCount += 1
            //                            unreadCountersDict.updateValue(currentCount, forKey: chatPartnerId)
            //                        } else {
            //                            unreadCountersDict.updateValue(unreadCounter, forKey: chatPartnerId)
            //                        }
            //                        self.countGlobalBadge()
            //                    }
            //
            //                }
            //            }
        })
    }
    var timer: Timer?
    private func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTable), userInfo: nil, repeats: false)
    }
    @objc func reloadTable(){
        print("reloaded")
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
    }
    func checkIfYouAreBanned() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(uid!).child("wasDeleted")
        ref.observeSingleEvent(of: .value) { (snap) in
            if snap.value as? String == "byAdministration" {
                let alert = UIAlertController(title: "You got banned from MyFriendsRoom", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    weak var pvc = self.presentingViewController
                    self.dismiss(animated: false) {
                        pvc?.present(LoginMethodController(), animated: false, completion: {
                            do {
                                try Auth.auth().signOut()
                            }
                            catch let logoutError {
                                print (logoutError)
                            }
                        })
                    }
                }))
                self.present(alert, animated: true)
            }
        }
    }
    func setupNavBarItems(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.lightOrange1]
        self.navigationItem.title = "Notifications"
//        let backImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
//        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
//        navigationItem.leftBarButtonItem = backButton
    }
    @objc func viewProfile(_ sender: UIButton){
        checkIfYouAreBanned()
        let notif = notifArray[sender.tag]
        let memberUid = notif.userId as! String
//        let memberUid = (notificationsArray[sender.tag] as AnyObject).value(forKey: "userId") as! String
        goToControllerByMemberUid = memberUid
        let memberProfileController = MemberProfileController()
        let memberProfileNav = UINavigationController(rootViewController: memberProfileController)
        self.present(memberProfileNav, animated: true, completion: nil)
        singleSee(id: notif.notificationID!, row: sender.tag)
    }
    @objc func deleteFromWishlist(_ sender: UIButton){
        checkIfYouAreBanned()
        let notif = notifArray[sender.tag]
        let notificationID = notif.notificationID
//        let notificationID = (notifArray[sender.tag] as AnyObject)//.value(forKey: "notificationID") as! String
//        goToControllerByMemberUid = memberUid
//        print("deleteFromWishlist: ", memberUid)
        let uid = Auth.auth().currentUser!.uid
        Database.database().reference().child("users-notifications").child(uid).child(notificationID!).removeValue { (error, ref) in
            if error != nil {
                print("Error to delete message: ", error!)
                return
            }
            notifArray.remove(at: sender.tag)
//            let indextPath = IndexPath(item: sender.tag, section: 0)
            self.tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
