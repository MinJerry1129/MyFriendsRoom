//
//  WishlistController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 03.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
import Alamofire


class WishlistController: UITableViewController {
    var youAreBanned = false
    
    
    let optionsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let goToLikeMeButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(goToLikeMe), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("People who like me", for: .normal)
        cb.backgroundColor = UIColor.white
        cb.setTitleColor(CustomColors.commonGrey1, for: .normal)
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cb
    }()
    func optionsContainerSetup(){
        view.addSubview(optionsContainer)
        optionsContainer.addSubview(goToLikeMeButton)
        let screenWidth = UIScreen.main.bounds.width
        optionsContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: screenWidth - 10).isActive = true
        optionsContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        optionsContainer.widthAnchor.constraint(equalToConstant: 200).isActive = true
        optionsContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        optionsContainer.isHidden = true
        
        goToLikeMeButton.topAnchor.constraint(equalTo: optionsContainer.topAnchor).isActive = true
        goToLikeMeButton.centerXAnchor.constraint(equalTo: optionsContainer.centerXAnchor).isActive = true
        goToLikeMeButton.widthAnchor.constraint(equalTo: optionsContainer.widthAnchor).isActive = true
        goToLikeMeButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    @objc func goToLikeMe(){
        optionsContainer.isHidden = true
        let likeMeController = LikeMeController()
        let navController = UINavigationController(rootViewController: likeMeController)
        present(navController, animated: true, completion: nil)
    }
    let ref = Database.database().reference(fromURL: "https://myfriendsroomtest.firebaseio.com/")
//    var addButtonsExclusions = [String]()
    var wishlistArray: Array = Array<Any>()
    let cellId = "cellId"
    
    @objc func reloadWishlist(){
        takeWisglist()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfYouAreBanned()
        takeWisglist()
        optionsContainerSetup()
        setupNavBarItems()
        tableView.register(WishlistCell.self, forCellReuseIdentifier: cellId)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWishlist), name: NSNotification.Name(rawValue: "newSignin"), object: nil)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlistArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WishlistCell
        cell.textLabel?.textColor = CustomColors.commonGrey1
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        let arrayIndexPathItem = wishlistArray[indexPath.row] as AnyObject
        let input_name = arrayIndexPathItem.value(forKey: "name") as? String
        let profileImageUrl = arrayIndexPathItem.value(forKey: "profileImageUrl") as? String
        let memberId = arrayIndexPathItem.value(forKey: "userId") as? String
//        for singleExclusion in addButtonsExclusions {
//            if singleExclusion == memberId {
//                cell.addButton.isHidden = true
//            }
//        }
        cell.textLabel?.text = input_name
        
        if profileImageUrl == "empty" {
            cell.profileImageView.image = UIImage(named: "emptyavatar")
        } else if profileImageUrl == "deleted" {
            cell.profileImageView.image = UIImage(named: "deletedprofile")
        } else {
            cell.profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
        }
//        cell.profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
//        cell.addButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        cell.viewButton.tag = indexPath.row
        return cell
    }
    func takeWisglist() {
        print("take wish func")
        wishlistArray = []
        let uid = Auth.auth().currentUser!.uid
        let wishList = Database.database().reference().child("users-wishlists").child(uid)
        wishList.observe(.childAdded, with: { (snapshot) in
            let wishlistItem = snapshot.key
            print(wishlistItem)
            let ref = Database.database().reference().child("users").child(wishlistItem)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                print("take wish observe")
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
                self.wishlistArray.append(singleUserArray)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        })
    }
