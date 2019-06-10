//
//  BlacklistController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 21.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
class BlacklistController: UITableViewController {
    
    var youAreBanned = false
    var blacklistArray: Array = Array<Any>()
    let cellId = "cellId"
    
    var contactsController = ContactsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfYouAreBanned()
        takeBlacklist()
        setupNavBarItems()
        tableView.register(BlacklistCell.self, forCellReuseIdentifier: cellId)
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
        self.navigationItem.title = "Blacklist"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blacklistArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BlacklistCell
        cell.textLabel?.textColor = CustomColors.commonGrey1
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        let arrayIndexPathItem = blacklistArray[indexPath.row] as AnyObject
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
        print(blacklistArray)
    }
    func takeBlacklist() {
        blacklistArray = []
        let uid = Auth.auth().currentUser!.uid
        let blacklist = Database.database().reference().child("users-blacklists").child(uid)
        blacklist.observe(.childAdded, with: { (snapshot) in
            let blacklistItem = snapshot.key
            let ref = Database.database().reference().child("users").child(blacklistItem)
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
                self.blacklistArray.append(singleUserArray)
                DispatchQueue.main.async {
                    self.attemptReloadOfTable()
                }
            })
        })
    }
    @objc func viewProfile(_ sender: UIButton){
        checkIfYouAreBanned()
        print("go")
        let memberUid = (blacklistArray[sender.tag] as AnyObject).value(forKey: "userId") as! String
        goToControllerByMemberUid = memberUid
        let memberProfileController = MemberProfileController()
        let memberProfileNav = UINavigationController(rootViewController: memberProfileController)
        self.present(memberProfileNav, animated: true, completion: nil)
        print("viewProfile")
    }
    
//    @objc func showChatControllerForUser(user: User){
//        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
//        chatLogController.user = user
//        let chatLogNav = UINavigationController(rootViewController: chatLogController)
//        present(chatLogNav, animated: true, completion: nil)
//    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userInfo = blacklistArray[indexPath.row] as AnyObject
        let chatPartnerId = userInfo.value(forKey: "userId") as! String
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observe(.value, with: { (snapshot) in
            print(snapshot)
            guard (snapshot.value as?  [String: Any]) != nil else {
                return
            }
            let user = User()
            user.id = chatPartnerId
            user.email = (snapshot.value as? NSDictionary)?["email"] as? String ?? ""
            user.name = (snapshot.value as? NSDictionary)?["name"] as? String ?? ""
            user.profileImageUrl = (snapshot.value as? NSDictionary)?["profileImageUrl"] as? String ?? ""
//            self.showChatControllerForUser(user: user)
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
        let userInfo = blacklistArray[indexPath.row] as AnyObject
        let memberUid = userInfo.value(forKey: "userId") as! String
        print("chatPartnerId: ", memberUid, "uid: ", uid)
        
        let delFromBlaclist = ref.child("users-blacklists").child(uid).child(memberUid)
        delFromBlaclist.removeValue()
        self.blacklistArray.remove(at: indexPath.row)
        self.attemptReloadOfTable()
    }
}