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
    
    let mfrContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let mfrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let mfrMyTitle: UITextView = {
        let tt = UITextView()
        let attributedStr = NSMutableAttributedString.init(string: "MyFriendsRoom")
        attributedStr.addAttribute(.foregroundColor, value: CustomColors.commonGrey1, range: NSRange(location: 0, length: 13))
        attributedStr.addAttribute(.foregroundColor, value: CustomColors.commonBlue1, range: NSRange(location: 2, length: 7))
        tt.attributedText = attributedStr
        tt.font = .systemFont(ofSize: 25)
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    let profileAvatarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let profileAvatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyavatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seeMemberProfileImages)))
        return imageView
    }()
    let lastProfileImageView: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "emptyavatar")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    let friendshipActionButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(friendshipAction), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("add to friends", for: .normal)
        cb.backgroundColor = UIColor.clear
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cb.tintColor = CustomColors.commonBlue1
        return cb
    }()
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor.white
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.layer.masksToBounds = true
        return sv
    }()
    let addToWishlistButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(addToWishlist), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("LIKE", for: .normal)
        cb.backgroundColor = CustomColors.lightOrange1
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return cb
    }()
    let contactButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(contactMember), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("CONTACT", for: .normal)
        cb.backgroundColor = CustomColors.commonGrey1
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return cb
    }()
    let memberPropsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("<", for: .normal)
        button.setFATitleColor(color: CustomColors.commonGrey1)
        button.titleLabel?.font = .systemFont(ofSize: 45)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    let memberNameAndAge: UITextView = {
        let tt = UITextView()
        tt.isUserInteractionEnabled = false
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.text = "%Username% 00"
        tt.textColor = CustomColors.commonGrey1
        tt.font = .boldSystemFont(ofSize: 22)
        return tt
    }()
    let friendText: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .boldSystemFont(ofSize: 15)
