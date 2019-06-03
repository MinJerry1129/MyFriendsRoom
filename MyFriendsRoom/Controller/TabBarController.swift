//
//  TabBarController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 02.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class TabBarController: UITabBarController, UITabBarControllerDelegate, CLLocationManagerDelegate {
    var youAreBanned = false
    
    var allContactsListArray: Array = Array<Any>()
    var users: Array = Array<Any>()
    var yourBlacklist: Array = Array<Any>()
//    @objc func thisIsRegistration() {
//        itWasRegistration = true
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        writeNewDeviceId()
//        Database.database().isPersistenceEnabled = true
        getCurrentLocation()
        setActiveDisconectStatus()
        isAuthorizedtoGetUserLocation()
        getCurentGPSLocation()
        tabBar.tintColor = CustomColors.lightOrange1
        tabBar.barTintColor = CustomColors.lightOrange1
        UITabBar.appearance().backgroundColor = CustomColors.lightOrange1
//        print("friendslineArray: ", friendslineArray)
        takeAllContactsList()//didEnterBackground
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundActions), name: NSNotification.Name(rawValue: "didEnterBackground"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.signOutActions(_:)), name: NSNotification.Name(rawValue: "signOut"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openingSetup), name: NSNotification.Name(rawValue: "opening"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newSigninActions), name: NSNotification.Name(rawValue: "newSignin"), object: nil)
//        print("TabBarController \(itWasRegistration)")
//        NotificationCenter.default.addObserver(self, selector: #selector(thisIsRegistration), name: NSNotification.Name(rawValue: "wasItRegistration"), object: nil)
        
        let messagesController = MessagesController()
        let messagesNavController = UINavigationController(rootViewController: messagesController)
        messagesNavController.tabBarItem.title = "Messages"
        messagesNavController.tabBarItem.setFAIcon(icon: .FAEnvelope, size: CGSize(width: 30, height: 30), orientation: .up, textColor: CustomColors.commonGrey1, selectedTextColor: .white, selectedBackgroundColor: CustomColors.lightOrange1)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let swipingSRController = SwipingSRControllet(collectionViewLayout: layout)
        swipingSRController.tabBarItem.title = "Searchline"
        swipingSRController.tabBarItem.setFAIcon(icon: .FAUsers, size: CGSize(width: 30, height: 30), orientation: .up, textColor: CustomColors.commonGrey1, selectedTextColor: .white, selectedBackgroundColor: CustomColors.lightOrange1)
        
        
        let searchControllerPre = SearchController()
        let searchController = UINavigationController(rootViewController: searchControllerPre)
        searchController.tabBarItem.title = "Search"
        searchController.tabBarItem.setFAIcon(icon: .FASearch, size: CGSize(width: 30, height: 30), orientation: .up, textColor: CustomColors.commonGrey1, selectedTextColor: .white, selectedBackgroundColor: CustomColors.lightOrange1)
        
        
        
        let profileSettingsControllerPre = MyProfileController()
        let profileSettingsController = UINavigationController(rootViewController: profileSettingsControllerPre)
        profileSettingsController.tabBarItem.title = "Profile"
        profileSettingsController.tabBarItem.setFAIcon(icon: .FAUser, size: CGSize(width: 30, height: 30), orientation: .up, textColor: CustomColors.commonGrey1, selectedTextColor: .white, selectedBackgroundColor: CustomColors.lightOrange1)
        
        let notificationsControllerPre = NotificationsController()
        let notificationsController = UINavigationController(rootViewController: notificationsControllerPre)
        notificationsController.tabBarItem.title = "Notifications"
        notificationsController.tabBarItem.setFAIcon(icon: .FABell, size: CGSize(width: 30, height: 30), orientation: .up, textColor: CustomColors.commonGrey1, selectedTextColor: .white, selectedBackgroundColor: CustomColors.lightOrange1)
//        wishlistController.tabBarItem.setFAIcon(icon: .FAStar, size: CGSize(width: 30, height: 30), orientation: .up, textColor: CustomColors.commonGrey1, selectedTextColor: .white, selectedBackgroundColor: CustomColors.lightOrange1)
        
        let сontactsControllerPre = ContactsController()
        let сontactsController = UINavigationController(rootViewController: сontactsControllerPre)
        сontactsController.tabBarItem.title = "Contacts"
        сontactsController.tabBarItem.setFAIcon(icon: .FAStar, size: CGSize(width: 30, height: 30), orientation: .up, textColor: CustomColors.commonGrey1, selectedTextColor: .white, selectedBackgroundColor: CustomColors.lightOrange1)
        
       
        
