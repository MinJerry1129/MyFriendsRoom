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

var myImagesURLSArray = [String]()

class MyProfileController: UIViewController {
    var offerServiseChecked = false
    var itIsAFriend = false
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
    var aboutServicesEnabled = false
//    goToControllerByMemberUid = uid
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
//        cb.addTarget(self, action: #selector(friendshipAction), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("add to friends", for: .normal)
        cb.backgroundColor = CustomColors.commonBlue1
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return cb
    }()
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor.white
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.layer.masksToBounds = true
        return sv
    }()
    let goWishlistButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(goWishlistController), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("MY LIKES", for: .normal)
        cb.backgroundColor = CustomColors.lightOrange1
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return cb
    }()
    let addPicsButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(addPicsButtonAction), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("ADD PICS", for: .normal)
        cb.backgroundColor = CustomColors.commonBlue1
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return cb
    }()
    let contactButton: UIButton = {
        let cb = UIButton()
//        cb.addTarget(self, action: #selector(contactMember), for: .touchUpInside)
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
        tt.textAlignment = .right
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
        tt.text = "Home:"
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
        //tt.placeholder = "tell us about your place"
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
    
    @objc func addPicsButtonAction(){
        let userProfilePhotosController = UserProfilePhotosController()
        let userProfilePhotosControllerNav = UINavigationController(rootViewController: userProfilePhotosController)
        self.present(userProfilePhotosControllerNav, animated: true, completion: nil)
    }
    @objc func goWishlistController(){
        let profileSettingsController = WishlistController()
        let navController = UINavigationController(rootViewController: profileSettingsController)
        present(navController, animated: true, completion: nil)
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
    func remooveDeviceId(oldUid: Any) {
        print("oldUid: \(oldUid)")
        let ref = Database.database().reference().child("users").child(oldUid as! String).child("fromDevice")
        ref.removeValue()
    }
    @objc func seeMemberImages(){
        checkIfYouAreBanned()
        print("go to galery")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let swipingSRController = MemberPhotosController(collectionViewLayout: layout)
        let swipingSRNav = UINavigationController(rootViewController: swipingSRController)
        self.present(swipingSRNav, animated: true, completion: nil)
    }
    func setCurrentLastImage(){
        if myImagesURLSArray.count > 0 {
            let imgUrlString = myImagesURLSArray[0]
            profileAvatarContainerView.addSubview(lastProfileImageView)
            lastProfileImageView.rightAnchor.constraint(equalTo: profileAvatarContainerView.rightAnchor).isActive = true
            lastProfileImageView.bottomAnchor.constraint(equalTo: profileAvatarContainerView.topAnchor, constant: -15).isActive = true
            lastProfileImageView.widthAnchor.constraint(equalToConstant: 85).isActive = true
            lastProfileImageView.heightAnchor.constraint(equalToConstant: 85).isActive = true
            lastProfileImageView.loadImageusingCacheWithUrlString(urlString: imgUrlString)
            lastProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seeMemberImages)))
            lastProfileImageView.isUserInteractionEnabled = true
        }
    }
    func getmyImagesURLSArray(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("user-apartments-images").child(uid!)
        ref.observeSingleEvent(of: .value) { (snap) in
            for child in snap.children.allObjects as! [DataSnapshot]{
                let imageURL = child.value as! String
                myImagesURLSArray.insert(imageURL, at: 0)
            }
            self.setCurrentLastImage()
        }
    }
    @objc func goBack() {
        myImagesURLSArray = [String]()
        self.dismiss(animated: true, completion: nil)
    }
    func setupNavBarItems(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.commonGrey1]
        let signOut = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(logout))
        signOut.tintColor = CustomColors.commonBlue1
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(goToSettingsController))
        settingsButton.tintColor = CustomColors.commonBlue1
        navigationItem.leftBarButtonItem = signOut
        navigationItem.rightBarButtonItem = settingsButton
        self.navigationItem.title = "Profile"
    }
    @objc func logout() {
        self.present(LoginMethodController(), animated: false, completion: {
            do {
                if let oldUid = Auth.auth().currentUser?.uid {
                    self.remooveDeviceId(oldUid: oldUid)
                }
                let uid = Auth.auth().currentUser?.uid
                try Auth.auth().signOut()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signOut"), object: nil, userInfo: ["signOutUid": uid])
            }
            catch let logoutError {
                print (logoutError)
            }
        })
        UserDefaults.standard.set(nil, forKey: "arrayOfYourFriendsline")
        print("++++++++++++++++++++++++++++++CLEAR CACHE++++++++++++++++++++++++++++++")
        MessagesController().selectorCounter = 0
        selectorIdentifier = false
        self.tabBarController?.selectedIndex = 0
    }
    func chekIfUserDeleteAccount() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(uid!).child("wasDeleted")
        ref.observeSingleEvent(of: .value) { (snap) in
            if snap.value as? String == "bySelf" {
                let alert = UIAlertController(title: "This account was deleted", message: "Do you want to restore it?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                    let uid = Auth.auth().currentUser?.uid
                    let ref = Database.database().reference().child("users").child(uid!)
                    ref.observeSingleEvent(of: .value) { (snap) in
                        guard let value = snap.value as? [String: Any] else {return}
                        let arcAvatar = value["arcProfileImageUrl"] as! String
                        let arcHomeLocation = value["arcLoc"] as! String
                        let archiveArray = ["profileImageUrl": arcAvatar, "loc": arcHomeLocation] as [String: Any]
                        ref.updateChildValues(archiveArray)
                        ref.child("wasDeleted").removeValue()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadMyProfile"), object: nil)
                    }
                }))
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: {action in
                    self.present(LoginMethodController(), animated: false, completion: {
                        do {
                            let uid = Auth.auth().currentUser?.uid
                            try Auth.auth().signOut()
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signOut"), object: nil, userInfo: ["signOutUid": uid])
                        }
                        catch let logoutError {
                            print (logoutError)
                        }
                    })
                }))
                self.present(alert, animated: true)
            }
        }
    }
    @objc func goToSettingsController(){
        let profileSettingsController = ProfileSettingsController()
        let navController = UINavigationController(rootViewController: profileSettingsController)
        present(navController, animated: true, completion: nil)
    }
    @objc func setupUserPropsValues() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(uid!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            let meetChecked = value["meetChecked"] as? Bool
            let dateChecked = value["dateChecked"] as? Bool
            self.currentLocationViewHeightAnchor?.isActive = false
            if value["currentLoc"] as? String != nil && value["currentLoc"] as? String != "" {
                self.curLoc = value["currentLoc"] as? String
                self.currentLocationViewHeightAnchor = self.currentLocationView.heightAnchor.constraint(equalToConstant: 32)
            } else {
                self.currentLocationViewHeightAnchor = self.currentLocationView.heightAnchor.constraint(equalToConstant: 0)
            }
            self.currentLocationViewHeightAnchor?.isActive = true
            let acceptingGuests = value["acceptingGuests"] as? String
            let homeLocation = value["loc"] as? String
            let name = value["name"] as? String
            let profileImageUrl = value["profileImageUrl"] as? String
            let occupation = value["occupation"] as? String
            let age = value["age"] as? String
            let signUpDate = value["signUpDate"] as? Int
            let searchName = value["searchName"] as? String
            if signUpDate == nil {
                let creationDate = Int((Auth.auth().currentUser?.metadata.creationDate?.timeIntervalSince1970)!)
                print("creationDate:` ", creationDate)
                let creationDateReference = Database.database().reference().child("users").child(uid!)
                creationDateReference.updateChildValues(["signUpDate": creationDate])
            }
            if searchName == nil {
                let ref = Database.database().reference().child("users").child(uid!)
                ref.updateChildValues(["searchName": name?.uppercased()])
            }
            
            self.currentLocationView.text = "Current location: " + self.curLoc!
            self.homeLocationView.text = /*"City, Country: " + */homeLocation!
            if value["aboutServicesEnabled"] != nil {
               self.aboutServicesEnabled = value["aboutServicesEnabled"] as! Bool
            }
            if value["offerServiseChecked"] != nil {
                self.offerServiseChecked = value["offerServiseChecked"] as! Bool
            }
            self.aboutServicesTextTitleTopAnchor?.isActive = false
            self.aboutServicesTextTitleHeightAnchor?.isActive = false
            self.aboutServicesTextViewHeightAnchor?.isActive = false
            if self.aboutServicesEnabled && self.offerServiseChecked {//
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
            if value["aboutMe"] != nil {
                self.aboutMe = value["aboutMe"] as? String
            }
            if value["aboutMyPlace"] != nil {
                self.aboutMyPlace = value["aboutMyPlace"] as? String
            }
            self.meetingUpTextViewHeightAnchor?.isActive = false
            if meetChecked == true {
                self.meetingUpTextView.text = "Meeting up"
                self.meetingUpTextViewHeightAnchor = self.meetingUpTextView.heightAnchor.constraint(equalToConstant: 28)
            } else {
                self.meetingUpTextViewHeightAnchor = self.meetingUpTextView.heightAnchor.constraint(equalToConstant: 0)
            }
            self.meetingUpTextViewHeightAnchor?.isActive = true
            self.datingTextViewHeightAnchor?.isActive = false
            if dateChecked == true {
                self.datingTextView.text = "Dating"
                self.datingTextViewHeightAnchor = self.datingTextView.heightAnchor.constraint(equalToConstant: 28)
            } else {
                self.datingTextViewHeightAnchor = self.datingTextView.heightAnchor.constraint(equalToConstant: 0)
            }
            self.datingTextViewHeightAnchor?.isActive = true
            self.accepingGuestsTextViewHeightAnchor?.isActive = false
            if acceptingGuests == "maybe"{
                self.accepingGuestsTextView.text = "Maybe accepting guests"
                self.accepingGuestsTextViewHeightAnchor = self.accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 28)
            } else if acceptingGuests == "yes"{
                self.accepingGuestsTextView.text = "Accepting guests"
                self.accepingGuestsTextViewHeightAnchor = self.accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 28)
            } else {
                self.accepingGuestsTextViewHeightAnchor = self.accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 0)
            }
            self.accepingGuestsTextViewHeightAnchor?.isActive = true
            if profileImageUrl == "empty" {
                self.profileAvatarView.image = UIImage(named: "emptyavatar")
            } else if profileImageUrl == "deleted" {
                self.profileAvatarView.image = UIImage(named: "deletedprofile")
            } else {
                self.profileAvatarView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
            }
            let nameAndAge = name! + " " + age!
            let nameLen = name?.count
            let ageLen = age?.count
            let nameAgeLen = nameAndAge.count
            let range = NSRange(location: 0, length: nameAgeLen)
            let attributedStr = NSMutableAttributedString.init(string: nameAndAge)
            attributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 22), range: range)
            attributedStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 22), range: NSRange(location: nameLen! + 1, length: ageLen!))
            attributedStr.addAttribute(.foregroundColor, value: CustomColors.commonGrey1, range: range)
            self.navigationItem.title = nameAndAge
            self.memberNameAndAge.attributedText = attributedStr
            self.homeLocationView.text = /*"City, Country: " + */homeLocation!
            self.occupationText.text = occupation
            self.occupationTextHeightAnchor?.isActive = false
            if occupation?.count != 0 {
                self.occupationTextHeightAnchor = self.occupationText.heightAnchor.constraint(equalToConstant: 28)
            } else {
                self.occupationTextHeightAnchor = self.occupationText.heightAnchor.constraint(equalToConstant: 0)
            }
            self.occupationTextHeightAnchor?.isActive = true
            
            self.aboutMeTextTitleHeightAnchor?.isActive = false
            self.aboutMeTextViewHeightAnchor?.isActive  = false
            self.aboutMeTextTitleTopAnchor?.isActive = false
            if self.aboutMe != "" && self.aboutMe != nil {
                let height1 = self.estimateFrameForText(text: self.aboutMe!).height + 10
                self.aboutMeTextView.text = self.aboutMe
                self.aboutMeTextTitleHeightAnchor = self.aboutMeTextTitle.heightAnchor.constraint(equalToConstant: 23)
                self.aboutMeTextViewHeightAnchor = self.aboutMeTextView.heightAnchor.constraint(equalToConstant: height1)
                self.aboutMeTextTitleTopAnchor = self.aboutMeTextTitle.topAnchor.constraint(equalTo: self.aboutServicesTextView.bottomAnchor, constant: 20)
            } else {
                self.aboutMeTextTitleHeightAnchor = self.aboutMeTextTitle.heightAnchor.constraint(equalToConstant: 0)
                self.aboutMeTextViewHeightAnchor = self.aboutMeTextView.heightAnchor.constraint(equalToConstant: 0)
                self.aboutMeTextTitleTopAnchor = self.aboutMeTextTitle.topAnchor.constraint(equalTo: self.aboutServicesTextView.bottomAnchor, constant: 0)
            }
            self.aboutMeTextTitleHeightAnchor?.isActive = true
            self.aboutMeTextViewHeightAnchor?.isActive  = true
            self.aboutMeTextTitleTopAnchor?.isActive = true
            
            
            
            self.aboutMyPlaceTextTitleTopAnchor?.isActive = false
            self.aboutMyPlaceTextTitleHeightAnchor?.isActive = false
            self.aboutMyPlaceTextViewHeightAnchor?.isActive = false
            if self.aboutMyPlace != "" && self.aboutMyPlace != nil  {
                let height2 = self.estimateFrameForText(text: self.aboutMyPlace!).height + 10
                self.aboutMyPlaceTextView.text = self.aboutMyPlace
                self.aboutMyPlaceTextTitleHeightAnchor = self.aboutMyPlaceTextTitle.heightAnchor.constraint(equalToConstant: 23)
                self.aboutMyPlaceTextViewHeightAnchor = self.aboutMyPlaceTextView.heightAnchor.constraint(equalToConstant: height2)
                self.aboutMyPlaceTextTitleTopAnchor = self.aboutMyPlaceTextTitle.topAnchor.constraint(equalTo: self.aboutMeTextView.bottomAnchor, constant: 20)
            } else {
                self.aboutMyPlaceTextTitleHeightAnchor = self.aboutMyPlaceTextTitle.heightAnchor.constraint(equalToConstant: 0)
                self.aboutMyPlaceTextViewHeightAnchor = self.aboutMyPlaceTextView.heightAnchor.constraint(equalToConstant: 0)
                self.aboutMyPlaceTextTitleTopAnchor = self.aboutMyPlaceTextTitle.topAnchor.constraint(equalTo: self.aboutMeTextView.bottomAnchor, constant: 0)
            }
            self.aboutMyPlaceTextTitleHeightAnchor?.isActive = true
            self.aboutMyPlaceTextViewHeightAnchor?.isActive = true
            self.aboutMyPlaceTextTitleTopAnchor?.isActive = true
        })
    }
    func estimateFrameForText(text: String) -> CGRect {
        let width = scrollView.frame.width - 70
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)], context: nil)
    }
    var aboutServicesTextTitleHeightAnchor: NSLayoutConstraint?
    var aboutServicesTextViewHeightAnchor: NSLayoutConstraint?
    var aboutServicesTextTitleTopAnchor: NSLayoutConstraint?
    var aboutMyPlaceTextTitleHeightAnchor: NSLayoutConstraint?
    var aboutMyPlaceTextViewHeightAnchor: NSLayoutConstraint?
    var aboutMyPlaceTextTitleTopAnchor: NSLayoutConstraint?
    var aboutMeTextTitleTopAnchor: NSLayoutConstraint?
    var aboutMeTextTitleHeightAnchor: NSLayoutConstraint?
    var aboutMeTextViewHeightAnchor: NSLayoutConstraint?
    var occupationTextHeightAnchor: NSLayoutConstraint?
    var accepingGuestsTextViewHeightAnchor: NSLayoutConstraint?
    var datingTextViewHeightAnchor: NSLayoutConstraint?
    var meetingUpTextViewHeightAnchor: NSLayoutConstraint?
    var currentLocationViewHeightAnchor: NSLayoutConstraint?
    
    func profileAvatarContainerViewSetup(){
        view.addSubview(profileAvatarContainerView)//addPicsButton
        profileAvatarContainerView.addSubview(profileAvatarView)
        profileAvatarContainerView.addSubview(goWishlistButton)
        profileAvatarContainerView.addSubview(addPicsButton)
        
        profileAvatarContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        profileAvatarContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileAvatarContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        profileAvatarContainerView.heightAnchor.constraint(equalTo: profileAvatarContainerView.widthAnchor).isActive = true
        
        profileAvatarView.centerXAnchor.constraint(equalTo: profileAvatarContainerView.centerXAnchor).isActive = true
        profileAvatarView.centerYAnchor.constraint(equalTo: profileAvatarContainerView.centerYAnchor).isActive = true
        profileAvatarView.widthAnchor.constraint(equalTo: profileAvatarContainerView.widthAnchor).isActive = true
        profileAvatarView.heightAnchor.constraint(equalTo: profileAvatarContainerView.heightAnchor).isActive = true
        
        goWishlistButton.rightAnchor.constraint(equalTo: profileAvatarContainerView.rightAnchor).isActive = true
        goWishlistButton.bottomAnchor.constraint(equalTo: profileAvatarContainerView.bottomAnchor, constant: -25).isActive = true
        goWishlistButton.widthAnchor.constraint(equalToConstant: 85).isActive = true
        goWishlistButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addPicsButton.rightAnchor.constraint(equalTo: profileAvatarContainerView.rightAnchor).isActive = true
        addPicsButton.bottomAnchor.constraint(equalTo: goWishlistButton.topAnchor, constant: -15).isActive = true
        addPicsButton.widthAnchor.constraint(equalToConstant: 85).isActive = true
        addPicsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func memberPropsContainerSetup(){
        view.addSubview(scrollView)
        scrollView.addSubview(memberNameAndAge)
        scrollView.addSubview(occupationText)
        scrollView.addSubview(homeLocationView)
        scrollView.addSubview(currentLocationView)
        scrollView.addSubview(accepingGuestsTextView)////aboutMyServicesTextTitle aboutServicesTextView
        scrollView.addSubview(meetingUpTextView)
        scrollView.addSubview(datingTextView)
        scrollView.addSubview(aboutMyServicesTextTitle)
        scrollView.addSubview(aboutServicesTextView)
        scrollView.addSubview(aboutMeTextTitle)
        scrollView.addSubview(aboutMeTextView)
        scrollView.addSubview(aboutMyPlaceTextTitle)
        scrollView.addSubview(aboutMyPlaceTextView)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: profileAvatarContainerView.bottomAnchor, constant: 10).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        memberNameAndAge.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        memberNameAndAge.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        memberNameAndAge.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        memberNameAndAge.heightAnchor.constraint(equalToConstant: 35).isActive = true
        memberNameAndAge.textInputView.leftAnchor.constraint(equalTo: memberNameAndAge.leftAnchor, constant: 2).isActive = true
        
        occupationText.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        occupationText.topAnchor.constraint(equalTo: memberNameAndAge.bottomAnchor).isActive = true
        occupationText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        occupationTextHeightAnchor = occupationText.heightAnchor.constraint(equalToConstant: 0)
        occupationTextHeightAnchor?.isActive = true
        
        homeLocationView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        homeLocationView.topAnchor.constraint(equalTo: occupationText.bottomAnchor).isActive = true
        homeLocationView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        homeLocationView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        currentLocationView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        currentLocationView.topAnchor.constraint(equalTo: homeLocationView.bottomAnchor).isActive = true
        currentLocationView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        currentLocationViewHeightAnchor = self.currentLocationView.heightAnchor.constraint(equalToConstant: 0)
        currentLocationViewHeightAnchor?.isActive = true
        
        accepingGuestsTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        accepingGuestsTextView.topAnchor.constraint(equalTo: currentLocationView.bottomAnchor).isActive = true
        accepingGuestsTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        accepingGuestsTextViewHeightAnchor = self.accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 0)
        accepingGuestsTextViewHeightAnchor?.isActive = true
        
        meetingUpTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        meetingUpTextView.topAnchor.constraint(equalTo: accepingGuestsTextView.bottomAnchor).isActive = true
        meetingUpTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        meetingUpTextViewHeightAnchor = self.meetingUpTextView.heightAnchor.constraint(equalToConstant: 0)
        meetingUpTextViewHeightAnchor?.isActive = true
        
        datingTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        datingTextView.topAnchor.constraint(equalTo: meetingUpTextView.bottomAnchor).isActive = true
        datingTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        datingTextViewHeightAnchor = self.datingTextView.heightAnchor.constraint(equalToConstant: 0)
        datingTextViewHeightAnchor?.isActive = true
        
        ////aboutMyServicesTextTitleHeightAnchor aboutServicesTextViewHeightAnchor aboutMyServicesTextTitleTopAnchor
        
        aboutMyServicesTextTitle.leftAnchor.constraint(equalTo:  scrollView.leftAnchor, constant: 38).isActive = true
        aboutServicesTextTitleTopAnchor = aboutMyServicesTextTitle.topAnchor.constraint(equalTo: datingTextView.bottomAnchor, constant: 20)
        aboutServicesTextTitleTopAnchor?.isActive = true
        aboutMyServicesTextTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        aboutServicesTextTitleHeightAnchor = self.aboutMyServicesTextTitle.heightAnchor.constraint(equalToConstant: 0)
        aboutServicesTextTitleHeightAnchor?.isActive = true
        
        aboutServicesTextView.leftAnchor.constraint(equalTo:  scrollView.leftAnchor, constant: 33).isActive = true
        aboutServicesTextView.topAnchor.constraint(equalTo: aboutMyServicesTextTitle.bottomAnchor).isActive = true
        aboutServicesTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        aboutServicesTextViewHeightAnchor = self.aboutServicesTextView.heightAnchor.constraint(equalToConstant: 0)
        aboutServicesTextViewHeightAnchor?.isActive = true
        
        ///
        
        aboutMeTextTitle.leftAnchor.constraint(equalTo:  scrollView.leftAnchor, constant: 38).isActive = true
        aboutMeTextTitleTopAnchor = aboutMeTextTitle.topAnchor.constraint(equalTo: aboutServicesTextView.bottomAnchor, constant: 20)
        aboutMeTextTitleTopAnchor?.isActive = true
        aboutMeTextTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
        aboutMeTextTitleHeightAnchor = self.aboutMeTextTitle.heightAnchor.constraint(equalToConstant: 0)
        aboutMeTextTitleHeightAnchor?.isActive = true
        
        aboutMeTextView.leftAnchor.constraint(equalTo:  scrollView.leftAnchor, constant: 33).isActive = true
        aboutMeTextView.topAnchor.constraint(equalTo: aboutMeTextTitle.bottomAnchor).isActive = true
        aboutMeTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        aboutMeTextViewHeightAnchor = self.aboutMeTextView.heightAnchor.constraint(equalToConstant: 0)
        aboutMeTextViewHeightAnchor?.isActive = true
        
        aboutMyPlaceTextTitle.leftAnchor.constraint(equalTo:  scrollView.leftAnchor, constant: 38).isActive = true
        aboutMyPlaceTextTitleTopAnchor = aboutMyPlaceTextTitle.topAnchor.constraint(equalTo: aboutMeTextView.bottomAnchor, constant: 20)
        aboutMyPlaceTextTitleTopAnchor?.isActive = true
        aboutMyPlaceTextTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        aboutMyPlaceTextTitleHeightAnchor = self.aboutMyPlaceTextTitle.heightAnchor.constraint(equalToConstant: 0)
        aboutMyPlaceTextTitleHeightAnchor?.isActive = true
        
        aboutMyPlaceTextView.leftAnchor.constraint(equalTo:  scrollView.leftAnchor, constant: 33).isActive = true
        aboutMyPlaceTextView.topAnchor.constraint(equalTo: aboutMyPlaceTextTitle.bottomAnchor).isActive = true
        aboutMyPlaceTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        aboutMyPlaceTextViewHeightAnchor = self.aboutMyPlaceTextView.heightAnchor.constraint(equalToConstant: 0)
        aboutMyPlaceTextViewHeightAnchor?.isActive = true
        aboutMyPlaceTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
    }
