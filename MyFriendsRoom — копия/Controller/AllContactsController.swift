//
//  AllContactsController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 08.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase

class AllContactsController: UITableViewController {
    var yourBlacklist: Array = Array<Any>()
    var users: Array = Array<Any>()
    var allContactsListArray: Array = Array<Any>()
    let cellId = "cellId"
    var contactsController = ContactsController()
    var youAreBanned = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfYouAreBanned()
        takeAllContactsList()
        setupNavBarItems()
        tableView.register(AllContactsListCell.self, forCellReuseIdentifier: cellId)
    }
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    func setupNavBarItems(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.lightOrange1]
        let backImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "All contacts"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AllContactsListCell
        cell.textLabel?.textColor = CustomColors.commonGrey1
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        let arrayIndexPathItem = users[indexPath.item] as AnyObject
        let name = arrayIndexPathItem.value(forKey: "name") as? String
        let profileImageUrl = arrayIndexPathItem.value(forKey: "profileImageUrl") as! String
        if profileImageUrl == "empty" {
            cell.profileImageView.image = UIImage(named: "emptyavatar")
        } else if profileImageUrl == "deleted" {
            cell.profileImageView.image = UIImage(named: "deletedprofile")
        } else {
            cell.profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl)
        }
//        cell.profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl)
        cell.textLabel?.text = name
        cell.viewButton.tag = indexPath.row
        cell.tag = indexPath.row
        return cell
    }
    func attemptReloadOfTable(){
        self.tableView.reloadData()
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
    func takeAllContactsList() {
        allContactsListArray = []
        let uid = Auth.auth().currentUser!.uid
        yourFriendsOfFriendsArray = [String: String]()
        yourBlacklist = []
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
                    print("friendUid: ", friendUid)
                    yourFriendsArray.append(friendUid)
                    let yourFriendRef = Database.database().reference().child("users-friends").child(friendUid)
                    yourFriendRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        print("CHCount: ",snapshot.children)
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
                                    if i == 0 {
                                        print("users: ", self.users)
                                        self.attemptReloadOfTable()
                                    }
                                })
                            }
                        }
                    })
                }
            })
        }
    }
    @objc func viewProfile(_ sender: UIButton){
        checkIfYouAreBanned()
        let memberUid = (users[sender.tag] as AnyObject).value(forKey: "userId") as! String
        goToControllerByMemberUid = memberUid
        let memberProfileController = MemberProfileController()
        let memberProfileNav = UINavigationController(rootViewController: memberProfileController)
        self.present(memberProfileNav, animated: true, completion: nil)
    }
    
    @objc func showChatControllerForUser(user: User){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        nameOfUser = user.name!
        idOfUser = user.id!
        let chatLogNav = UINavigationController(rootViewController: chatLogController)
        present(chatLogNav, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfo = users[indexPath.row] as AnyObject
        let chatPartnerId = userInfo.value(forKey: "userId") as! String
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observe(.value, with: { (snapshot) in
            print(snapshot)
            guard (snapshot.value as?  [String: Any]) != nil else { return }
            let user = User()
            user.id = chatPartnerId
            user.email = (snapshot.value as? NSDictionary)?["email"] as? String ?? ""
            user.name = (snapshot.value as? NSDictionary)?["name"] as? String ?? ""
            user.profileImageUrl = (snapshot.value as? NSDictionary)?["profileImageUrl"] as? String ?? ""
            self.showChatControllerForUser(user: user)
        }, withCancel: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