//        viewControllers = [messagesNavController, swipingSRController, searchController, profileSettingsController, wishlistController, сontactsController]
        viewControllers = [messagesNavController, swipingSRController, searchController, profileSettingsController, notificationsController]
//        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(goToIndex), userInfo: nil, repeats: false)
    }
//    func setupNavbarButtons(){
//        let leftNavbarButton = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(handleLogout))
//        let rightNavbarButton = UIBarButtonItem(title: "Contacts", style: .plain, target: self, action: #selector(сontactsController))
//        leftNavbarButton.tintColor = CustomColors.commonBlue1
//        rightNavbarButton.tintColor = CustomColors.commonBlue1
//        navigationItem.leftBarButtonItem = leftNavbarButton
//        navigationItem.rightBarButtonItem = rightNavbarButton
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.lightOrange1]
//        self.navigationItem.title = "Chats"
//    }
    func setActiveDisconectStatus(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let disconectTimeRef = Database.database().reference().child("users").child(uid).child("disconectTime")
        disconectTimeRef.onDisconnectSetValue(ServerValue.timestamp())
        let presenceRef = Database.database().reference().child("users").child(uid).child("isActive")
        presenceRef.onDisconnectSetValue(false)
//        presenceRef.
        presenceRef.setValue(true)
    }
    func signOutDisconect(id: String){
        let presenceRef = Database.database().reference().child("users").child(id).child("isActive")
        let disconectTimeRef = Database.database().reference().child("users").child(id).child("disconectTime")
        disconectTimeRef.setValue(ServerValue.timestamp())
        presenceRef.setValue(false)
    }
    @objc func newSigninActions() {
        takeAllContactsList()
        writeNewDeviceId()
        getCurrentLocation()
        setActiveDisconectStatus()
    }
    @objc func didEnterBackgroundActions(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        signOutDisconect(id: uid)
    }
    @objc func signOutActions(_ notification: NSNotification){
        guard ((Auth.auth().currentUser?.uid) != nil) else {return}
        let dict = notification.userInfo as! NSDictionary
        let uid = dict["signOutUid"] as! String
        signOutDisconect(id: uid)
    }
    @objc func openingSetup(){
        setActiveDisconectStatus()
        if opening == "notification" {
            opening = ""
            var isItRoot = false
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController?.dismiss(animated: true, completion: {
                    self.pushNotificatipnAction()
                    isItRoot = true
                })
                (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
            }
            if isItRoot == false {
                self.pushNotificatipnAction()
            }
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
    func pushNotificatipnAction(){
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
        } else if notificationCategory == "profile" {
            goToControllerByMemberUid = notificationUid
            let memberProfileController = MemberProfileController()
            let memberProfileNav = UINavigationController(rootViewController: memberProfileController)
            self.present(memberProfileNav, animated: true, completion: nil)
        } else {
            selectedIndex = 4
        }
    }
    func writeNewDeviceId() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(uid)
//        print("AppDelegate.DEVICEID: ", AppDelegate.DEVICEID, "\nInstanceID.instanceID().token(): ", InstanceID.instanceID().token())
        ref.updateChildValues(["fromDevice": InstanceID.instanceID().token()])
//        ref.updateChildValues(["fromDevice": AppDelegate.DEVICEID])
    }
    func takeAllContactsList() {
        allContactsListArray = []
        guard let uid = Auth.auth().currentUser?.uid else { return }
        yourFriendsOfFriendsArray = [String: String]()
        yourBlacklist = []
//        print("=======TakeAllContacts=====")
        let blacklistRef = Database.database().reference().child("users-blacklists").child(uid)
        blacklistRef.observeSingleEvent(of: .value) { (snap) in
            let snapshot = snap.children.allObjects as! [DataSnapshot]
            for blockedUser in snapshot {
                self.yourBlacklist.append(blockedUser.key)
            }
            var yourFriendsArray = [String]()
            let yourFriends = Database.database().reference().child("users-friends").child(uid)
            yourFriends.observeSingleEvent(of: .value, with: { (snap) in
                var i = snap.childrenCount
                for yourFriend in snap.children.allObjects as! [DataSnapshot]{
                    let friendUid = yourFriend.key
//                    print("friendUid: ", friendUid)
                    yourFriendsArray.append(friendUid)
                    let yourFriendRef = Database.database().reference().child("users-friends").child(friendUid)
                    yourFriendRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                        print("CHCount: ",snapshot.children)
                        for child  in snapshot.children.allObjects as! [DataSnapshot] {
                            let friendOfFriendUid = child.key
                            yourFriendsOfFriendsArray.updateValue(friendUid, forKey: friendOfFriendUid)
                        }
                        i = i - 1
                        if i == 0 {
                            for singleFriend in yourFriendsArray {
                                yourFriendsOfFriendsArray.updateValue("friend", forKey: singleFriend)
                            }
                            yourFriendsOfFriendsArray.removeValue(forKey: uid)
                            for blacklistItem in self.yourBlacklist {
                                yourFriendsOfFriendsArray.removeValue(forKey: blacklistItem as! String)
                            }
                            var i = yourFriendsOfFriendsArray.count
                            for (friendOfFriendKey, friendOfFriendValue) in yourFriendsOfFriendsArray{
                                let ref = Database.database().reference().child("users").child(friendOfFriendKey)
                                ref.observeSingleEvent(of: .value, with: { (datasnap) in
                                    i = i - 1
                                    var singleUserArray = [String:Any]()
                                    guard let value = datasnap.value as? [String: Any] else { return }
                                    let searchResultName = value["name"] as? String
                                    let searchResultProfileImageUrl = value["profileImageUrl"] as? String
                                    let userId = datasnap.key
                                    if friendOfFriendValue == "friend"{
                                        singleUserArray.updateValue(true, forKey: "isYourFriend")
                                    } else {
                                        singleUserArray.updateValue(false, forKey: "isYourFriend")
                                    }
                                    singleUserArray.updateValue(searchResultName!, forKey: "name")
                                    singleUserArray.updateValue(searchResultProfileImageUrl!, forKey: "profileImageUrl")
                                    singleUserArray.updateValue(userId, forKey: "userId")
                                    self.users.append(singleUserArray)
                                })
                            }
                        }
                    })
                }
            })
        }
    }
    @objc func goToIndex(){
        selectedIndex = 3
    }
    
    ///get user current location
    var currentDatabaseLocation: String?
    var currentGPSLocation: String?
    var currentLatitude: Float?
    var currrentLongitude: Float?
    func getCurrentLocation(){
        guard let uid = Auth.auth().currentUser?.uid else {
            currentDatabaseLocation = String()
            return
        }
        let userCurLocRef = Database.database().reference().child("users").child(uid)
        userCurLocRef.observeSingleEvent(of: .value) { (snap) in
            print(snap)
            guard let value = snap.value as? [String: Any] else { return }
            if let currentLoc = value["currentLoc"] {
                self.currentDatabaseLocation = currentLoc as! String
                print(self.currentDatabaseLocation)
                self.checkLocationAndUpdate()
                self.getCurentGPSLocation()
            }
        }
        print("GETTING LOCATION")
    }
    let locationManager = CLLocationManager()
    @objc func getCurentGPSLocation(){
        print("case1`")
        if CLLocationManager.locationServicesEnabled() {
            print("case21`")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    func isAuthorizedtoGetUserLocation() {
        print("case3`")
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            print("case4`")
//            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
        
//        locationManager.requestAlwaysAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
        }
    }
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("case5`")
        print("Did location updates is called")
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }//currentLatitude currrentLongitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        currentLatitude = locValue.latitude as? Float
        currrentLongitude = locValue.longitude as? Float
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            self.currentGPSLocation = city + ", " + country
            self.checkLocationAndUpdate()
        }
    }
    func checkLocationAndUpdate(){
        if /*self.currentDatabaseLocation != nil &&*/ self.currentGPSLocation != nil{
            if self.currentDatabaseLocation != self.currentGPSLocation {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                let ref = Database.database().reference().child("users").child(uid)//.child("currentLoc")
                ref.updateChildValues(["currentLoc": self.currentGPSLocation, "currentLatitude": currentLatitude, "currrentLongitude": currrentLongitude])
                self.currentDatabaseLocation = self.currentGPSLocation
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    
}
