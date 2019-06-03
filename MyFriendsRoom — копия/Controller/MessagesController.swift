//
//  ViewController.swift
//  MyFriendsRoom
//
//  Created by Ал on 24.08.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase


var selcectedLoginMethod = String()
var nameOfUser = String()
var idOfUser = String()
var unreadCountersDict = [String: Int]()
var unreadMessagesCount = Int()
var unseenNotificationsCount = Int()
var selectorIdentifier = false
class MessagesController: UITableViewController {
    var selectorCounter = 0
    var oldUid = String()
    var messagesController: MessagesController?
    let cellId = "cellId"
    var youAreBanned = false
    @IBOutlet weak var insta_btn: UIButton!
    @IBOutlet weak var fb_btn: UIButton!
    @IBOutlet weak var email_btn: UIButton!
    
//    override open var shouldAutorotate: Bool {
//        return false
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbarButtons()
        checkIfUserIsLoggedIn()
        unreadNotificationsCounter()
        
        NotificationCenter.default.addObserver(self, selector: #selector(thisIsRegistration), name: NSNotification.Name(rawValue: "wasItRegistration"), object: nil)
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsMultipleSelectionDuringEditing = true
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newSigninActions), name: NSNotification.Name(rawValue: "newSignin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.nilTheCounter(_:)), name: NSNotification.Name(rawValue: "nilTheCounter"), object: nil)
        
    }
    @objc func newSigninActions(){
        self.tabBarController?.selectedIndex = 2
        if userNotificationsRef != nil {
            userNotificationsRef.removeAllObservers()
        }
        unreadNotificationsCounter()
    }
    @objc func thisIsRegistration(){
        self.tabBarController?.selectedIndex = 2
        itWasRegistration = false
    }
    func setupNavbarButtons(){
        let leftNavbarButton = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(handleLogout))
        let rightNavbarButton = UIBarButtonItem(title: "Contacts", style: .plain, target: self, action: #selector(сontactsController))
        leftNavbarButton.tintColor = CustomColors.commonBlue1
        rightNavbarButton.tintColor = CustomColors.commonBlue1
        navigationItem.leftBarButtonItem = rightNavbarButton 
        navigationItem.rightBarButtonItem = leftNavbarButton
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.lightOrange1]
        self.navigationItem.title = "Chats"
    }
    @objc func loadList(){
        refreshMessages()
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let message = self.messages[indexPath.row]
        if let chatPartnerId = message.chatPartnerId() {
            let reference = Database.database().reference().child("user-messages").child(uid).child(chatPartnerId)
            reference.observeSingleEvent(of: .value) { (snap) in
                let snapVal = snap.value
                let arcRef = Database.database().reference().child("archive-user-messages").child(uid).child(chatPartnerId)
                arcRef.updateChildValues(snapVal as! [String: Any])
                reference.removeValue { (error, ref) in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        print("Error to delete message: ", error!)
                        return
                    }
                    self.messagesDictionary.removeValue(forKey: chatPartnerId)
                    self.attemptReloadOfTable()
                }
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.textLabel?.textColor = CustomColors.commonGrey1
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        let message = messages[indexPath.row]
        cell.message = message
        cell.viewButton.tag = indexPath.row
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
//        print(message.text, message.fromId, message.toId)
        guard let chatPartnerId = message.chatPartnerId() else { return }
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            print(snapshot)
            guard (snapshot.value as?  [String: Any]) != nil else { return }
            let user = User()
            user.id = chatPartnerId
            user.email = (snapshot.value as? NSDictionary)?["email"] as? String ?? ""
            user.name = (snapshot.value as? NSDictionary)?["name"] as? String ?? ""
            user.profileImageUrl = (snapshot.value as? NSDictionary)?["profileImageUrl"] as? String ?? ""
            self.showChatControllerForUser(user: user)
        }, withCancel: nil)
    }
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    func observeUserMessages() {
//        print("Observe messages")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        checkIfUserBanned(uid: uid)
        seletTabIndex()
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
//            let dict = snapval as? [String: Int]
//            let dictCount = dict?.count
//            let dictValues = dict?.values
//            var unreadCounter = 0
//            for readStatus in dictValues! {
//                if readStatus == 1 {
//                    unreadCounter += 1
//                }
//            }
//            print("-!- dict", dict, "\ncounter", dictCount, "\ndictValues", dictValues, "\nunreadCounter", unreadCounter)
            let refer = Database.database().reference().child("user-messages").child(uid).child(userId)
            //написать функцию в которую я закину обзерв
//            func reobservMessages(){
//                unreadCountersDict.updateValue(0, forKey: userId)
////                self.unreadMessagesCount = 0
//                refer.observe(.childAdded, with: { (snapshot) in
//                    let messageId = snapshot.key
//                    let readStatus = snapshot.value as! Int
//                    print(readStatus)
//                    self.fetchMessageWithMessageId(messageId: messageId, readStatus: readStatus)
//                }, withCancel: nil)
//            }
//            reobservMessages()
            
            unreadCountersDict.updateValue(0, forKey: userId)
            //                self.unreadMessagesCount = 0
            refer.observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                let readStatus = snapshot.value as! Int
//                print(readStatus)
                self.fetchMessageWithMessageId(messageId: messageId, readStatus: readStatus)
            }, withCancel: nil)
            refer.observe(.childChanged, with: { (snapshot) in
//                print("~changed~")
                let messageId = snapshot.key
                let readStatus = snapshot.value as! Int
                print(readStatus)
                self.fetchMessageWithMessageId(messageId: messageId, readStatus: readStatus)
//                reobservMessages()
            }, withCancel: nil)
        }, withCancel: nil)
        ref.observe(.childRemoved, with: { (snapshot) in
             self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadOfTable()
        }, withCancel: nil)
    }
    func checkIfUserBanned(uid: String) {
        let ref = Database.database().reference().child("users").child(uid).child("wasDeleted")
        ref.observeSingleEvent(of: .value) { (snap) in
            if snap.value as? String == "byAdministration" {
                let alert = UIAlertController(title: "You got banned from MyFriendsRoom", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    self.handleLogout()
                }))
                self.present(alert, animated: true)
            }
        }
    }
   //chat partner: value of unread messages
    private func fetchMessageWithMessageId(messageId: String, readStatus: Int) {
//        print("KEEY")
        var unreadCounter = 0
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary as [String : AnyObject])
                if let chatPartnerId = message.chatPartnerId() {
                    let uid = Auth.auth().currentUser?.uid
                    if message.fromId == chatPartnerId {
                        message.sender = "partner"
                    } else {
                        message.sender = "me"
                    }
                    
                    message.readStatus = readStatus
//                    print("chatPartnerId: ", chatPartnerId, ", uid: ", uid, ", sender: ", message.sender, ", readStatus: ", message.readStatus)
                    self.messagesDictionary[chatPartnerId] = message
                    let dialogs = self.messagesDictionary.keys
                    if message.sender == "partner" && message.readStatus == 1 {
                        unreadCounter += 1
                        
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "globalBadgeCount"), object: nil)
//                        let singleDialogCounterArray = [chatPartnerId: 0]
                        if unreadCountersDict[chatPartnerId] != nil {
                            var currentCount = unreadCountersDict[chatPartnerId]?.hashValue as! Int
                            currentCount += 1
                            unreadCountersDict.updateValue(currentCount, forKey: chatPartnerId)
                        } else {
                            unreadCountersDict.updateValue(unreadCounter, forKey: chatPartnerId)
                        }
                        self.countGlobalBadge()
                    }
                    
                }
            }
            self.attemptReloadOfTable()