//        tt.textAlignment = .right
        return tt
    }()
    let activity: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.commonBlue1
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.text = "Activity"
        tt.font = .systemFont(ofSize: 13)
        return tt
    }()
    let occupationText: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.commonBlue1
        tt.text = "%user_occupation%"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 16)
        return tt
    }()
    let currentLocationView: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Current:"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 16)
        return tt
    }()
    let homeLocationView: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Home"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 16)
        return tt
    }()
    let accepingGuestsTextView: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.lightOrange1
        tt.text = "..."
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 16)
        return tt
    }()
    let meetingUpTextView: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.lightOrange1
        tt.text = "..."
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 16)
        return tt
    }()
    let datingTextView: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.lightOrange1
        tt.text = "..."
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 16)
        return tt
    }()
    let aboutMyServicesTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "About my services"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .boldSystemFont(ofSize: 16)
        return tt
    }()
    let aboutServicesTextView: UITextView = {
        let tt = UITextView()
        tt.text = "tell us about your services"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.textColor = CustomColors.commonGrey1
        tt.font = .systemFont(ofSize: 15)
        return tt
    }()
    let aboutMeTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "About me"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .boldSystemFont(ofSize: 16)
        return tt
    }()
    let aboutMeTextView: UITextView = {
        let tt = UITextView()
//        tt.placeholder = "tell us about yourself"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.textColor = CustomColors.commonGrey1
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 15)
        return tt
    }()
    let aboutMyPlaceTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "About my place"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .boldSystemFont(ofSize: 16)
        return tt
    }()
    let aboutMyPlaceTextView: UITextView = {
        let tt = UITextView()
//        tt.placeholder = "tell us about your place"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.textColor = CustomColors.commonGrey1
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 15)
        return tt
    }()
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
//    func getLastActivity(){
//        Auth.auth().use
//    }
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
                self.friendTextHeightAnchor = self.friendText.heightAnchor.constraint(equalToConstant: 0)
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
    func setCurrentLastImage(){
        if imagesURLSArray.count > 0 {
            let imgUrlString = imagesURLSArray[0]
            profileAvatarContainerView.addSubview(lastProfileImageView)
            lastProfileImageView.rightAnchor.constraint(equalTo: profileAvatarContainerView.rightAnchor).isActive = true
            lastProfileImageView.bottomAnchor.constraint(equalTo: contactButton.topAnchor, constant: -15).isActive = true
            lastProfileImageView.widthAnchor.constraint(equalToConstant: 85).isActive = true
            lastProfileImageView.heightAnchor.constraint(equalToConstant: 85).isActive = true
            lastProfileImageView.loadImageusingCacheWithUrlString(urlString: imgUrlString)
            lastProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seeMemberImages)))
            lastProfileImageView.isUserInteractionEnabled = true
        }
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
                self.friendText.text = "Blocked"
                
                self.friendTextHeightAnchor?.isActive = false
                self.friendTextHeightAnchor = self.friendText.heightAnchor.constraint(equalToConstant: 20)
                self.friendTextHeightAnchor?.isActive = true
            }
        }
    }
    func hideUiIfInBlacklist(whoBlacklisted: String){
        self.hidAddToWishlistButton()
        self.friendshipActionButton.isHidden = true
        self.contactButton.isHidden = true
        if whoBlacklisted == "user" {
            self.addToBlacklistButton.setTitle("Unblock", for: .normal)
        } else if self.friendText.text != "Blocked"{
            self.friendText.text = ""
            self.friendTextHeightAnchor?.isActive = false
            self.friendTextHeightAnchor = self.friendText.heightAnchor.constraint(equalToConstant: 0)
            self.friendTextHeightAnchor?.isActive = true
        }
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
    func getImagesURLSArray(){
        imagesURLSArray = []
        profileImagesURLSArray = []
        let ref = Database.database().reference().child("user-apartments-images").child(goToControllerByMemberUid!)
        ref.observeSingleEvent(of: .value) { (snap) in
            for child in snap.children.allObjects as! [DataSnapshot]{
                let imageURL = child.value as! String
                self.imagesURLSArray.insert(imageURL, at: 0)
            }
            self.setCurrentLastImage()
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
        }
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
                self.hidAddToWishlistButton()
            }
        }
    }
    func hidAddToWishlistButton(){
        addToWishlistButton.isHidden = true
    }
    @objc func goBack() {
        imagesURLSArray = [String]()
        self.dismiss(animated: true, completion: nil)
    }
    func optionsContainerSetup(){
        view.addSubview(optionsContainer)
        optionsContainer.addSubview(addToBlacklistButton)
        optionsContainer.addSubview(blackListSeperatorView)
        optionsContainer.addSubview(reportButton)
        
        optionsContainer.rightAnchor.constraint(equalTo: profileAvatarContainerView.rightAnchor).isActive = true
        optionsContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
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
        self.navigationItem.title = "Profile"
    }
    @objc func hideUnhideOptions(){
        if optionsContainer.isHidden == true {
            optionsContainer.isHidden = false
        } else {
            optionsContainer.isHidden = true
        }
    }
    @objc func addToWishlist(){
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
        hidAddToWishlistButton()
        print("Add to wishlist")
        inWishList = true
    }
    @objc func contactMember(){
        checkIfYouAreBanned()
        let contactMemberController = ContactMemberController()
        let contactMemberNav = UINavigationController(rootViewController: contactMemberController)
        self.present(contactMemberNav, animated: true, completion: nil)
    }
    @objc func friendshipAction(){
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
        friendshipActionButton.heightAnchor.constraint(equalToConstant: 0).isActive = true
        friendshipActionButton.titleLabel?.heightAnchor.constraint(equalToConstant: 0).isActive = true
    }
    func acceptFriendshipProposalSetup(){
        friendshipActionButton.titleLabel?.leftAnchor.constraint(equalTo: friendshipActionButton.leftAnchor).isActive = true
        friendshipActionButton.setTitle("ACCEPT FRIEND", for: .normal)
        friendshipActionButton.titleLabel?.textColor = CustomColors.commonBlue1
        scrollView.addSubview(friendshipActionButton)
        friendshipActionButton.leftAnchor.constraint(equalTo: friendText.leftAnchor).isActive = true
        friendshipActionButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        friendshipActionButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        friendshipActionButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func proposalWasSentButtonSetup(){
        friendshipActionButton.titleLabel?.leftAnchor.constraint(equalTo: friendshipActionButton.leftAnchor).isActive = true
        friendshipActionButton.setTitle("CANCEL REQUEST", for: .normal)
        friendshipActionButton.titleLabel?.textColor = CustomColors.commonBlue1
        scrollView.addSubview(friendshipActionButton)
        friendshipActionButton.leftAnchor.constraint(equalTo: friendText.leftAnchor).isActive = true
        friendshipActionButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        friendshipActionButton.widthAnchor.constraint(equalToConstant: 145).isActive = true
        friendshipActionButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func deleteFromFriendsButtonSetup(){
        friendshipActionButton.titleLabel?.leftAnchor.constraint(equalTo: friendshipActionButton.leftAnchor).isActive = true
        friendshipActionButton.setTitle("delete friend", for: .normal)
        friendshipActionButton.titleLabel?.textColor = CustomColors.commonBlue1
        scrollView.addSubview(friendshipActionButton)
        friendshipActionButton.leftAnchor.constraint(equalTo: friendText.leftAnchor).isActive = true
        friendshipActionButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        friendshipActionButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        friendshipActionButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let string = "FRIEND"
        let stringLen = string.count
        let attributedStr = NSMutableAttributedString.init(string: string)
        attributedStr.addAttribute(.foregroundColor, value: CustomColors.lightOrange1, range: NSRange(location: 0, length: stringLen))
        self.friendText.attributedText = attributedStr
        self.friendText.font = .boldSystemFont(ofSize: 15)
        
        self.friendTextHeightAnchor?.isActive = false
        self.friendTextHeightAnchor = self.friendText.heightAnchor.constraint(equalToConstant: 20)
        self.friendTextHeightAnchor?.isActive = true
    }
    func addToFriendsButtonSetup(){
        friendshipActionButton.titleLabel?.leftAnchor.constraint(equalTo: friendshipActionButton.leftAnchor).isActive = true
        friendshipActionButton.setTitle("ADD FRIEND", for: .normal)
        friendshipActionButton.titleLabel?.textColor = CustomColors.commonBlue1
        scrollView.addSubview(friendshipActionButton)
        friendshipActionButton.leftAnchor.constraint(equalTo: friendText.leftAnchor).isActive = true
        friendshipActionButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        friendshipActionButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        friendshipActionButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
                    attributedStr.addAttribute(.foregroundColor, value: CustomColors.lightOrange1, range: NSRange(location: 0, length: stringLen))
                    self.friendText.attributedText = attributedStr
                    self.friendText.font = .boldSystemFont(ofSize: 15)
                    
                    self.friendTextHeightAnchor?.isActive = false
                    self.friendTextHeightAnchor = self.friendText.heightAnchor.constraint(equalToConstant: 20)
                    self.friendTextHeightAnchor?.isActive = true
                } else {
                    print("commonFriend: ",commonFriend)
                    let ref = Database.database().reference().child("users").child(commonFriend)
                    ref.observeSingleEvent(of: .value) { (snap) in
                        guard let value = snap.value as? [String: Any] else { return }
                        let name = value["name"] as? String
                        print("common friend is: ", name!)
                        let string = "FRIEND OF " + name!
                        let stringLen = string.count
                        let attributedStr = NSMutableAttributedString.init(string: string)
                        attributedStr.addAttribute(.foregroundColor, value: CustomColors.commonGrey1, range: NSRange(location: 0, length: stringLen))
                        attributedStr.addAttribute(.foregroundColor, value: CustomColors.lightOrange1, range: NSRange(location: 0, length: 6))
                        self.friendText.attributedText = attributedStr
                        self.friendText.font = .boldSystemFont(ofSize: 15)
                        
                        self.friendTextHeightAnchor?.isActive = false
                        self.friendTextHeightAnchor = self.friendText.heightAnchor.constraint(equalToConstant: 20)
                        self.friendTextHeightAnchor?.isActive = true
                    }
                }
            }
//            else {
//                self.friendText.heightAnchor.constraint(equalToConstant: 0).isActive = true
//            }
        }
    }
    var profileImageUrlG: String?
    func setupUserPropsValues() {
        let uid = goToControllerByMemberUid
//        Database.database().isPersistenceEnabled = false
        let ref = Database.database().reference().child("users").child(uid!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
//            Database.database().isPersistenceEnabled = true
            print(snapshot)
            guard let value = snapshot.value as? [String: Any] else { return }
            let meetChecked = value["meetChecked"] as? Bool
            let dateChecked = value["dateChecked"] as? Bool
            print("CURRENT`: ", value["currentLoc"] as? String)
            if value["currentLoc"] as? String != nil {
                if value["currentLoc"] as? String != "" {
                    self.curLoc = value["currentLoc"] as? String
                    self.currentLocationView.heightAnchor.constraint(equalToConstant: 28).isActive = true
                } else {
                    self.currentLocationView.heightAnchor.constraint(equalToConstant: 0).isActive = true
                }
            } else {
                self.currentLocationView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            }
            let acceptingGuests = value["acceptingGuests"] as? String
            let homeLocation = value["loc"] as? String
            let name = value["name"] as? String
            let profileImageUrl = value["profileImageUrl"] as? String
            self.profileImageUrlG = profileImageUrl
            let occupation = value["occupation"] as? String
            let age = value["age"] as? String
            self.currentLocationView.text = "Current location: " + self.curLoc!
            self.homeLocationView.text = /*"City, Country: " + */homeLocation!
            self.activityHeightAnchor?.isActive = false
            if value["isActive"] != nil && value["disconectTime"] != nil {
                self.activityHeightAnchor = self.activity.heightAnchor.constraint(equalToConstant: 23)
                if value["isActive"] as! Bool == true {
                    self.activity.text = "Active"
                } else {
                    print("aaa: ", value["isActive"]!)
                    let strTimestamp = String(describing: value["disconectTime"]!)
                    print("strTimestamp: ", strTimestamp, type(of: strTimestamp))
                    var timestamp = NSNumber()
                    if let myInteger = Int(strTimestamp.dropLast(3)) {
                        timestamp = NSNumber(value:myInteger)
                        print("myInteger: ", myInteger, ", timestamp: ", timestamp)
                    }
//                    let timestamp = value["disconectTime"] as? NSNumber
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
                    self.activity.text = "Last activity " + agoString
                    self.activity.textColor = CustomColors.commonGrey1
//                    }
                }
            } else {
                self.activityHeightAnchor = self.activity.heightAnchor.constraint(equalToConstant: 0)
            }
            self.activityHeightAnchor?.isActive = true
            if value["aboutMe"] != nil {
                self.aboutMe = value["aboutMe"] as? String
            }
            if value["aboutMyPlace"] != nil {
                self.aboutMyPlace = value["aboutMyPlace"] as? String
            }
            if meetChecked == true {
                self.meetingUpTextView.text = "Meeting up"
                self.meetingUpTextView.heightAnchor.constraint(equalToConstant: 28).isActive = true
            } else {
                self.meetingUpTextView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            }
            if dateChecked == true {
                self.datingTextView.text = "Dating"
                self.datingTextView.heightAnchor.constraint(equalToConstant: 28).isActive = true
            } else {
                self.datingTextView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            }
            if acceptingGuests == "maybe"{
                self.accepingGuestsTextView.text = "Maybe accepting guests"
                self.accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 28).isActive = true
            } else if acceptingGuests == "yes"{
                self.accepingGuestsTextView.text = "Accepting guests"
                self.accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 28).isActive = true
            } else {
                self.accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            }