//    @objc func addFriend(_ sender: UIButton){
//        let alert = UIAlertController(title: "Add to friend?", message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {action in
//            sender.isHidden = true
//            let memberUid = (self.wishlistArray[sender.tag] as AnyObject).value(forKey: "userId") as! String
//            goToControllerByMemberUid = memberUid
//            let uid = Auth.auth().currentUser!.uid
//            let ref = Database.database().reference(fromURL: "https://myfriendsroomtest.firebaseio.com/")
//            print("ref type: ", type(of: ref))
//            let curentFriends = Database.database().reference().child("users-friends").child(uid)
//            var itIsAFriend = false
//            let freobserve = ref.child("users-friends").child(uid)
//            freobserve.updateChildValues(["temp": 1])
//            curentFriends.observeSingleEvent(of: .value) { (friendsnap) in
//                for friendUid in friendsnap.children.allObjects as! [DataSnapshot]{
//                    if friendUid.key == goToControllerByMemberUid{
//                        itIsAFriend = true
//                    }
//                }
//                let removeFriendTemp = ref.child("users-friends").child(uid).child("temp")
//                removeFriendTemp.removeValue()
//                if itIsAFriend == false {
//                    let observe = ref.child("users-friends-proposals").child(uid)
//                    var concidence = false
//                    let preobserve = ref.child("users-friends-proposals").child(uid)
//                    preobserve.updateChildValues(["temp": 1])
//                    observe.observeSingleEvent(of: .childAdded, with: { (snap) in
//                        if snap.key == "received" {
//                            print("in received")
//                            for child in snap.children {
//                                let childKey = (child as! DataSnapshot).key
//                                print(childKey)
//                                if childKey == memberUid && concidence == false {
//                                    concidence = true
//                                }
//                            }
//                        }
//                        if concidence == false {
//                            print("sent friend proposal")
//                            let currUserAddFriendProposal = ref.child("users-friends-proposals").child(uid).child("sent-to")
//                            currUserAddFriendProposal.updateChildValues([memberUid: 1])
//                            let friendUserAddCurrentProposal = ref.child("users-friends-proposals").child(memberUid).child("received")
//                            friendUserAddCurrentProposal.updateChildValues([uid: 1])
//                            self.sentProposalNotification(toId: memberUid, fromId: uid)
//                        } else {
//                            print("remove proposal and add friend")
//                            let currUserRemoveFriendProposal = ref.child("users-friends-proposals").child(uid).child("received").child(memberUid)
//                            currUserRemoveFriendProposal.removeValue()
//                            print(currUserRemoveFriendProposal)
//                            let friendUserRemoveCurrentProposal = ref.child("users-friends-proposals").child(memberUid).child("sent-to").child(uid)
//                            friendUserRemoveCurrentProposal.removeValue()
//                            print(friendUserRemoveCurrentProposal)
//                            let currUserAddFriend = ref.child("users-friends").child(uid)
//                            currUserAddFriend.updateChildValues([memberUid: 1])
//                            let friendUserAddCurrent = ref.child("users-friends").child(memberUid)
//                            friendUserAddCurrent.updateChildValues([uid: 1])
//                        }
//                        let removePropTemp = ref.child("users-friends-proposals").child(uid).child("temp")
//                        removePropTemp.removeValue()
//                    }, withCancel: nil)
//                }
//            }
//        }))
//        self.present(alert, animated: true)
//    }
//    func sentProposalNotification(toId: String, fromId: String) {
//        Database.database().reference().child("users").child(fromId).observeSingleEvent(of: .value) { (snapshot) in
//
//            guard let dictionary = snapshot.value as? [String:Any] else {return}
//            let name = dictionary["name"] as! String
//
//            print(name)
//
//            Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value) { (snapshot) in
//                guard let dictionary = snapshot.value as? [String:Any] else {return}
//                let fromDevice = dictionary["fromDevice"] as! String
//
//                print(fromDevice)
//
//                let title = "MyFriendsRoom"
//                let body = "\(name) wants to add you to friend"
//                let toDeviceID = fromDevice
//
//                var headers:HTTPHeaders = HTTPHeaders()
//                headers = ["Content-Type":"application/json", "Authorization":"key=\(AppDelegate.SERVERKEY)"]
//                let notification = ["to":"\(toDeviceID)", "notification":["body":body, "title":title, "badge":1, "sound":"default"]] as [String : Any]
//
//                Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
//                }
//            }
//        }
//    }
    
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
        myImagesURLSArray = [String]()
        self.dismiss(animated: true, completion: nil)
    }
    func setupNavBarItems(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.lightOrange1]
        self.navigationItem.title = "My likes"
        let backImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        let optionsImage = UIImage(named: "dotmenu")?.withRenderingMode(.alwaysOriginal)
//        let optionsButton = UIBarButtonItem(image: optionsImage, style: .plain, target: self, action: #selector(hideUnhideOptions)) goToLikeMe
//        let optionsButton = UIBarButtonItem(title: "Likes me", style: .plain, target: self, action: #selector(hideUnhideOptions))
        let optionsButton = UIBarButtonItem(title: "Likes me", style: .plain, target: self, action: #selector(goToLikeMe))
        optionsButton.tintColor = CustomColors.commonBlue1
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = optionsButton
    }
    @objc func hideUnhideOptions(){
        print(optionsContainer.frame)
        if optionsContainer.isHidden == true {
            optionsContainer.isHidden = false
        } else {
            optionsContainer.isHidden = true
        }
    }
    @objc func viewProfile(_ sender: UIButton){
        checkIfYouAreBanned()
        let memberUid = (wishlistArray[sender.tag] as AnyObject).value(forKey: "userId") as! String
        goToControllerByMemberUid = memberUid
        let memberProfileController = MemberProfileController()
        let memberProfileNav = UINavigationController(rootViewController: memberProfileController)
        self.present(memberProfileNav, animated: true, completion: nil)
    }
    @objc func deleteFromWishlist(_ sender: UIButton){
        checkIfYouAreBanned()
        let memberUid = (wishlistArray[sender.tag] as AnyObject).value(forKey: "userId") as! String
        goToControllerByMemberUid = memberUid
        print("deleteFromWishlist: ", memberUid)
        let uid = Auth.auth().currentUser!.uid
        let wishReference = Database.database().reference().child("users-wishlists")
        let likesReference = Database.database().reference().child("users-likes")
        wishReference.child(uid).child(memberUid).removeValue { (error, ref) in
            if error != nil {
                print("Error to delete message: ", error!)
                return
            }
            self.wishlistArray.remove(at: sender.tag)
            let indextPath = IndexPath(item: sender.tag, section: 0)
            self.tableView.deleteRows(at: [indextPath], with: .automatic)
            self.tableView.reloadData()
        }
        likesReference.child(memberUid).child(uid).removeValue { (error, ref) in
            if error != nil {
                print("Error to delete message: ", error!)
                return
            }
        }
    }
//    func observeSingleByObRef(observe: DatabaseReference){
//        print("type: ", type(of: observe))
//        observe.observeSingleEvent(of: .value, with: { (snap) in
//            for child in snap.children.allObjects as! [DataSnapshot] {
//                self.addButtonsExclusions.append(child.key)
//            }
//        })
//    }
//    func setupFriendsList(){
//        let uid = Auth.auth().currentUser!.uid
//        let observe = ref.child("users-friends").child(uid)
//        observeSingleByObRef(observe: observe)
//    }
//    func setupAddButtonExclussionsList(){
//        let uid = Auth.auth().currentUser!.uid
//        let observe = ref.child("users-friends-proposals").child(uid).child("sent-to")
//        observeSingleByObRef(observe: observe)
//    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