//            print("unreadCountersDict: ", unreadCountersDict)
            if let tabItems = self.tabBarController?.tabBar.items {
                unreadMessagesCount = 0
                for dialogUnreads in unreadCountersDict.values {
                    unreadMessagesCount += dialogUnreads
                }
                let tabItem = tabItems[0]
                let count = unreadMessagesCount
                if count == 0 {
                    tabItem.badgeValue = nil
                } else {
                    tabItem.badgeValue = String(count)
                }
                
            }
        }, withCancel: nil)
    }
    @objc func nilTheCounter(_ notification: NSNotification){
        let dict = notification.userInfo as! NSDictionary
        let id = dict["id"] as! String
//        print("unreadCountersDict: ", unreadCountersDict, "goToControllerByMemberUid: ", id)
        unreadCountersDict.updateValue(0, forKey: id)
        
        if let tabItems = self.tabBarController?.tabBar.items {
            unreadMessagesCount = 0
            for dialogUnreads in unreadCountersDict.values {
                unreadMessagesCount += dialogUnreads
            }
            let tabItem = tabItems[0]
            let count = unreadMessagesCount
            if count == 0 {
                tabItem.badgeValue = nil
            } else {
                tabItem.badgeValue = String(count)
            }
            
        }
        self.tableView.reloadData()
        countGlobalBadge()
    }
    func countGlobalBadge() {
        counterbadge = unreadMessagesCount + unseenNotificationsCount
    }
    private func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    var timer: Timer?
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
//        print("==================================\n", "messagesDictionary: " , messagesDictionary)
        self.messages.sort(by: { (message1, message2) -> Bool in
            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
        })
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func pushNotificatipnAction(){
//        print("-=pushNotificatipnAction=-")
        self.tabBarController?.selectedIndex = 0
        if notificationCategory == "chat"{
            let ref = Database.database().reference().child("users").child(notificationUid)
            ref.observeSingleEvent(of: .value) { (snap) in
//                print(snap)
                var singleUserArray = [String:Any]()
                guard let value = snap.value as? [String: Any] else { return }
                let user = User()
                user.name = value["name"] as? String
                user.profileImageUrl = value["profileImageUrl"] as? String
                user.email = value["email"] as? String
                user.id = notificationUid
                self.showChatControllerForUser(user: user)
            }
        }
    }
    var userNotificationsRef: DatabaseReference!
    func unreadNotificationsCounter(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        func recount() {
            Database.database().reference().child("users-notifications").child(uid).observeSingleEvent(of: .value) { (snap) in
                unseenNotificationsCount = 0
                let array = snap.children.allObjects as! [DataSnapshot]
                for single in array {
                    let values = single.value as! [String:Any]
//                    print("this is notifications: ", values)
                    if let some = values["seen"] {
//                        print("seen")
                    } else {
//                        print("unseen")
                        unseenNotificationsCount += 1
                    }
                }
                if let tabItems = self.tabBarController?.tabBar.items {
                    let tabItem = tabItems[4]
                    var count = unseenNotificationsCount
                    if count == 0 {
                        tabItem.badgeValue = nil
                    } else {
                        tabItem.badgeValue = String(count)
                    }
                    self.countGlobalBadge()
                }
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "globalBadgeCount"), object: nil)
//                self.countGlobalBadge()
            }
        }
        userNotificationsRef = Database.database().reference().child("users-notifications").child(uid)
        userNotificationsRef.observe(.childChanged) { (nil) in
//            print("changed")
            recount()
        }
        userNotificationsRef.observe(.childAdded) { (nil) in
//            print("added")
            recount()
        }
    }
    func refreshMessages() {
//        print("in mes cont and refeshing")
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
    }
    @objc func сontactsController() {
        let сontactsController = ContactsController()
        let navController = UINavigationController(rootViewController: сontactsController)
        present(navController, animated: true, completion: nil)
    }
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else {
            refreshMessages()
            let titleView = UIButton()
            let buttonChatTitle = NSLocalizedString("Chats", comment: "")
            titleView.setTitleColor(CustomColors.lightOrange1, for: .normal)
            titleView.setTitle(buttonChatTitle, for: .normal)
            self.navigationItem.titleView = titleView
        }
    }
    @objc func showChatControllerForUser(user: User){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        nameOfUser = user.name!
        idOfUser = user.id!
        let cahtLogNav = UINavigationController(rootViewController: chatLogController)
        present(cahtLogNav, animated: true)
//        self.navigationController?.pushViewController(cahtLogNav, animated: false)
    }
    @objc func handleLogout() {
//        let oldUid = Auth.auth().currentUser?.uid
//        let oldUidType = type(of: oldUid)
//        print("oldUid: \(oldUid), oldUidType: \(oldUidType)")
        do {
            if let oldUid = Auth.auth().currentUser?.uid {
                remooveDeviceId(oldUid: oldUid)
            }
            let uid = Auth.auth().currentUser?.uid
            try Auth.auth().signOut()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signOut"), object: nil, userInfo: ["signOutUid": uid])
        }
        catch let logoutError {
            print (logoutError)
        }
        UserDefaults.standard.set(nil, forKey: "arrayOfYourFriendsline")
//        print("++++++++++++++++++++++++++++++CLEAR CACHE++++++++++++++++++++++++++++++")
        selectorCounter = 0
        selectorIdentifier = false
        firstLaunchDetect()
    }
    
    func remooveDeviceId(oldUid: Any) {
//        print("oldUid: \(oldUid)")
        let ref = Database.database().reference().child("users").child(oldUid as! String).child("fromDevice")
        ref.removeValue()
    }
    func firstLaunchDetect(){
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
//            UserDefaults.standard.set(false, forKey: "launchedBefore")
//            print("Not first launch.")
            let loginMethodController = LoginMethodController()
            present(loginMethodController, animated: false, completion: nil)
        } else {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            let firstLaunchController = FirstLaunchController()
            present(firstLaunchController, animated: false, completion: nil)
//            print("First launch, setting UserDefault.")
        }
    }
    @objc func viewProfile(_ sender: UIButton){
        let memberUid = (messages[sender.tag].chatPartnerId() as AnyObject)
        goToControllerByMemberUid = memberUid as! String
        let memberProfileController = MemberProfileController()
        let memberProfileNav = UINavigationController(rootViewController: memberProfileController)
        self.present(memberProfileNav, animated: true, completion: nil)
    }
    func seletTabIndex() {
//        print("select tab index \(selectorCounter)")
//        if selectorCounter == 0 {
        if selectorIdentifier == false {
//            let arrayOfYourFriends = UserDefaults.standard.array(forKey: "arrayOfYourFriendsline") as? Array<[String: Any]>
            let userDefaults = UserDefaults.standard
            if let decoded  = userDefaults.object(forKey: "arrayOfYourFriendsline") as? Data{
                let decodedFriendsline = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [searchResult]
                if (decodedFriendsline.count) > 0 {
//                    friendslineArray = arrayOfYourFriends!
//                    friendsLine = decodedFriendsline
                    self.tabBarController?.selectedIndex = 1
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendLocalFL"), object: nil, userInfo: ["dict": decodedFriendsline])
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                } else {
                    self.tabBarController?.selectedIndex = 2
//                    print("selection`: 1")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendLocalFL"), object: nil, userInfo: ["dict": [notification]()])
                }
            } else {
                self.tabBarController?.selectedIndex = 2
//                print("selection`: 2")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendLocalFL"), object: nil, userInfo: ["dict": [notification]()])
            }
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendLocalFL"), object: nil, userInfo: ["dict": [notification]()])
//            selectorCounter += 1
            selectorIdentifier = true
        }
//        print("selection`: 3")
    }
