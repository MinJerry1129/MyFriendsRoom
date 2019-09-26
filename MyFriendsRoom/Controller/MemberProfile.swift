//
//  MemberProfile.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 25.09.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

    
import UIKit
import Firebase
import Alamofire


//var imagesURLSArray = [String]()
//var profileImagesURLSArray = [String]()
//var albumSelected = String()

class MemberProfileController: UIViewController {
    
    var imagesURLSArray = [String]()
    var profileImagesURLSArray = [String]()
    
    let acceptText = "Accepted your friend request"
    let likeText = "Likes You"
    let wantBeFriendText = "Wants to be your friend"
    let notifWantToBe = "wants to be your friend"
    let notifAccept = "accepted your friend request"
    let notifLike = "likes you"
    var aboutServicesEnabled = false
    var itIsAFriend = false
    var offerServiseChecked = false
    var friendshipProposal = ""
    var curLoc: String? = "..."
//    let uid = Auth.auth().currentUser?.uid
    var inWishList: Bool?
    var aboutMe: String?
    var aboutMyPlace: String?
    var isInWishlist: Bool?
    var friendHolderArray = [String]()
    var inBlacklist = false
    var inFoFArray = false
    var inFriendsLineArray = false
    var youAreInBlacklist = false
    var userWasDeleted = false
    var youAreBanned = false
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileAvatarView: UIImageView!
    @IBOutlet weak var connectionIndicatorLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var friendshipActionButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    

    
    let optionsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    let addToBlacklistButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(addToBalcklistAction), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("Block", for: .normal)
        cb.backgroundColor = UIColor.white
        cb.setTitleColor(CustomColors.commonGrey1, for: .normal)
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cb
    }()
    let blackListSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let reportButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(reportAction), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("Report", for: .normal)
        cb.setTitleColor(CustomColors.commonGrey1, for: .normal)
        cb.backgroundColor = UIColor.white
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cb
    }()
    
    
    
    // MARK: - Data
    
    func getImagesURLSArray(){
        imagesURLSArray = []
        profileImagesURLSArray = []
        let ref = Database.database().reference().child("user-apartments-images").child(goToControllerByMemberUid!)
        ref.observeSingleEvent(of: .value) { (snap) in
            for child in snap.children.allObjects as! [DataSnapshot]{
                let imageURL = child.value as! String
                self.imagesURLSArray.insert(imageURL, at: 0)
            }
            // OK there is something here
            
            
            // This triggers refresh
        }
        let pref = Database.database().reference().child("user-profile-images").child(goToControllerByMemberUid!)
        pref.observeSingleEvent(of: .value) { (prsnap) in
            print("prsnap: ",prsnap)
            var snapshotValueExist = false
            for prchild in prsnap.children.allObjects as! [DataSnapshot]{
                snapshotValueExist = true
                let imageURL = prchild.value as! String
                self.profileImagesURLSArray.insert(imageURL, at: 0)
            }
            print("snapshotValueExist: ", snapshotValueExist)
            if snapshotValueExist == false {
                self.profileImagesURLSArray.insert(self.profileImageUrlG!, at: 0)
            }
            
            
            // This triggers refresh
            
            DispatchQueue.main.async {
                self.albumCollectionView.reloadData()
                /*
                var frame = self.webView.frame
                frame.size = self.webView.scrollView.contentSize
                self.webView.frame = frame
                
                
                var contentRect = CGRect.zero
                
                for view in self.scrollView.subviews {
                    contentRect = contentRect.union(view.frame)
                }
                self.scrollView.contentSize = contentRect.size*/
            }
        }
    }
    
    
    // MARK: Actions
    
    @objc func seeMemberImages(){
        checkIfYouAreBanned()
        print("go to galery")
        //        albumSelected = "home"
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let memberPhotos = MemberPhotosController(collectionViewLayout: layout)
        memberPhotos.picsArray = imagesURLSArray
        let memberPhotosNav = UINavigationController(rootViewController: memberPhotos)
        self.present(memberPhotosNav, animated: true, completion: nil)
        //        self.present(memberPhotos, animated: true, completion: nil)
        //        self.navigationController?.pushViewController(memberPhotos, animated: true)
    }
    @objc func seeMemberProfileImages(){
        checkIfYouAreBanned()
        print("go to galery")
        if profileImagesURLSArray.count > 0 {
            //            albumSelected = "profile"
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let memberPhotos = MemberPhotosController(collectionViewLayout: layout)
            memberPhotos.picsArray = profileImagesURLSArray
            let memberPhotosNav = UINavigationController(rootViewController: memberPhotos)
            self.present(memberPhotosNav, animated: true, completion: nil)
            //            self.present(memberPhotos, animated: true, completion: nil)
            //            self.navigationController?.pushViewController(memberPhotos, animated: true)
        }
    }
    
    
    
    
    
    // MARK: Some actions about user not existing
    
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
    @objc func addToBalcklistAction(){
        let uid = Auth.auth().currentUser?.uid
        if inBlacklist == false {
            let alert = UIAlertController(title: "Add to blacklist?", message: "You will no longer be able to see this person in:\nSearch results\nFriends list\nFriends of friends list\nWishlist\n\nIf you're friends, blocking this user will also unfriend him.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {action in
                let ref = Database.database().reference()
                let currUserAddToBlacklist = ref.child("users-blacklists").child(uid!)
                currUserAddToBlacklist.updateChildValues([goToControllerByMemberUid!: 1])
                self.setupUserBlockedStatus()
                self.deleteUserFromEverywhere()
            }))
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Unblock this user?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {action in
                let ref = Database.database().reference()
                let currUserDeleteFromBlacklist = ref.child("users-blacklists").child(uid!).child(goToControllerByMemberUid!)
                currUserDeleteFromBlacklist.removeValue()
                self.setupUserBlockedStatus()
//                self.friendText.isHidden = true
                
                self.friendTextHeightAnchor?.isActive = false
                self.friendTextHeightAnchor?.isActive = true
                self.setFriendshipStatus()
            }))
            self.present(alert, animated: true)
        }
        
    }
    @objc func reportAction(){
        let alert = UIAlertController(title: "Report this user?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {action in
            print("report")
            reportMethod = "profile"
            let reportController = ReportController()
            let reportControllerNav = UINavigationController(rootViewController: reportController)
            self.present(reportControllerNav, animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    
    
    func deleteUserFromEverywhere(){
        let uid = Auth.auth().currentUser?.uid
        if itIsAFriend == true {
            let ref = Database.database().reference()
            let currUserDelFriend = ref.child("users-friends").child(uid!).child(goToControllerByMemberUid!)
            currUserDelFriend.removeValue()
            let friendUserDelCurrent = ref.child("users-friends").child(goToControllerByMemberUid!).child(uid!)
            friendUserDelCurrent.removeValue()
        } else {
            let refPropRec = Database.database().reference().child("users-friends-proposals").child(uid!).child("received").child(goToControllerByMemberUid!)
            refPropRec.observeSingleEvent(of: .value) { (propRecSnap) in
                let snapValueType = type(of: propRecSnap.value!)
                if snapValueType != NSNull.self {
                    let ref = Database.database().reference()
                    let currUserRemoveFriendProposal = ref.child("users-friends-proposals").child(uid!).child("received").child(goToControllerByMemberUid!)
                    currUserRemoveFriendProposal.removeValue()
                    print(currUserRemoveFriendProposal)
                    let friendUserRemoveCurrentProposal = ref.child("users-friends-proposals").child(goToControllerByMemberUid!).child("sent-to").child(uid!)
                    friendUserRemoveCurrentProposal.removeValue()
                    print(friendUserRemoveCurrentProposal)
                } else {
                    let refPropSent = Database.database().reference().child("users-friends-proposals").child(uid!).child("sent-to").child(goToControllerByMemberUid!)
                    refPropSent.observeSingleEvent(of: .value) { (propSentSnap) in
                        let sentSnapValType = type(of: propSentSnap.value!)
                        if sentSnapValType != NSNull.self {
                            let ref = Database.database().reference()
                            let currUserRemoveFriendProposal = ref.child("users-friends-proposals").child(uid!).child("sent-to").child(goToControllerByMemberUid!)
                            currUserRemoveFriendProposal.removeValue()
                            print(currUserRemoveFriendProposal)
                            let friendUserRemoveCurrentProposal = ref.child("users-friends-proposals").child(goToControllerByMemberUid!).child("received").child(uid!)
                            friendUserRemoveCurrentProposal.removeValue()
                            print(friendUserRemoveCurrentProposal)
                        }
                    }
                }
            }
        }
        if inFoFArray == true {
            yourFriendsOfFriendsArray.removeValue(forKey: goToControllerByMemberUid!)
        }
    }
    func setupYouInBlacklistStatus(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users-blacklists").child(goToControllerByMemberUid!).child(uid!)
        ref.observeSingleEvent(of: .value) { (snap) in
            let snapValueType = type(of: snap.value!)
            if snapValueType != NSNull.self {
                print("You are in blacklist of this user")
                self.youAreInBlacklist = true
                self.hideUiIfInBlacklist(whoBlacklisted: "you")
                let alert = UIAlertController(title: "This user has blacklisted you", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    func setupUserBlockedStatus(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users-blacklists").child(uid!).child(goToControllerByMemberUid!)
        ref.observeSingleEvent(of: .value) { (snap) in
            let snapValueType = type(of: snap.value!)
            if snapValueType == NSNull.self {
                print("not in blacklist")
                self.inBlacklist = false
                self.unhideUiWhenUnblock()
            } else {
                print("in black list")
                self.inBlacklist = true
                self.hideUiIfInBlacklist(whoBlacklisted: "user")
                
                self.friendTextHeightAnchor?.isActive = false
                self.friendTextHeightAnchor?.isActive = true
            }
        }
    }
    func hideUiIfInBlacklist(whoBlacklisted: String){
        self.hidlikeButton()
        self.friendshipActionButton.isHidden = true
        self.contactButton.isHidden = true
        if whoBlacklisted == "user" {
            self.addToBlacklistButton.setTitle("Unblock", for: .normal)
        }
            
            // TODO: Missing code
//        else if self.friendText.text != "Blocked"{
//            self.friendText.text = ""
//            self.friendTextHeightAnchor?.isActive = false
//            self.friendTextHeightAnchor = self.friendText.heightAnchor.constraint(equalToConstant: 0)
//            self.friendTextHeightAnchor?.isActive = true
//        }
    }
    func unhideUiWhenUnblock(){
        self.setFriendshipStatus()
        if inBlacklist == false && youAreInBlacklist == false {
            if userWasDeleted == false {
                self.contactButton.isHidden = false
            }
        }
        self.addToBlacklistButton.setTitle("Block", for: .normal)
    }
    
    func isInYourWishlist(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users-wishlists").child(uid!)
        ref.observeSingleEvent(of: .value) { (snap) in
            for child in snap.children.allObjects as! [DataSnapshot] {
                if child.key == goToControllerByMemberUid{
                    self.isInWishlist = true
                }
            }
            if self.isInWishlist == true {
                print("Yes. in wishlist")
                self.hidlikeButton()
            }
        }
    }
    func hidlikeButton(){
        likeButton.isHidden = true
    }
    @objc func goBack() {
        imagesURLSArray = [String]()
        self.dismiss(animated: true, completion: nil)
        
        navigationController?.popViewController(animated: true)
        
    }
    func optionsContainerSetup(){
        view.addSubview(optionsContainer)
        optionsContainer.addSubview(addToBlacklistButton)
        optionsContainer.addSubview(blackListSeperatorView)
        optionsContainer.addSubview(reportButton)
        
        optionsContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        optionsContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        optionsContainer.widthAnchor.constraint(equalToConstant: 70).isActive = true
        optionsContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        optionsContainer.isHidden = true
        
        addToBlacklistButton.topAnchor.constraint(equalTo: optionsContainer.topAnchor).isActive = true
        addToBlacklistButton.centerXAnchor.constraint(equalTo: optionsContainer.centerXAnchor).isActive = true
        addToBlacklistButton.widthAnchor.constraint(equalTo: optionsContainer.widthAnchor).isActive = true
        addToBlacklistButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        blackListSeperatorView.topAnchor.constraint(equalTo: addToBlacklistButton.bottomAnchor).isActive = true
        blackListSeperatorView.centerXAnchor.constraint(equalTo: addToBlacklistButton.centerXAnchor).isActive = true
        blackListSeperatorView.widthAnchor.constraint(equalTo: addToBlacklistButton.widthAnchor).isActive = true
        blackListSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        reportButton.topAnchor.constraint(equalTo: addToBlacklistButton.bottomAnchor, constant: 2).isActive = true
        reportButton.centerXAnchor.constraint(equalTo: addToBlacklistButton.centerXAnchor).isActive = true
        reportButton.widthAnchor.constraint(equalTo: addToBlacklistButton.widthAnchor).isActive = true
        reportButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    func setupNavBarItems(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.commonGrey1]
        let backImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
        let optionsImage = UIImage(named: "dotmenu")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        let optionsButton = UIBarButtonItem(image: optionsImage, style: .plain, target: self, action: #selector(hideUnhideOptions))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = optionsButton
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.commonGrey1]
        self.navigationItem.title = "Profile"
    }
    
    @objc func hideUnhideOptions(){
        if optionsContainer.isHidden == true {
            optionsContainer.isHidden = false
        } else {
            optionsContainer.isHidden = true
        }
    }
    
    @IBAction func addToWishlist(){
        checkIfYouAreBanned()
        let addItToWishlistByUid = goToControllerByMemberUid
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference(fromURL: "https://myfriendsroomtest.firebaseio.com/")
        let usersReference = ref.child("users-wishlists").child(uid)
        usersReference.updateChildValues([addItToWishlistByUid!: 1])
        let likesReference = ref.child("users-likes").child(goToControllerByMemberUid!)
        likesReference.updateChildValues([uid: 1])
        self.whriteToUserNotification(text: likeText)
        self.sentProposalNotification(toId: goToControllerByMemberUid!, fromId: uid, text: self.notifLike)
        hidlikeButton()
        print("Add to wishlist")
        inWishList = true
    }
    @IBAction func contactMember(){
        checkIfYouAreBanned()
        let contactMemberController = ContactMemberController()
        let contactMemberNav = UINavigationController(rootViewController: contactMemberController)
        self.present(contactMemberNav, animated: true, completion: nil)
    }
    @IBAction func friendshipAction(){
        checkIfYouAreBanned()
        let uid = Auth.auth().currentUser?.uid
        let friendsRef = Database.database().reference().child("users-friends").child(uid!)
        friendsRef.updateChildValues(["temp": 1])
        friendsRef.observeSingleEvent(of: .value) { (friendssnap) in
            for value in friendssnap.children.allObjects as! [DataSnapshot]{
                if value.key == goToControllerByMemberUid{
                    self.itIsAFriend = true
                }
            }
            if self.itIsAFriend == true {
                self.deleteFriendAction()
            } else {
                self.friendShipProposalRevision()
            }
        }
        let removeFriendTemp = friendsRef.child("temp")
        removeFriendTemp.removeValue()
    }
    func friendShipProposalRevision(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users-blacklists").child(goToControllerByMemberUid!).child(uid!)
        ref.observeSingleEvent(of: .value) { (snap) in
            let snapValueType = type(of: snap.value!)
            if snapValueType != NSNull.self {
                self.inBlacklist = true
                self.hideUiIfInBlacklist(whoBlacklisted: "you")
                let alert = UIAlertController(title: "This user has blacklisted you", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                let curentFriends = Database.database().reference().child("users-friends").child(uid!)
                curentFriends.observeSingleEvent(of: .value) { (friendsnap) in
                    for friendUid in friendsnap.children.allObjects as! [DataSnapshot]{
                        if friendUid.key == goToControllerByMemberUid{
                            self.itIsAFriend = true
                        }
                    }
                    if self.itIsAFriend == false {
                        let proposalsRef = Database.database().reference().child("users-friends-proposals").child(uid!)
                        proposalsRef.child("received").observeSingleEvent(of: .value) { (propsnap) in
                            for proposalReceivedUid in propsnap.children.allObjects as! [DataSnapshot]{
                                if proposalReceivedUid.key == goToControllerByMemberUid{
                                    self.friendshipProposal = "received"
                                }
                            }
                            if self.friendshipProposal == "received" {
                                self.acceptFriendProposalAction()
                            } else {
                                proposalsRef.child("sent-to").observeSingleEvent(of: .value) { (propsnapsent) in
                                    for proposalSentUid in propsnapsent.children.allObjects as! [DataSnapshot]{
                                        if proposalSentUid.key == goToControllerByMemberUid{
                                            self.friendshipProposal = "sent-to"
                                        }
                                    }
                                    if self.friendshipProposal == "sent-to"{
                                        self.cancelFriendProposalAction()
                                    } else {
                                        self.addToFriendsAction()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func addToFriendsAction(){
        checkIfYouAreBanned()
        let uid = Auth.auth().currentUser?.uid
        let alert = UIAlertController(title: "Add friend?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {action in
            let ref = Database.database().reference()
            let observe = ref.child("users-friends-proposals").child(uid!)
            var concidence = false
            let preobserve = ref.child("users-friends-proposals").child(uid!)
            preobserve.updateChildValues(["temp": 1])
            observe.observeSingleEvent(of: .childAdded, with: { (snap) in
                if snap.key == "received" {
                    for child in snap.children {
                        let childKey = (child as! DataSnapshot).key
                        print(childKey)
                        if childKey == goToControllerByMemberUid && concidence == false {
                            concidence = true
                        }
                    }
                }
                if concidence == false {
                    let currUserAddFriendProposal = ref.child("users-friends-proposals").child(uid!).child("sent-to")
                    currUserAddFriendProposal.updateChildValues([goToControllerByMemberUid!: 1])
                    let friendUserAddCurrentProposal = ref.child("users-friends-proposals").child(goToControllerByMemberUid!).child("received")
                    friendUserAddCurrentProposal.updateChildValues([uid!: 1])
                    self.sentProposalNotification(toId: goToControllerByMemberUid!, fromId: uid!, text: self.notifWantToBe)
                    self.whriteToUserNotification(text: self.wantBeFriendText)
                } else {
                    let currUserRemoveFriendProposal = ref.child("users-friends-proposals").child(uid!).child("received").child(goToControllerByMemberUid!)
                    currUserRemoveFriendProposal.removeValue()
                    print(currUserRemoveFriendProposal)
                    let friendUserRemoveCurrentProposal = ref.child("users-friends-proposals").child(goToControllerByMemberUid!).child("sent-to").child(uid!)
                    friendUserRemoveCurrentProposal.removeValue()
                    print(friendUserRemoveCurrentProposal)
                    let currUserAddFriend = ref.child("users-friends").child(uid!)
                    currUserAddFriend.updateChildValues([goToControllerByMemberUid!: 1])
                    let friendUserAddCurrent = ref.child("users-friends").child(goToControllerByMemberUid!)
                    friendUserAddCurrent.updateChildValues([uid!: 1])
                    self.whriteToUserNotification(text: self.acceptText)
                    self.sentProposalNotification(toId: goToControllerByMemberUid!, fromId: uid!, text: self.notifAccept)
                }
                let removeTemp = ref.child("users-friends-proposals").child(uid!).child("temp")
                removeTemp.removeValue()
                self.hideFriendshipActionButton()
            })
        }))
        self.present(alert, animated: true)
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
    func cancelFriendProposalAction(){
        let uid = Auth.auth().currentUser?.uid
        let alert = UIAlertController(title: "Cancel request?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {action in
            let ref = Database.database().reference()
            let currUserRemoveFriendProposal = ref.child("users-friends-proposals").child(uid!).child("sent-to").child(goToControllerByMemberUid!)
            currUserRemoveFriendProposal.removeValue()
            print(currUserRemoveFriendProposal)
            let friendUserRemoveCurrentProposal = ref.child("users-friends-proposals").child(goToControllerByMemberUid!).child("received").child(uid!)
            friendUserRemoveCurrentProposal.removeValue()
            print(friendUserRemoveCurrentProposal)
            self.hideFriendshipActionButton()
        }))
        self.present(alert, animated: true)
    }
    func acceptFriendProposalAction(){
        let uid = Auth.auth().currentUser?.uid
        let alert = UIAlertController(title: "Accept friend?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {action in
            let ref = Database.database().reference()
            let currUserRemoveFriendProposal = ref.child("users-friends-proposals").child(uid!).child("received").child(goToControllerByMemberUid!)
            currUserRemoveFriendProposal.removeValue()
            print(currUserRemoveFriendProposal)
            let friendUserRemoveCurrentProposal = ref.child("users-friends-proposals").child(goToControllerByMemberUid!).child("sent-to").child(uid!)
            friendUserRemoveCurrentProposal.removeValue()
            print(friendUserRemoveCurrentProposal)
            let currUserAddFriend = ref.child("users-friends").child(uid!)
            currUserAddFriend.updateChildValues([goToControllerByMemberUid!: 1])
            let friendUserAddCurrent = ref.child("users-friends").child(goToControllerByMemberUid!)
            friendUserAddCurrent.updateChildValues([uid!: 1])
            self.hideFriendshipActionButton()
            self.whriteToUserNotification(text: self.acceptText)
            self.sentProposalNotification(toId: goToControllerByMemberUid!, fromId: uid!, text: self.notifAccept)
        }))
        self.present(alert, animated: true)
    }
    func whriteToUserNotification(text: String) {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let notificationRef = ref.child("users-notifications").child(goToControllerByMemberUid!)
        let childRef = notificationRef.childByAutoId()
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let values = ["text": text, "timestamp": timestamp, "senderUid": uid] as [String : Any]
        childRef.updateChildValues(values)
    }
    func deleteFriendAction(){
        let uid = Auth.auth().currentUser?.uid
        let alert = UIAlertController(title: "Delete friend?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {action in
//            self.present(alert, animated: true)
            let ref = Database.database().reference()
            let currUserDelFriend = ref.child("users-friends").child(uid!).child(goToControllerByMemberUid!)
            currUserDelFriend.removeValue()
            let friendUserDelCurrent = ref.child("users-friends").child(goToControllerByMemberUid!).child(uid!)
            friendUserDelCurrent.removeValue()
            self.hideFriendshipActionButton()
        }))
        self.present(alert, animated: true)
    }
    func hideFriendshipActionButton(){
   //     friendshipActionButton.heightAnchor.constraint(equalToConstant: 0).isActive = true
   //     friendshipActionButton.titleLabel?.heightAnchor.constraint(equalToConstant: 0).isActive = true
        friendshipActionButton.isHidden = true
    }
    func acceptFriendshipProposalSetup(){
 //       friendshipActionButton.titleLabel?.leftAnchor.constraint(equalTo: friendshipActionButton.leftAnchor).isActive = true
        friendshipActionButton.setTitle("accept request", for: .normal)
        friendshipActionButton.titleLabel?.textColor = CustomColors.commonBlue1
   //     scrollView.addSubview(friendshipActionButton)
   //     friendshipActionButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
   //     friendshipActionButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
   //     friendshipActionButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func proposalWasSentButtonSetup(){
    //    friendshipActionButton.titleLabel?.leftAnchor.constraint(equalTo: friendshipActionButton.leftAnchor).isActive = true
        friendshipActionButton.setTitle("cancel request", for: .normal)
        friendshipActionButton.titleLabel?.textColor = CustomColors.commonBlue1
   //     scrollView.addSubview(friendshipActionButton)
   //     friendshipActionButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
   //     friendshipActionButton.widthAnchor.constraint(equalToConstant: 145).isActive = true
   //     friendshipActionButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func deleteFromFriendsButtonSetup(){
    //    friendshipActionButton.titleLabel?.leftAnchor.constraint(equalTo: friendshipActionButton.leftAnchor).isActive = true
        friendshipActionButton.setTitle("remove friend", for: .normal)
        friendshipActionButton.titleLabel?.textColor = CustomColors.commonBlue1
 //       scrollView.addSubview(friendshipActionButton)
// //       friendshipActionButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
//        friendshipActionButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
//        friendshipActionButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let string = "FRIEND"
        let stringLen = string.count
        let attributedStr = NSMutableAttributedString.init(string: string)
        attributedStr.addAttribute(.foregroundColor, value: CustomColors.lightOrange1, range: NSRange(location: 0, length: stringLen))
    }
    func addToFriendsButtonSetup(){
    //    friendshipActionButton.titleLabel?.leftAnchor.constraint(equalTo: friendshipActionButton.leftAnchor).isActive = true
        friendshipActionButton.setTitle("add friend", for: .normal)
    }
    
    
    func setFriendshipStatus(){
        inFoFArray = false
        var commonFriend = ""
        let uid = Auth.auth().currentUser?.uid
        let friendsRef = Database.database().reference().child("users-friends").child(uid!)
        friendsRef.observeSingleEvent(of: .value) { (friendssnap) in
            for value in friendssnap.children.allObjects as! [DataSnapshot]{
                print("value.key: ", value.key, "goToControllerByMemberUid:",  goToControllerByMemberUid!)
                if value.key == goToControllerByMemberUid {
                    self.itIsAFriend = true
                }
            }
            if self.itIsAFriend == true {
                self.deleteFromFriendsButtonSetup()
            }
            for (singleFoFKey, singleFoFValue) in yourFriendsOfFriendsArray{
                if singleFoFKey == goToControllerByMemberUid{
                    self.inFoFArray = true
                    if singleFoFValue != "friend"{
                        commonFriend = singleFoFValue
                    }
                }
            }
            let proposalsRef = Database.database().reference().child("users-friends-proposals").child(uid!)
            proposalsRef.child("received").observeSingleEvent(of: .value) { (propsnap) in
                for proposalReceivedUid in propsnap.children.allObjects as! [DataSnapshot]{
                    if proposalReceivedUid.key == goToControllerByMemberUid{
                        self.friendshipProposal = "received"
                    }
                }
                if self.friendshipProposal == "received" {
                    self.acceptFriendshipProposalSetup()
                } else {
                    proposalsRef.child("sent-to").observeSingleEvent(of: .value) { (propsnapsent) in
                        //print("propsnap: ", propsnapsent)
                        for proposalSentUid in propsnapsent.children.allObjects as! [DataSnapshot]{
                            if proposalSentUid.key == goToControllerByMemberUid{
                                self.friendshipProposal = "sent-to"
                            }
                        }
                        if self.friendshipProposal == "sent-to" {
                            self.proposalWasSentButtonSetup()
                        } else if self.friendshipProposal == "" && self.itIsAFriend == false{
                            self.addToFriendsButtonSetup()
                        }
                    }
                }
            }
            if self.inFoFArray == true {
                if self.itIsAFriend == true{
                    self.deleteFromFriendsButtonSetup()
                    let string = "FRIEND"
                    let stringLen = string.count
                    let attributedStr = NSMutableAttributedString.init(string: string)
                    attributedStr.addAttribute(.font, value: UIFont(name: "HelveticaNeue-Medium", size: 11.0)!, range: NSRange(location: 0, length: stringLen))
                    attributedStr.addAttribute(.foregroundColor, value: CustomColors.lightOrange1, range: NSRange(location: 0, length: stringLen))
                    
                    self.connectionIndicatorLabel.attributedText = attributedStr
                    
                } else {
                    print("commonFriend: ",commonFriend)
                    let ref = Database.database().reference().child("users").child(commonFriend)
                    ref.observeSingleEvent(of: .value) { (snap) in
                        guard let value = snap.value as? [String: Any] else { return }
                        let name = value["name"] as? String
                        print("common friend is: ", name!)
                        let string = "FRIEND of " + name!
                        let stringLen = string.count
                        let attributedStr = NSMutableAttributedString.init(string: string)
                        attributedStr.addAttribute(.font, value: UIFont(name: "HelveticaNeue-Medium", size: 11.0)!, range: NSRange(location: 0, length: stringLen))
                        attributedStr.addAttribute(.foregroundColor, value: CustomColors.commonGrey1, range: NSRange(location: 0, length: stringLen))
                        attributedStr.addAttribute(.foregroundColor, value: CustomColors.lightOrange1, range: NSRange(location: 0, length: 6))
                        
                        
                        self.connectionIndicatorLabel.attributedText = attributedStr
                        
                    }
                }
            }
//            else {
//                self.friendText.heightAnchor.constraint(equalToConstant: 0).isActive = true
//            }
        }
    }
    
    
    
    
    
    // MARK: - Populate
    
    
    var profileImageUrlG: String?
    
    
    func populateData() {
        
        let uid = goToControllerByMemberUid
        let ref = Database.database().reference().child("users").child(uid!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in

            guard let value = snapshot.value as? [String: Any] else { return }
            
            
            
            // Profile and top menu
            let profileImageUrl = value["profileImageUrl"] as? String // No idea why you need this
            self.profileImageUrlG = profileImageUrl
            
            if profileImageUrl == "empty" {
                self.profileAvatarView.image = UIImage(named: "emptyavatar")
            } else if profileImageUrl == "deleted" {
                self.profileAvatarView.image = UIImage(named: "deletedprofile")
            } else {
                self.profileAvatarView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
                self.profileAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.seeMemberProfileImages)))
                self.profileAvatarView.isUserInteractionEnabled = true
            }
            
            
            
            
            // Content in here
            
            let meetChecked = value["meetChecked"] as? Bool
            let dateChecked = value["dateChecked"] as? Bool
            
            var currentLocation: String? = nil
            if let loc = value["currentLoc"] as? String, !loc.isEmpty {
                self.curLoc = loc
                currentLocation = "Current location: " + loc
            }
            
            let acceptingGuests = value["acceptingGuests"] as? String
            let homeLocation = value["loc"] as? String
            let name = ( value["name"] as? String )?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            let occupation = value["occupation"] as? String
            let age = ( value["age"] as? String )?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Can be nil
            var lastSeen: String = ""
            var lastSeenColor: UIColor = CustomColors.commonGrey1
            
            if value["isActive"] != nil && value["disconectTime"] != nil {
                
                if value["isActive"] as! Bool == true {
                    lastSeen = "Active"
                    lastSeenColor = UIColor(red: 33.0 / 255.0, green: 187.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
                } else {
                    
                    let strTimestamp = String(describing: value["disconectTime"]!)
                    var timestamp = NSNumber()
                    if let myInteger = Int(strTimestamp.dropLast(3)) {
                        timestamp = NSNumber(value:myInteger)
                    }

                    let minute = 60
                    let hour = 60 * minute
                    let day = 24 * hour
                    let week =  7 * day
                    let month = 30 * day
                    let year = 12 * month
//                    if let seconds = timestamp.doubleValue {
//                        let timestampDate = NSDate(timeIntervalSince1970: (timestamp.doubleValue))
                    let timeDouble = timestamp.doubleValue
                    let timeInt = Int(timeDouble)
                    let nowInt = Int(Date().timeIntervalSince1970)
                    print("nowInt:` ", nowInt, ", timeInt: ", timeInt)
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
                    lastSeen = "Last activity " + agoString
                    
                }
            }
 
   
            
            
            self.aboutMe = value["aboutMe"] as? String
            self.aboutMyPlace = value["aboutMyPlace"] as? String
            
            
            var availableOptions: String = ""
            
            if acceptingGuests == "maybe"{
                availableOptions.append("Maybe accepting guests\n")
            } else if acceptingGuests == "yes"{
                availableOptions.append("Accepting guests\n")
            }
            if meetChecked == true {
                availableOptions.append("Meeting up\n")
            }
            if dateChecked == true {
                availableOptions.append("Dating\n")
            }
            
            
            
            // We will see what we do about these
            if value["aboutServicesEnabled"] != nil {
                self.aboutServicesEnabled = value["aboutServicesEnabled"] as! Bool
            }
            
            if value["offerServiseChecked"] != nil {
                self.offerServiseChecked = value["offerServiseChecked"] as! Bool
            }
            
            
//            if self.aboutServicesEnabled && self.offerServiseChecked {
//                self.aboutServicesTextView.text = value["aboutServices"] as! String
//                if value["aboutServices"] != nil && value["aboutServices"] as? String != "" {
//                    self.aboutServicesTextView.text! = value["aboutServices"] as! String
//                    let height3 = self.estimateFrameForText(text: self.aboutServicesTextView.text!).height + 20
//                    self.aboutServicesTextViewHeightAnchor = self.aboutServicesTextView.heightAnchor.constraint(equalToConstant: height3)
//                    self.aboutServicesTextTitleHeightAnchor = self.aboutMyServicesTextTitle.heightAnchor.constraint(equalToConstant: 23)
//                    self.aboutServicesTextTitleTopAnchor = self.aboutMyServicesTextTitle.topAnchor.constraint(equalTo: self.datingTextView.bottomAnchor, constant: 20)
//                } else {
//                    self.aboutServicesTextViewHeightAnchor = self.aboutServicesTextView.heightAnchor.constraint(equalToConstant: 0)
//                    self.aboutServicesTextTitleHeightAnchor = self.aboutMyServicesTextTitle.heightAnchor.constraint(equalToConstant: 0)
//                    self.aboutServicesTextTitleTopAnchor = self.aboutMyServicesTextTitle.topAnchor.constraint(equalTo: self.datingTextView.bottomAnchor, constant: 0)
//                }
//            } else {
//                self.aboutServicesTextTitleHeightAnchor = self.aboutMyServicesTextTitle.heightAnchor.constraint(equalToConstant: 0)
//                self.aboutServicesTextViewHeightAnchor = self.aboutServicesTextView.heightAnchor.constraint(equalToConstant: 0)
//                self.aboutServicesTextTitleTopAnchor = self.aboutMyServicesTextTitle.topAnchor.constraint(equalTo: self.datingTextView.bottomAnchor, constant: 0)
//            }

            
            
            
            
            // There can be a template or i can build it right here
            
            
            let compose = NSMutableAttributedString(string: "")
            let newline = NSAttributedString(string: "\n")
            
            
            func newlineWith(spacing: CGFloat) -> NSAttributedString {
                let style = NSMutableParagraphStyle()

                style.maximumLineHeight = spacing
                style.minimumLineHeight = spacing
                return NSAttributedString(string: "\n", attributes: [.font: UIFont(name: "HelveticaNeue-Medium", size: 14.0)!,
                                                                     .paragraphStyle: style])
            }
            
            
            
            // Name
            if let name = name {
                compose.append( NSAttributedString(string: name.appending(" "),
                                                   attributes: [
                                                    .font: UIFont(name: "HelveticaNeue-Medium", size: 18.0)!,
                                                    .foregroundColor: UIColor(red: 61.0 / 255.0, green: 77.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
                    ]
                ))
                
            }
            
            
            
            // Age
            if let age = age {
                compose.append( NSAttributedString(string: age.appending("\n"),
                                                   attributes: [
                                                    .font: UIFont(name: "HelveticaNeue-Light", size: 18.0)!,
                                                    .foregroundColor: UIColor(red: 61.0 / 255.0, green: 77.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
                    ]
                ))
                
            }
            
            
            
            // Last seen
            compose.append( NSAttributedString(string: lastSeen.appending("\n"),
                                               attributes: [
                                                .font: UIFont(name: "HelveticaNeue", size: 11.0)!,
                                                .foregroundColor: lastSeenColor
                ]
            ))
            
            // Newline
            compose.append( newlineWith(spacing: 13) )
            
            
            
            // Occupation
            if let occupation = occupation {
                compose.append( NSAttributedString(string: occupation.appending("\n"),
                                                   attributes: [
                                                    .font: UIFont(name: "HelveticaNeue-Medium", size: 14.0)!,
                                                    .foregroundColor: UIColor(red: 33.0 / 255.0, green: 187.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
                    ]
                ))
                
            }
            
            
            
            
            // Home Location
            if let homeLocation = homeLocation {
                compose.append( NSAttributedString(string: homeLocation.appending("\n"),
                                                   attributes: [
                                                    .font: UIFont(name: "HelveticaNeue-Light", size: 14.0)!,
                                                    .foregroundColor: UIColor(red: 61.0 / 255.0, green: 77.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
                    ]
                ))
                
            }
            
            
            
            
            // Current Location
            if let currentLocation = currentLocation {
                compose.append( NSAttributedString(string: currentLocation.appending("\n"),
                                                   attributes: [
                                                    .font: UIFont(name: "HelveticaNeue-Light", size: 14.0)!,
                                                    .foregroundColor: UIColor(red: 61.0 / 255.0, green: 77.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
                    ]
                ))
                
            }
            
            
            
            
            // Available Options provided
            if availableOptions.isEmpty == false {
            
                // Newline
                compose.append( newlineWith(spacing: 13) )
                
                compose.append( NSAttributedString(string: availableOptions,
                                                   attributes: [
                                                    .font: UIFont(name: "HelveticaNeue-Medium", size: 14.0)!,
                                                    .foregroundColor: UIColor(red: 255.0 / 255.0, green: 165.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
                    ]
                ))
                
                // Newline is disabled here since the logic always contains a new line at the end
                // compose.append(newline)
            }
            
            
            
            
            // About me
            if let aboutMe = self.aboutMe, aboutMe.isEmpty == false {
                
                // Newline
                compose.append( newlineWith(spacing: 13) )
                
                compose.append( NSAttributedString(string: "About me".appending("\n"),
                                                   attributes: [
                                                    .font: UIFont(name: "HelveticaNeue-Medium", size: 14.0)!,
                                                    .foregroundColor: UIColor(red: 61.0 / 255.0, green: 77.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
                    ]
                ))
                
                
                
                compose.append( NSAttributedString(string: aboutMe.appending("\n"),
                                                   attributes: [
                                                    .font: UIFont(name: "HelveticaNeue-Light", size: 14.0)!,
                                                    .foregroundColor: UIColor(red: 61.0 / 255.0, green: 77.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
                    ]
                ))
                
            }
            
            
            // About my place
            if let aboutMyPlace = self.aboutMyPlace, aboutMyPlace.isEmpty == false {
                
                // Newline
                compose.append(newline)
                
                compose.append( NSAttributedString(string: "About my place",
                                                   attributes: [
                                                    .font: UIFont(name: "HelveticaNeue-Medium", size: 18.0)!,
                                                    .foregroundColor: UIColor(red: 61.0 / 255.0, green: 77.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
                    ]
                ))
                
                // Newline
                compose.append(newline)
                
                
                compose.append( NSAttributedString(string: aboutMyPlace,
                                                   attributes: [
                                                    .font: UIFont(name: "HelveticaNeue-Light", size: 14.0)!,
                                                    .foregroundColor: UIColor(red: 61.0 / 255.0, green: 77.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
                    ]
                ))
                
                // Newline
                compose.append(newline)
                
            }
            
            
            
            
            self.navigationItem.title =  name! + " " + age!
            
            //
            
            self.contentLabel.attributedText = compose
            
            self.contentLabel.setNeedsLayout()
            self.contentLabel.layoutIfNeeded()
            
            // Multiple lines of options
            
//
//
//            let attributedString = NSMutableAttributedString(string: "About me\nI am a student living in Porto, originally from Denmark.", attributes: [
//                .font: UIFont(name: "HelveticaNeue-Light", size: 14.0)!,
//                .foregroundColor: UIColor(red: 61.0 / 255.0, green: 77.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
//                ])
//            attributedString.addAttribute(.font, value: UIFont(name: "HelveticaNeue-Medium", size: 14.0)!, range: NSRange(location: 0, length: 9))
//
            
            
            self.getImagesURLSArray()
        })
    }
    
    
    func estimateFrameForText(text: String) -> CGRect {
        let width = scrollView.frame.width - 70
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)], context: nil)
    }
   
    var friendTextHeightAnchor: NSLayoutConstraint?
    var aboutServicesTextTitleTopAnchor: NSLayoutConstraint?
    var activityHeightAnchor: NSLayoutConstraint?
    var aboutServicesTextTitleHeightAnchor: NSLayoutConstraint?
    var aboutServicesTextViewHeightAnchor: NSLayoutConstraint?
    func memberPropsContainerSetup(){
        setFriendshipStatus()
    }
    
    
    func hideAllWhenDeleted(){
        userWasDeleted = true
        
        likeButton.isHidden = true
        contactButton.isHidden = true
        reportButton.isHidden = true
        addToBlacklistButton.isHidden = true
        optionsContainer.isHidden = true
        friendshipActionButton.isHidden = true
        profileAvatarView.image = UIImage(named: "deletedprofile")
    }
    func checkIfUserDeleted() {
        let ref = Database.database().reference().child("users").child(goToControllerByMemberUid!).child("wasDeleted")
        ref.observeSingleEvent(of: .value) { (snap) in
            if snap.value as? String == "byAdministration" {
                print("this user was deleted by administration")
                self.hideAllWhenDeleted()
                let alert = UIAlertController(title: "This user got banned from MyFriendsRoom", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else if snap.value as? String == "bySelf" {
                print("this user deletedd each self")
                self.hideAllWhenDeleted()
                let alert = UIAlertController(title: "This profile has been deleted", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Prepare collection view
        albumCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "image_cell")
        
        if let layout = albumCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellWidth = (view.bounds.width - 60) / 3
            layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }
        
       
        hidesBottomBarWhenPushed = true
        
        /*
        // We need to do magic to make the cell not scrollable
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            self.scrollView.contentSize = self.albumCollectionView.contentSize
            self.scrollView.contentSize.height += 134
            
            self.albumCollectionView.sizeToFit()
        }*/
        
        
        
        // Small layout
        profileAvatarView.layer.cornerRadius = 35   // half of the width
        
        
        populateData()
        
//        memberPropsContainerSetup()
        setupNavBarItems()
//        isInYourWishlist()
        optionsContainerSetup()
//        setupUserBlockedStatus()
//        setupYouInBlacklistStatus()
//        checkIfUserDeleted()
//        checkIfYouAreBanned()
        
        setFriendshipStatus()
    }
    
}



extension MemberProfileController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImagesURLSArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image_cell", for: indexPath) as! ImageCollectionViewCell
        
        // Set the cell image
        cell.imageView.loadImageusingCacheWithUrlString(urlString: profileImagesURLSArray[indexPath.row] )
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the item and do something useful
        seeMemberProfileImages()
    }
    
}

class ImageCollectionViewCell : UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.frame = self.bounds
        imageView.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleBottomMargin, ]
        self.addSubview(imageView)
        
        imageView.backgroundColor = .lightGray
        
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
}


class NotScrollableCollectionView: UICollectionView {
    
    override var bounds: CGRect {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
 
    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
}



class UndexTextButton : UIButton {
    
    
    
}