//    func hideAllWhenDeleted(){
//        userWasDeleted = true
//
//        friendText.isHidden = true
//        occupationText.isHidden = true
//        currentLocationView.isHidden = true
//        currentLocationView.isHidden = true
//        homeLocationView.isHidden = true
//        accepingGuestsTextView.isHidden = true
//        meetingUpTextView.isHidden = true
//        datingTextView.isHidden = true
//        aboutMeTextTitle.isHidden = true
//        aboutMeTextView.isHidden = true
//        aboutMyPlaceTextTitle.isHidden = true
//        aboutMyPlaceTextView.isHidden = true
//        profileAvatarView.image = UIImage(named: "deletedprofile")
//    }
//    func checkIfUserDeleted() {
//        let uid = Auth.auth().currentUser?.uid
//        let ref = Database.database().reference().child("users").child(uid!).child("wasDeleted")
//        ref.observeSingleEvent(of: .value) { (snap) in
//            if snap.value as? String == "byAdministration" {
//                print("this user was deleted by administration")
//                self.hideAllWhenDeleted()
//                let alert = UIAlertController(title: "This user got banned from MyFriendsRoom", message: nil, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true)
//            } else if snap.value as? String == "bySelf" {
//                print("this user deletedd each self")
//                self.hideAllWhenDeleted()
//                let alert = UIAlertController(title: "This profile has been deleted", message: nil, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true)
//            }
//        }
//    }
    @objc func newSigninActions() {
        setupUserPropsValues()
        chekIfUserDeleteAccount()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(mfrContainerView)
        profileAvatarContainerViewSetup()
        memberPropsContainerSetup()
        setupUserPropsValues()
        setupNavBarItems()
        getmyImagesURLSArray()
        checkIfYouAreBanned()
        NotificationCenter.default.addObserver(self, selector: #selector(newSigninActions), name: NSNotification.Name(rawValue: "newSignin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupUserPropsValues), name: NSNotification.Name(rawValue: "reloadMyProfile"), object: nil)
    }
}