//    func seletTabIndex() {
//        print("select tab index \(selectorCounter)")
//        if selectorCounter == 0 {
//            //            let arrayOfYourFriends = UserDefaults.standard.array(forKey: "arrayOfYourFriendsline") as? Array<[String: Any]>
//            let userDefaults = UserDefaults.standard
//            let archive = userDefaults.object(forKey: "arrayOfYourFriendsline")
//            let arckiveType = type(of: archive)
//            if let decoded  = userDefaults.object(forKey: "arrayOfYourFriendsline") as? Data {
//                print("FORMAT`: new")
//            } else {
//                print("FORMAT`: old")
//            }
//            let decoded  = userDefaults.object(forKey: "arrayOfYourFriendsline") as! Data
//            let decodedFriendsline = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [searchResult]
//            if decodedFriendsline != nil{
//                if (decodedFriendsline.count) > 0 {
//                    //                    friendslineArray = arrayOfYourFriends!
//                    friendsLine = decodedFriendsline
//                    self.tabBarController?.selectedIndex = 1
//                } else {
//                    self.tabBarController?.selectedIndex = 2
//                }
//            } else {
//                self.tabBarController?.selectedIndex = 2
//            }
//            selectorCounter += 1
//        }
//    }
//    func checkIfUserChanged() {
//        let currUid = Auth.auth().currentUser?.uid
//        if oldUid == nil {
//            oldUid = currUid!
//        }
//        if oldUid != currUid {
//            selectorCounter == 0
//            seletTabIndex()
//        } else {
//           seletTabIndex()
//        }
//    }
}
