//
//  ProposalsReceivedController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 08.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class ProposalsReceivedController: UITableViewController {
    
    let notifAccept = "accepted your friend request"
    let acceptText = "Accepted your friend request"
    var proposalReceivedListArray: Array = Array<Any>()
    let cellId = "cellId"
    var youAreBanned = false
    
    var contactsController = ContactsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfYouAreBanned()
        takeProposalReceivedList()
        setupNavBarItems()
        tableView.register(ProposalReceivedListCell.self, forCellReuseIdentifier: cellId)
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
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    func setupNavBarItems(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.lightOrange1]
        let backImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "Friend requests"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proposalReceivedListArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProposalReceivedListCell
        cell.textLabel?.textColor = CustomColors.commonGrey1
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        let arrayIndexPathItem = proposalReceivedListArray[indexPath.row] as AnyObject
        print(arrayIndexPathItem)
        let input_name = arrayIndexPathItem.value(forKey: "name") as? String
        let profileImageUrl = arrayIndexPathItem.value(forKey: "profileImageUrl") as? String
        cell.textLabel?.text = input_name
        if profileImageUrl == "empty" {
            cell.profileImageView.image = UIImage(named: "emptyavatar")
        } else if profileImageUrl == "deleted" {
            cell.profileImageView.image = UIImage(named: "deletedprofile")
        } else {
            cell.profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
        }
//        cell.profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
        cell.addButton.tag = indexPath.row
        cell.viewButton.tag = indexPath.row
        cell.tag = indexPath.row
        return cell
    }
    private func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    var timer: Timer?
    @objc func handleReloadTable(){
        print("timer")
        self.tableView.reloadData()
        print(proposalReceivedListArray)
    }
    func sentProposalNotification(toId: String, fromId: String, text: String) {
        Database.database().reference().child("users").child(fromId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            let name = dictionary["name"] as! String
            
            print(name)
            
            Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else {return}
                guard let fromDevice = dictionary["fromDevice"] as? String else {return}
                
                print(fromDevice)
                
                let title = "MyFriendsRoom"
                //                let body = "\(name) wants to add you to friend" text
                let body = name + " " + text
                let toDeviceID = fromDevice
                
                let uid = Auth.auth().currentUser?.uid
                let method = "profile"
                var headers:HTTPHeaders = HTTPHeaders()
                headers = ["Content-Type":"application/json", "Authorization":"key=\(AppDelegate.SERVERKEY)"]
                let reference = Database.database().reference().child("users").child(toId)
                reference.observeSingleEvent(of: .value, with: { (snap) in
                    let user = snap.value as! [String: Any]
                    if user["counterbadge"] != nil {
                        var badge = user["counterbadge"] as! Int
                        badge += 1
                        let notification = ["to":"\(toDeviceID)", "notification":["body":body, "title":title, "badge": badge, "sound":"default"], "data":["uid":uid, "method":method]] as [String : Any]
                        Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                            
                        }
                        let values = ["counterbadge": badge]
                        reference.updateChildValues(values)
                    } else {
                        
                        let notification = ["to":"\(toDeviceID)", "notification":["body":body, "title":title, "sound":"default"], "data":["uid":uid, "method":method]] as [String : Any]
                        Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                            
                        }
                    }
                    
                    
                })