//            self.profileAvatarView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
            if value["aboutServicesEnabled"] != nil {
                self.aboutServicesEnabled = value["aboutServicesEnabled"] as! Bool
            }
            
            if value["offerServiseChecked"] != nil {
                self.offerServiseChecked = value["offerServiseChecked"] as! Bool
            }
            self.aboutServicesTextTitleTopAnchor?.isActive = false
            self.aboutServicesTextTitleHeightAnchor?.isActive = false
            self.aboutServicesTextViewHeightAnchor?.isActive = false
            if self.aboutServicesEnabled && self.offerServiseChecked {
                self.aboutServicesTextView.text = value["aboutServices"] as! String
                if value["aboutServices"] != nil && value["aboutServices"] as? String != "" {
                    self.aboutServicesTextView.text! = value["aboutServices"] as! String
                    let height3 = self.estimateFrameForText(text: self.aboutServicesTextView.text!).height + 20
                    self.aboutServicesTextViewHeightAnchor = self.aboutServicesTextView.heightAnchor.constraint(equalToConstant: height3)
                    self.aboutServicesTextTitleHeightAnchor = self.aboutMyServicesTextTitle.heightAnchor.constraint(equalToConstant: 23)
                    self.aboutServicesTextTitleTopAnchor = self.aboutMyServicesTextTitle.topAnchor.constraint(equalTo: self.datingTextView.bottomAnchor, constant: 20)
                } else {
                    self.aboutServicesTextViewHeightAnchor = self.aboutServicesTextView.heightAnchor.constraint(equalToConstant: 0)
                    self.aboutServicesTextTitleHeightAnchor = self.aboutMyServicesTextTitle.heightAnchor.constraint(equalToConstant: 0)
                    self.aboutServicesTextTitleTopAnchor = self.aboutMyServicesTextTitle.topAnchor.constraint(equalTo: self.datingTextView.bottomAnchor, constant: 0)
                }
            } else {
                self.aboutServicesTextTitleHeightAnchor = self.aboutMyServicesTextTitle.heightAnchor.constraint(equalToConstant: 0)
                self.aboutServicesTextViewHeightAnchor = self.aboutServicesTextView.heightAnchor.constraint(equalToConstant: 0)
                self.aboutServicesTextTitleTopAnchor = self.aboutMyServicesTextTitle.topAnchor.constraint(equalTo: self.datingTextView.bottomAnchor, constant: 0)
            }
            self.aboutServicesTextTitleTopAnchor?.isActive = true
            self.aboutServicesTextTitleHeightAnchor?.isActive = true
            self.aboutServicesTextViewHeightAnchor?.isActive = true
            var nameAndAge = name! + " " + age!
            let nameLen = name?.count
            let ageLen = age?.count
            let nameAgeLen = nameAndAge.count
            let range = NSRange(location: 0, length: nameAgeLen)
            let attributedStr = NSMutableAttributedString.init(string: nameAndAge)
            attributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 22), range: range)
            attributedStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 22), range: NSRange(location: nameLen! + 1, length: ageLen!))
            attributedStr.addAttribute(.foregroundColor, value: CustomColors.commonGrey1, range: range)