//                let notification = ["to":"\(toDeviceID)", "notification":["body":body, "title":title, "badge":1, "sound":"default"]] as [String : Any]
//                
//                Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
//                }
            }
        }
    }
    func takeProposalReceivedList() {
        proposalReceivedListArray = []
        let uid = Auth.auth().currentUser!.uid
        let proposalReceivedList = Database.database().reference().child("users-friends-proposals").child(uid).child("received")
        proposalReceivedList.observe(.childAdded, with: { (snapshot) in
            let proposalReceivedListItem = snapshot.key
            print(proposalReceivedListItem)
            let ref = Database.database().reference().child("users").child(proposalReceivedListItem)
            ref.observe(.value, with: { (snapshot) in
                var singleUserArray = [String:Any]()
                for _ in (snapshot.value as? [String: Any])! {
                    singleUserArray = [:]
                    guard let value = snapshot.value as? [String: Any]  else {return}
                    let userId = snapshot.key
                    let searchResultName = value["name"] as! String
                    let searchResultProfileImageUrl = value["profileImageUrl"] as! String
                    singleUserArray.updateValue(userId, forKey: "userId")
                    singleUserArray.updateValue(searchResultName, forKey: "name")
                    singleUserArray.updateValue(searchResultProfileImageUrl, forKey: "profileImageUrl")
                }
                self.proposalReceivedListArray.append(singleUserArray)
                DispatchQueue.main.async {
                    self.attemptReloadOfTable()
                }
            })
        })
    }
    @objc func addFriend(_ sender: UIButton){
        checkIfYouAreBanned()
        print(sender.tag)
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference(fromURL: "https://myfriendsroomtest.firebaseio.com/")
        let userInfo = proposalReceivedListArray[sender.tag] as AnyObject
        let memberUid = userInfo.value(forKey: "userId") as! String
        print("chatPartnerId: ", memberUid, "uid: ", uid)
        
        let currUserRemoveFriendProposal = ref.child("users-friends-proposals").child(uid).child("received").child(memberUid)
        currUserRemoveFriendProposal.removeValue()
        print(currUserRemoveFriendProposal)
        let friendUserRemoveCurrentProposal = ref.child("users-friends-proposals").child(memberUid).child("sent-to").child(uid)
        friendUserRemoveCurrentProposal.removeValue()
        print(friendUserRemoveCurrentProposal)
        
        let currUserAddFriend = ref.child("users-friends").child(uid)
        currUserAddFriend.updateChildValues([memberUid: 1])
        let friendUserAddCurrent = ref.child("users-friends").child(memberUid)
        friendUserAddCurrent.updateChildValues([uid: 1])
        whriteToUserNotification(text: acceptText, memberUid: memberUid)
//        print("goToControllerByMemberUid: ", goToControllerByMemberUid, ", uid: ", uid, ", self.notifAccept: ", self.notifAccept)
        self.sentProposalNotification(toId: memberUid, fromId: uid, text: self.notifAccept)
        self.proposalReceivedListArray.remove(at: sender.tag)
        self.attemptReloadOfTable()
    }
    @objc func viewProfile(_ sender: UIButton){
        checkIfYouAreBanned()
        print("go")
        let memberUid = (proposalReceivedListArray[sender.tag] as AnyObject).value(forKey: "userId") as! String
        goToControllerByMemberUid = memberUid
        let memberProfileController = MemberProfileController()
        let memberProfileNav = UINavigationController(rootViewController: memberProfileController)
        self.present(memberProfileNav, animated: true, completion: nil)
        print("viewProfile")
    }
    func whriteToUserNotification(text: String, memberUid: String) {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let notificationRef = ref.child("users-notifications").child(memberUid)
        let childRef = notificationRef.childByAutoId()
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let values = ["text": text, "timestamp": timestamp, "senderUid": uid] as [String : Any]
        childRef.updateChildValues(values)
    }
    @objc func showChatControllerForUser(user: User){
        checkIfYouAreBanned()
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        nameOfUser = user.name!
        idOfUser = user.id!
        let chatLogNav = UINavigationController(rootViewController: chatLogController)
        present(chatLogNav, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfo = proposalReceivedListArray[indexPath.row] as AnyObject
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
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        checkIfYouAreBanned()
        let ref = Database.database().reference(fromURL: "https://myfriendsroomtest.firebaseio.com/")
        let userInfo = proposalReceivedListArray[indexPath.row] as AnyObject
        let memberUid = userInfo.value(forKey: "userId") as! String
        print("chatPartnerId: ", memberUid, "uid: ", uid)
        let currUserRemoveFriendProposal = ref.child("users-friends-proposals").child(uid).child("received").child(memberUid)
        currUserRemoveFriendProposal.removeValue()
        print(currUserRemoveFriendProposal)
        let friendUserRemoveCurrentProposal = ref.child("users-friends-proposals").child(memberUid).child("sent-to").child(uid)
        friendUserRemoveCurrentProposal.removeValue()
        print(friendUserRemoveCurrentProposal)
        self.proposalReceivedListArray.remove(at: indexPath.row)
        self.attemptReloadOfTable()
    }
}