//            nameAndAge = attributedStr
            if profileImageUrl == "empty" {
                self.profileAvatarView.image = UIImage(named: "emptyavatar")
            } else if profileImageUrl == "deleted" {
                self.profileAvatarView.image = UIImage(named: "deletedprofile")
            } else {
                self.profileAvatarView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
                self.profileAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.seeMemberProfileImages)))
                self.profileAvatarView.isUserInteractionEnabled = true
            }
//            self.profileAvatarView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
            self.navigationItem.title = nameAndAge
            self.memberNameAndAge.attributedText = attributedStr
//            self.memberNameAndAge.text = nameAndAge
            self.homeLocationView.text = /*"City, Country: " + */homeLocation!
            self.occupationText.text = occupation
            if occupation?.count == 0 {
                self.occupationText.heightAnchor.constraint(equalToConstant: 0).isActive = true
            }
            
            if self.aboutMe != "" && self.aboutMe != nil {
                self.aboutMeTextView.text = self.aboutMe
                let height1 = self.estimateFrameForText(text: self.aboutMe!).height + 10
                self.aboutMeTextTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true
                self.aboutMeTextTitle.topAnchor.constraint(equalTo: self.aboutServicesTextView.bottomAnchor, constant: 20).isActive = true
                self.aboutMeTextView.heightAnchor.constraint(equalToConstant: height1).isActive = true
            } else {
                self.aboutMeTextTitle.heightAnchor.constraint(equalToConstant: 0).isActive = true
                self.aboutMeTextTitle.topAnchor.constraint(equalTo: self.aboutServicesTextView.bottomAnchor, constant: 0).isActive = true
                self.aboutMeTextView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            }
            if self.aboutMyPlace != "" && self.aboutMyPlace != nil  {
                self.aboutMyPlaceTextView.text = self.aboutMyPlace
                let height2 = self.estimateFrameForText(text: self.aboutMyPlace!).height + 10
                self.aboutMyPlaceTextTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true
                self.aboutMyPlaceTextTitle.topAnchor.constraint(equalTo: self.aboutMeTextView.bottomAnchor, constant: 20).isActive = true
                self.aboutMyPlaceTextView.heightAnchor.constraint(equalToConstant: height2).isActive = true
            } else {
                self.aboutMyPlaceTextTitle.heightAnchor.constraint(equalToConstant: 0).isActive = true
                self.aboutMyPlaceTextTitle.topAnchor.constraint(equalTo: self.aboutMeTextView.bottomAnchor, constant: 0).isActive = true
                self.aboutMyPlaceTextView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            }
            self.getImagesURLSArray()
        })
    }
    func estimateFrameForText(text: String) -> CGRect {
        let width = scrollView.frame.width - 70
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)], context: nil)
    }
    func profileAvatarContainerViewSetup(){
        view.addSubview(profileAvatarContainerView)
        profileAvatarContainerView.addSubview(profileAvatarView)
        profileAvatarContainerView.addSubview(addToWishlistButton)
        profileAvatarContainerView.addSubview(contactButton)
        
        profileAvatarContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        profileAvatarContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileAvatarContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        profileAvatarContainerView.heightAnchor.constraint(equalTo: profileAvatarContainerView.widthAnchor).isActive = true
        
        profileAvatarView.centerXAnchor.constraint(equalTo: profileAvatarContainerView.centerXAnchor).isActive = true
        profileAvatarView.centerYAnchor.constraint(equalTo: profileAvatarContainerView.centerYAnchor).isActive = true
        profileAvatarView.widthAnchor.constraint(equalTo: profileAvatarContainerView.widthAnchor).isActive = true
        profileAvatarView.heightAnchor.constraint(equalTo: profileAvatarContainerView.heightAnchor).isActive = true
        
        addToWishlistButton.rightAnchor.constraint(equalTo: profileAvatarContainerView.rightAnchor).isActive = true
        addToWishlistButton.bottomAnchor.constraint(equalTo: profileAvatarContainerView.bottomAnchor, constant: -25).isActive = true
        addToWishlistButton.widthAnchor.constraint(equalToConstant: 85).isActive = true
        addToWishlistButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contactButton.rightAnchor.constraint(equalTo: profileAvatarContainerView.rightAnchor).isActive = true
        contactButton.bottomAnchor.constraint(equalTo: addToWishlistButton.topAnchor, constant: -15).isActive = true
        contactButton.widthAnchor.constraint(equalToConstant: 85).isActive = true
        contactButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    var friendTextHeightAnchor: NSLayoutConstraint?
    var aboutServicesTextTitleTopAnchor: NSLayoutConstraint?
    var activityHeightAnchor: NSLayoutConstraint?
    var aboutServicesTextTitleHeightAnchor: NSLayoutConstraint?
    var aboutServicesTextViewHeightAnchor: NSLayoutConstraint?
    func memberPropsContainerSetup(){
        view.addSubview(scrollView)
        scrollView.addSubview(friendText)
        scrollView.addSubview(memberNameAndAge)
        scrollView.addSubview(activity)
        scrollView.addSubview(occupationText)
        scrollView.addSubview(homeLocationView)
        scrollView.addSubview(currentLocationView)
        scrollView.addSubview(accepingGuestsTextView)
        scrollView.addSubview(meetingUpTextView)
        scrollView.addSubview(datingTextView)
        scrollView.addSubview(aboutMyServicesTextTitle)
        scrollView.addSubview(aboutServicesTextView)
        scrollView.addSubview(aboutMeTextTitle)
        scrollView.addSubview(aboutMeTextView)
        scrollView.addSubview(aboutMyPlaceTextTitle)
        scrollView.addSubview(aboutMyPlaceTextView)
//        memberNameAndAge.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: profileAvatarContainerView.bottomAnchor, constant: 10).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        friendText.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        friendText.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40).isActive = true
        friendText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -80).isActive = true
        friendTextHeightAnchor = friendText.heightAnchor.constraint(equalToConstant: 0)
        friendTextHeightAnchor?.isActive = true
        
        memberNameAndAge.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        memberNameAndAge.topAnchor.constraint(equalTo: friendText.bottomAnchor).isActive = true
        memberNameAndAge.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        memberNameAndAge.heightAnchor.constraint(equalToConstant: 35).isActive = true
        memberNameAndAge.textInputView.leftAnchor.constraint(equalTo: memberNameAndAge.leftAnchor, constant: 2).isActive = true
        
        setFriendshipStatus()
        
        activity.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        activity.topAnchor.constraint(equalTo: memberNameAndAge.bottomAnchor).isActive = true
        activity.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        activityHeightAnchor = activity.heightAnchor.constraint(equalToConstant: 23)
        activityHeightAnchor?.isActive = true
        
        occupationText.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        occupationText.topAnchor.constraint(equalTo: activity.bottomAnchor).isActive = true
        occupationText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        occupationText.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        homeLocationView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        homeLocationView.topAnchor.constraint(equalTo: occupationText.bottomAnchor).isActive = true
        homeLocationView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        homeLocationView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        currentLocationView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        currentLocationView.topAnchor.constraint(equalTo: homeLocationView.bottomAnchor).isActive = true
        currentLocationView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        
        accepingGuestsTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        accepingGuestsTextView.topAnchor.constraint(equalTo: currentLocationView.bottomAnchor).isActive = true
        accepingGuestsTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true 
        
        meetingUpTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        meetingUpTextView.topAnchor.constraint(equalTo: accepingGuestsTextView.bottomAnchor).isActive = true
        meetingUpTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        
        datingTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        datingTextView.topAnchor.constraint(equalTo: meetingUpTextView.bottomAnchor).isActive = true
        datingTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        
        aboutMyServicesTextTitle.leftAnchor.constraint(equalTo:  scrollView.leftAnchor, constant: 38).isActive = true
        aboutServicesTextTitleTopAnchor = aboutMyServicesTextTitle.topAnchor.constraint(equalTo: datingTextView.bottomAnchor, constant: 20)
        aboutServicesTextTitleTopAnchor?.isActive = true
        aboutMyServicesTextTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        aboutServicesTextTitleHeightAnchor = self.aboutMyServicesTextTitle.heightAnchor.constraint(equalToConstant: 28)
        aboutServicesTextTitleHeightAnchor?.isActive = true
        
        aboutServicesTextView.leftAnchor.constraint(equalTo:  scrollView.leftAnchor, constant: 33).isActive = true
        aboutServicesTextView.topAnchor.constraint(equalTo: aboutMyServicesTextTitle.bottomAnchor).isActive = true
        aboutServicesTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        aboutServicesTextViewHeightAnchor = self.aboutServicesTextView.heightAnchor.constraint(equalToConstant: 28)
        aboutServicesTextViewHeightAnchor?.isActive = true
        
        aboutMeTextTitle.leftAnchor.constraint(equalTo:  scrollView.leftAnchor, constant: 38).isActive = true
//        aboutMeTextTitle.topAnchor.constraint(equalTo: aboutServicesTextView.bottomAnchor, constant: 20).isActive = true
        aboutMeTextTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        aboutMeTextView.leftAnchor.constraint(equalTo:  scrollView.leftAnchor, constant: 33).isActive = true
        aboutMeTextView.topAnchor.constraint(equalTo: aboutMeTextTitle.bottomAnchor).isActive = true
        aboutMeTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        
        aboutMyPlaceTextTitle.leftAnchor.constraint(equalTo:  scrollView.leftAnchor, constant: 38).isActive = true
//        aboutMyPlaceTextTitle.topAnchor.constraint(equalTo: aboutMeTextView.bottomAnchor, constant: 20).isActive = true
        aboutMyPlaceTextTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        aboutMyPlaceTextView.leftAnchor.constraint(equalTo:  scrollView.leftAnchor, constant: 33).isActive = true
        aboutMyPlaceTextView.topAnchor.constraint(equalTo: aboutMyPlaceTextTitle.bottomAnchor).isActive = true
        aboutMyPlaceTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        aboutMyPlaceTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
    }
    func hideAllWhenDeleted(){
        userWasDeleted = true
        
        activity.isHidden = true
        friendText.isHidden = true
        occupationText.isHidden = true
        currentLocationView.isHidden = true
        homeLocationView.isHidden = true
        accepingGuestsTextView.isHidden = true
        meetingUpTextView.isHidden = true
        datingTextView.isHidden = true
        aboutMeTextTitle.isHidden = true
        aboutMeTextView.isHidden = true
        aboutServicesTextView.isHidden = true
        aboutMyServicesTextTitle.isHidden = true
        aboutMyPlaceTextTitle.isHidden = true
        aboutMyPlaceTextView.isHidden = true
        addToWishlistButton.isHidden = true
        contactButton.isHidden = true
        reportButton.isHidden = true
        addToBlacklistButton.isHidden = true
        optionsContainer.isHidden = true
        friendshipActionButton.isHidden = true
        lastProfileImageView.isHidden = true
        lastProfileImageView.isHidden = true
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
        view.backgroundColor = UIColor.white
        view.addSubview(mfrContainerView)
        profileAvatarContainerViewSetup()
        memberPropsContainerSetup()
        setupUserPropsValues()
        setupNavBarItems()
        isInYourWishlist()
        //getImagesURLSArray()
        optionsContainerSetup()
        setupUserBlockedStatus()
        setupYouInBlacklistStatus()
        checkIfUserDeleted()
        checkIfYouAreBanned()
    }
}
