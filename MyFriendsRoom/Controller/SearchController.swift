//
//  SearchController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 24.09.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import Firebase
import UIKit
import CoreLocation
import GooglePlaces
//var friendslineArray: Array = Array<Any>()
//var friendsLine = [searchResult]()
class SearchController: UIViewController {
    var localFL = [searchResult]()
    var yourBlacklist: Array = Array<Any>()
    var yourWishlist = [String]()
    var youAreBanned = false
    var searchName = String()
    var usernameSearch = String()
    var ageFrom = Int()
    var ageTo = Int()
    var fromSearchMembers = false
    let welcomeTitle: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.lightOrange1
        tt.text = "Search"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 20)
        return tt
    }()
    let nameTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "By name"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    let searchMembers: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 18)
        return tf
    }()
    let allMembersButton: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(allMembersButtonCheck), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = CustomColors.lightOrange1
        b.setTitle("ALL MEMBERS", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return b
    }()
    let contactsOnlyButton: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(contactsOnlyButtonCheck), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = CustomColors.commonGrey1
        b.setTitle("CONTACTS ONLY", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return b
    }()
    let welcomeTextsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let search_travelCheckboxButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(travelCheck), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  travel accommodation", size: 18, forState: .normal)
        tcb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return tcb
    }()
    let search_meetCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(meetCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  to meet up with people", size: 18, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    let search_dateCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(dateCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  to date", size: 18, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    let search_discoverCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(discoverCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  to discover the city", size: 18, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    let lookingForContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let searchLocTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Current search location"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 18)
        return tt
    }()
    let searchLocTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "...", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 18)
        tf.text = "..."
        tf.addTarget(self, action: #selector(goACN), for: UIControlEvents.editingDidBegin)
        return tf
    }()
    let searchLocSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let lookingForTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "I want"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 18)
        return tt
    }()
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = CustomColors.commonBlue1
        button.setTitle("GO", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: [])
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 50
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.addTarget(self, action: #selector(wayToSearching), for: .touchUpInside)
        return button
    }()
    let lookingForGenderTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Options"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 17)
        return tt
    }()
    let femaleCheckboxButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(femaleCheck), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  female", size: 18, forState: .normal)
        tcb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return tcb
    }()
    let maleCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(maleCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  male", size: 18, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    let bothCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(bothCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  both", size: 18, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    let popup: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = CustomColors.commonBlue1.cgColor
        return view
    }()
    let popupOkButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(okButton), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setTitle("OK", for: .normal)
        tcb.setTitleColor(CustomColors.commonBlue1, for: .normal)
        return tcb
    }()
    let searchMembersPopup: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = CustomColors.commonBlue1.cgColor
        return view
    }()
    let searchMembersButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(showSearchMembersPopup), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "Search members   ", icon: .FASearch, postfixText: "", size: 18, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonGrey1, forState: .normal)
        return cb
    }()
    let searchMembersTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Search members"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 18)
        return tt
    }()
    let ageTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "By age"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    let ageFromTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "From", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = UIKeyboardType.numberPad
        return tf
    }()
    let ageToTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "To", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = UIKeyboardType.numberPad
        return tf
    }()
    lazy var searchMemberGoButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = CustomColors.commonBlue1
        button.setTitle("GO", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: [])
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 50
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.addTarget(self, action: #selector(compareSearchMemberData), for: .touchUpInside)
        return button
    }()
    let usernameTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "By username"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    let usernameSearchMembers: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Userame", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 18)
        return tf
    }()
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Back", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(CustomColors.commonBlue1, for: [])
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(closeSearchMembers), for: .touchUpInside)
        return button
    }()
    let optionsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let smSearchLocTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Search location"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 18)
        return tt
    }()
    let smSearchLocTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "City", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 18)
        tf.addTarget(self, action: #selector(goACSM), for: UIControlEvents.editingDidBegin)
        return tf
    }()
//    let smSearchLocSeperatorView: UIView = {
//        let view = UIView()
//        view.backgroundColor = CustomColors.commonGrey1
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    @objc func closeSearchMembers(){
        searchMembersPopup.isHidden = true
    }
    @objc func compareSearchMemberData(){
        print("case 1")
        let ageFromInput = ageFromTextField.text!
        let ageToInput = ageToTextField.text!
        if ageFromInput.count > 1 && ageFromInput.count < 4 {
            ageFrom = Int(ageFromInput)!
            if ageFrom < 18 {
                ageFrom = 18
            } else if ageFrom > 100 {
                ageFrom = 100
                print("case 6")
            }
            print("case 2")
        }  else {
            ageFrom = 18
            print("case 3")
        }
        if ageToInput.count > 1 && ageToInput.count < 4 {
            ageTo = Int(ageToInput)!
            print("case 4")
            if ageTo < 18 {
                print("case 7")
                ageTo = 18
            } else if ageFrom > ageTo {
                ageTo = ageFrom
                print("case 8")
            } else if ageTo > 100 {
                ageTo = 100
                print("case 9")
            }
        } else {
            print("case 5")
            ageTo = 100
        }
        ageFromTextField.text = String(ageFrom)
        ageToTextField.text = String(ageTo)
        searchName = searchMembers.text!
        searchMembersPopup.isHidden = true
        fromSearchMembers = true
        takeSearchResults()
        print("searchName: \(searchName)\nageFrom: \(ageFrom)\nageTo: \(ageTo)")
    }
    @objc func showSearchMembersPopup(){
        searchMembersPopup.isHidden = false
        print("haha")
        print(searchMembersPopup.frame)
    }
    func checkIfYouAreBanned() {
        let uid = Auth.auth().currentUser?.uid
        guard uid != nil else {return}
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
    @objc func okButton() {
        popup.isHidden = true
        takeSearchResults()
    }
    var isAllMembersSearching = true
    @objc func allMembersButtonCheck(){
        if isAllMembersSearching == false {
            allMembersButton.backgroundColor = CustomColors.lightOrange1
            contactsOnlyButton.backgroundColor = CustomColors.commonGrey1
            isAllMembersSearching = true
        }
    }
    @objc func contactsOnlyButtonCheck(){
        if isAllMembersSearching == true {
            contactsOnlyButton.backgroundColor = CustomColors.lightOrange1
            allMembersButton.backgroundColor = CustomColors.commonGrey1
            isAllMembersSearching = false
        }
    }
    var search_sex: String?
    @objc func femaleCheck(){
        checkIfYouAreBanned()
        femaleCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        maleCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        bothCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        search_sex = "female"
    }
    @objc func maleCheck(){
        checkIfYouAreBanned()
        femaleCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        maleCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        bothCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        search_sex = "male"
    }
    @objc func bothCheck(){
        checkIfYouAreBanned()
        femaleCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        maleCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        bothCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        search_sex = "both"
    }
    @objc func checkIfAnyChecked(phone: String) {
        if travelChecked == true || meetChecked == true || dateChecked == true || discoverChecked == true {
            if phone == "old" {
                popup.isHidden = false
            } else if phone == "new" {
                takeSearchResults()
            }
            lookingForTitle.textColor = CustomColors.commonGrey1
        } else {
            let alert = UIAlertController(title: "Please choose at least one option", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            lookingForTitle.textColor = CustomColors.lightOrange1
        }
    }
    func saveLastConfig(){
        let uid = Auth.auth().currentUser!.uid//
        guard let search_travelChecked = travelChecked as Bool?, let search_meetChecked = meetChecked as Bool?, let search_dateChecked = dateChecked as Bool?, let search_loc = searchLocTextField.text
            else {
                print("Form is not valid")
                return
        }
        let values = ["travelChecked": search_travelChecked, "searchMeetChecked": search_meetChecked, "searchDateChecked": search_dateChecked, "searchLoc": search_loc, "search_sex": search_sex, "discoverChecked": discoverChecked] as [String : Any]
        self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
    }
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        let ref = Database.database().reference(fromURL: "https://myfriendsroomtest.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        })
    }
    func searchNameIsNotEmpty() -> Bool {
        searchName = self.searchMembers.text!
        var notEmprty = false
        if (searchName.count) > 0 {
            notEmprty = true
        }
        return notEmprty
    }
    func usernameIsNotEmpty() -> Bool {
        usernameSearch = self.usernameSearchMembers.text!
        var notEmprty = false
        if (usernameSearch.count) > 0 {
            notEmprty = true
        }
        return notEmprty
    }
    var sortMethod = "active"//"random" "active" "signUp"
    @objc func takeSearchResults() {
        saveLastConfig()
//        friendslineArray = []
        yourBlacklist = []
        localFL = []
        checkIfYouAreBanned()
        let uid = Auth.auth().currentUser!.uid
        let blacklistRef = Database.database().reference().child("users-blacklists").child(uid)
        let smLoc = smSearchLocTextField.text
        blacklistRef.observeSingleEvent(of: .value) { (snap) in
            let snapshot = snap.children.allObjects as! [DataSnapshot]
            for blockedUser in snapshot {
                self.yourBlacklist.append(blockedUser.key)
            }
            let wishref = Database.database().reference().child("users-wishlists").child(uid)
            wishref.observeSingleEvent(of: .value) { (snap) in
                for child in snap.children.allObjects as! [DataSnapshot] {
                    self.yourWishlist.append(child.key)
                }
                print("yourWishlist:",self.yourWishlist)
                let ref = Database.database().reference().child("users")
                var query = ref.queryOrdered(byChild: "loc").queryEqual(toValue: self.searchLocTextField.text)
                if self.fromSearchMembers {
                    if smLoc?.count != 0 {
                        query = ref.queryOrdered(byChild: "loc").queryEqual(toValue: self.smSearchLocTextField.text)
                    } else if self.searchNameIsNotEmpty() && self.usernameIsNotEmpty() == false {
                        query = ref.queryOrdered(byChild: "searchName").queryEqual(toValue: self.searchName.uppercased())
                    } else if self.usernameIsNotEmpty() {
                        query = ref.queryOrdered(byChild: "username").queryEqual(toValue: self.usernameSearch)
                    } else {
                        query = ref
                    }
                    
//                    if self.searchNameIsNotEmpty() && self.usernameIsNotEmpty() == false {
//                        query = ref.queryOrdered(byChild: "name").queryEqual(toValue: self.searchName)
//                    } else if self.usernameIsNotEmpty() {
//                        query = ref.queryOrdered(byChild: "username").queryEqual(toValue: self.usernameSearch)
//                    } else if smLoc?.count != 0 {
//                        query = ref.queryOrdered(byChild: "loc").queryEqual(toValue: self.smSearchLocTextField.text)
//                    } else {
//                        query = ref
//                    }
                }
                query.observeSingleEvent(of: .value, with: { (snapshot) in
                    for child in snapshot.children.allObjects as! [DataSnapshot] {
                        var isInBlacklist = false
                        var isInWishlist = false
//                        var singleUserArray = [String:Any]()
                        guard let value = child.value as? [String: Any] else { continue }
                        let offerServiseChecked = value["offerServiseChecked"] as? Bool
                        let aboutServicesEnabled = value["aboutServicesEnabled"] as? Bool
                        let searchResultMeetChecked = value["meetChecked"] as? Bool
                        let deletedUser = value["wasDeleted"] as? String
                        let searchResultDateChecked = value["dateChecked"] as? Bool
                        let searchResultAcceptingGuests = value["acceptingGuests"] as? String
                        let logicalSearchResultAcceptingGuests: Bool
                        let isActive = value["isActive"] as? Bool
                        let disconectTime = value["disconectTime"] as? Int
                        let signUpDate = value["signUpDate"] as? Int
//                        print("name: ", value["name"], ", isActive: ", isActive, ", disconectTime: ", disconectTime)
//                        let searchResultEmail = value["email"] as? String
//                        let searchResultHomeLocation = value["loc"] as? String
//                        let searchResultName = value["name"] as? String
//                        let searchResultProfileImageUrl = value["profileImageUrl"] as? String
//                        let searchResultOccupationField = value["occupation"] as? String
                        let searchResultAge = value["age"] as? String
                        let yourSex = value["yourSex"] as? String
                        let sexCoincidence: Bool
                        let discoverCoincidence: Bool
                        if self.discoverChecked == true {
                            if offerServiseChecked == true && aboutServicesEnabled == true {
                                discoverCoincidence = true
                            } else {
                                discoverCoincidence = false
                            }
                        } else {
                            discoverCoincidence = false
                        }
                        var allMembersConcidence = false
//                        if self.dateChecked == true {
                            if self.search_sex == "both" {
                                sexCoincidence = true
                            } else if self.search_sex == yourSex {
                                sexCoincidence = true
                            } else {
                                sexCoincidence = false
                            }
//                        } else {
//                            sexCoincidence = true
//                        }
                        
                        let userId = child.key
                        for blockedItem in self.yourBlacklist {
                            if userId == blockedItem as! String {
                                isInBlacklist = true
                                break
                            }
                        }
                        for wishlistitem in self.yourWishlist {
                            if userId == wishlistitem {
                                isInWishlist = true
                            }
                        }
                        if searchResultAcceptingGuests == "maybe" || searchResultAcceptingGuests == "yes" {
                            logicalSearchResultAcceptingGuests = true
                        } else {
                            logicalSearchResultAcceptingGuests = false
                        }
                        var userNotDeleted = false
                        if deletedUser != "bySelf" && deletedUser != "byAdministration" {
                            userNotDeleted = true
                        }
                        var travelCoincidence = false
                        var meetCoincidence = false
                        var dateCoincidence = false
                        if logicalSearchResultAcceptingGuests == true && self.travelChecked == true{
                            travelCoincidence = true
                        }
                        if searchResultMeetChecked == true && self.meetChecked == true{
                            meetCoincidence = true
                        }
                        if searchResultDateChecked == true && self.dateChecked == true{
                            dateCoincidence = true
                        }
                        if self.isAllMembersSearching != true {
                            for userFromFofArray in yourFriendsOfFriendsArray.keys {
                                if userId == userFromFofArray {
                                    allMembersConcidence = true
                                }
                            }
                        } else {
                            allMembersConcidence = true
                        }
                        var allIsOk = false
                        if self.fromSearchMembers == false {
//                            print("name: ", value["name"], " sexCoincidence: ", sexCoincidence)
                            if userNotDeleted && isInBlacklist == false && (allMembersConcidence == true && (uid != userId && ( discoverCoincidence == true || ( sexCoincidence == true && (travelCoincidence == true || meetCoincidence == true || dateCoincidence == true))))){
                                allIsOk = true
                            }
                        } else {
                            if searchResultAge != nil {
                                let memberAge = Int(searchResultAge!)
                                print("memberAge: ", memberAge)
                                if memberAge != nil {
                                    if self.ageFrom <= memberAge! && self.ageTo >= memberAge! && userNotDeleted {
                                        allIsOk = true
                                    }
                                }
                            }
                        }
                        if allIsOk {
                            let dict = child.value
                            let search_result = searchResult(dictionary: dict as! [String : AnyObject])
//                            print("name", search_result.name)
                            search_result.userId = userId
                            if self.sortMethod == "active" {
                                if isActive != nil && disconectTime != nil {
                                    if isActive == true {
                                        search_result.priority = 99999999999999
                                    } else {
                                        search_result.priority = disconectTime
                                    }
                                } else {
                                    search_result.priority = 0
                                }
                            } else if self.sortMethod == "signUp" {
                                if signUpDate != nil {
                                    search_result.priority = signUpDate
                                } else {
                                    search_result.priority = 0
                                }
                            } else if self.sortMethod == "random" {
                                search_result.priority = 0
                            }
                            print("name: ", value["name"], ", isActive: ", isActive, ", disconectTime: ", disconectTime, ", priority: ", search_result.priority)
//                            friendsLine.append(search_result)
                            self.localFL.append(search_result)
                            
//                            singleUserArray.updateValue(userId, forKey: "userId")
//                            singleUserArray.updateValue(searchResultMeetChecked!, forKey: "meetChecked")
//                            singleUserArray.updateValue(searchResultDateChecked!, forKey: "dateChecked")
//                            singleUserArray.updateValue(searchResultAcceptingGuests!, forKey: "acceptingGuests")
//                            singleUserArray.updateValue(searchResultEmail!, forKey: "email")
//                            singleUserArray.updateValue(searchResultHomeLocation!, forKey: "loc")
//                            singleUserArray.updateValue(searchResultName!, forKey: "name")
//                            singleUserArray.updateValue(searchResultProfileImageUrl!, forKey: "profileImageUrl")
//                            singleUserArray.updateValue(searchResultOccupationField!, forKey: "occupation")
//                            singleUserArray.updateValue(searchResultAge!, forKey: "age")
//                            singleUserArray.updateValue(isInWishlist, forKey: "inWishlist")
//                            if let searchResultCurrentLoc = value["currentLoc"]{
//                                singleUserArray.updateValue(searchResultCurrentLoc, forKey: "currentLoc")
//                            }
//                            friendslineArray.append(singleUserArray)
                        }
                    }
                    if self.sortMethod == "active" || self.sortMethod == "signUp"{
                        self.localFL = self.localFL.sorted(by: { $0.priority as! Int > $1.priority as! Int })
                    } else if self.sortMethod == "random" {
                        var shuffled = [searchResult]()
                        for i in 0..<self.localFL.count {
                            let rand = Int(arc4random_uniform(UInt32(self.localFL.count)))
                            shuffled.append(self.localFL[rand])
                            self.localFL.remove(at: rand)
                        }
                        self.localFL = shuffled
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendLocalFL"), object: nil, userInfo: ["dict": self.localFL])
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
//                    print("friendslineArray \(friendslineArray)")
//                    UserDefaults.standard.set(friendslineArray, forKey: "arrayOfYourFriendsline")
//                    if friendslineArray.count == 0 {
//                        UserDefaults.standard.set(nil, forKey: "arrayOfYourFriendsline")
//                        self.present(InviteFriendsController(), animated: false, completion: nil)
//                    }
//
//                    let userDefaults = UserDefaults.standard
//                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: friendsLine)
//                    userDefaults.set(encodedData, forKey: "arrayOfYourFriendsline")
//                    userDefaults.synchronize()
//                    if friendsLine.count == 0 {
//                        UserDefaults.standard.set(nil, forKey: "arrayOfYourFriendsline")
//                        self.present(InviteFriendsController(), animated: false, completion: nil)
//                    }
                    let userDefaults = UserDefaults.standard
                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.localFL)
                    userDefaults.set(encodedData, forKey: "arrayOfYourFriendsline")
                    userDefaults.synchronize()
                    if self.localFL.count == 0 {
                        UserDefaults.standard.set(nil, forKey: "arrayOfYourFriendsline")
                        self.present(InviteFriendsController(), animated: false, completion: nil)
                    }
                    self.callIndex(selectedIndex: 1)
                    self.searchMembers.text = ""
                    self.usernameSearchMembers.text = ""
                    self.fromSearchMembers = false
                    self.smSearchLocTextField.text = ""
                })
            }
        }
        
        
    }
    func callIndex(selectedIndex: Int) {
        self.tabBarController?.selectedIndex = selectedIndex
    }
    var travelChecked = false, meetChecked = false, dateChecked = false, discoverChecked = false
    @objc func travelCheck(){
        var color = UIColor()
        if travelChecked == true {
            color = CustomColors.commonBlue1
            travelChecked = false
        } else {
            color = CustomColors.lightOrange1
            travelChecked = true
        }
        search_travelCheckboxButton.setFATitleColor(color: color, forState: .normal)
        print("travelChecked: ", travelChecked)
    }
    @objc func meetCheck(){
        var color = UIColor()
        if meetChecked == true {
            color = CustomColors.commonBlue1
            meetChecked = false
        } else {
            color = CustomColors.lightOrange1
            meetChecked = true
        }
        search_meetCheckboxButton.setFATitleColor(color: color, forState: .normal)
        print("meetChecked: ", meetChecked)
    }
    @objc func dateCheck(){
        var color = UIColor()
        if dateChecked == true {
            color = CustomColors.commonBlue1
            dateChecked = false
//            popup.isHidden = true
        } else {
            color = CustomColors.lightOrange1
            dateChecked = true
//            popup.isHidden = false
        }
        search_dateCheckboxButton.setFATitleColor(color: color, forState: .normal)
        print("dateChecked: ", dateChecked)
    }
    @objc func discoverCheck(){
        var color = UIColor()
        if discoverChecked == true {
            color = CustomColors.commonBlue1
            discoverChecked = false
            //            popup.isHidden = true
        } else {
            color = CustomColors.lightOrange1
            discoverChecked = true
            //            popup.isHidden = false
        }
        search_discoverCheckboxButton.setFATitleColor(color: color, forState: .normal)
        print("dateChecked: ", discoverChecked)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        getCurentSettings()
        view.backgroundColor = UIColor.white
        view.addSubview(welcomeTextsContainerView)
        setupNavBarItems()
        textsContainerSetup()
        lookingForSetupContainerView()
        optionsContainerOrPopupSelection()
        checkIfYouAreBanned()
        searchMembersPopupSetup()
        optionsContainerSetup()
        NotificationCenter.default.addObserver(self, selector: #selector(getCurentSettings), name: NSNotification.Name(rawValue: "newSignin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getCurentSettings), name: NSNotification.Name(rawValue: "reloadMyProfile"), object: nil)
    }
    @objc func getCurentSettings(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            print("snapshot: ", snapshot)
            guard let value = snapshot.value as? [String: Any] else { return }
            guard value["travelChecked"] != nil else {return}
            self.travelChecked = value["travelChecked"] as! Bool
            if value["searchMeetChecked"] != nil {
                self.meetChecked = value["searchMeetChecked"] as! Bool
            } else {
                self.meetChecked = value["meetChecked"] as! Bool
            }
            if value["searchDateChecked"] != nil {
                self.dateChecked = value["searchDateChecked"] as! Bool
            } else {
                self.dateChecked = value["dateChecked"] as! Bool
            }
            if value["searchLoc"] != nil && value["searchLoc"] as? String != "" {
                self.searchLocTextField.text = value["searchLoc"] as? String
            } else {
               
                self.searchLocTextField.text = value["loc"] as? String
            }
            if value["discoverChecked"] != nil {
                self.discoverChecked = value["discoverChecked"] as! Bool
            }
            if let theSearch_sex = value["search_sex"] as? String {
                let yourSex = value["yourSex"] as? String
                if theSearch_sex == "female" {
                    self.femaleCheck()
                } else if theSearch_sex == "male" {
                    self.maleCheck()
                } else {
                    self.bothCheck()
                }
            } else {
                let yourSex = value["yourSex"] as? String
                if yourSex == "female" {
                    self.maleCheck()
                } else {
                    self.femaleCheck()
                }
            }
            
//            print("2: \nmeetChecked:", self.meetChecked, "\ndateChecked: ", self.dateChecked, "\ntravelChecked: ", self.travelChecked)
            if self.travelChecked == true {
                self.search_travelCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
            }
            if self.meetChecked == true {
                self.search_meetCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
            }
            if self.dateChecked == true {
                self.search_dateCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
            }
            if self.discoverChecked == true {
                self.search_discoverCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
            }
        })
//        UserMetadata

    }
    
    func setupNavBarItems(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.lightOrange1]
        self.navigationItem.title = "Search"
        let dotmenuImage = UIImage(named: "dotmenu")?.withRenderingMode(.alwaysOriginal)
        let dotmenuButton = UIBarButtonItem(image: dotmenuImage, style: .plain, target: self, action: #selector(showMenu))
        navigationItem.rightBarButtonItem = dotmenuButton
    }
    @objc func showMenu(){
        if optionsContainer.isHidden == true {
            optionsContainer.isHidden = false
        } else {
            optionsContainer.isHidden = true
        }
    }
    func searchMembersPopupSetup(){
        view.addSubview(searchMembersPopup)
        searchMembersPopup.addSubview(searchMembersTitle)//smSearchLocTextTitle smSearchLocTextField smSearchLocSeperatorView
        searchMembersPopup.addSubview(nameTextTitle)
        searchMembersPopup.addSubview(searchMembers)
        searchMembersPopup.addSubview(ageTextTitle)
        searchMembersPopup.addSubview(ageFromTextField)
        searchMembersPopup.addSubview(ageToTextField)
        searchMembersPopup.addSubview(usernameTextTitle)
        searchMembersPopup.addSubview(usernameSearchMembers)
        searchMembersPopup.addSubview(smSearchLocTextTitle)
        searchMembersPopup.addSubview(smSearchLocTextField)
        searchMembersPopup.addSubview(searchMemberGoButton)
        searchMembersPopup.addSubview(backButton)
        
        searchMembersPopup.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchMembersPopup.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchMembersPopup.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        searchMembersPopup.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        searchMembersPopup.isHidden = true
        
        searchMembersTitle.centerXAnchor.constraint(equalTo: welcomeTextsContainerView.centerXAnchor).isActive = true
        searchMembersTitle.topAnchor.constraint(equalTo: welcomeTextsContainerView.topAnchor).isActive = true
        searchMembersTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        searchMembersTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        nameTextTitle.centerXAnchor.constraint(equalTo: searchMembersPopup.centerXAnchor).isActive = true
        nameTextTitle.topAnchor.constraint(equalTo: searchMembersTitle.bottomAnchor, constant: 20).isActive = true
        nameTextTitle.widthAnchor.constraint(equalToConstant: 290).isActive = true
        nameTextTitle.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        searchMembers.centerXAnchor.constraint(equalTo: searchMembersPopup.centerXAnchor).isActive = true
        searchMembers.topAnchor.constraint(equalTo: nameTextTitle.bottomAnchor, constant: 10).isActive = true
        searchMembers.widthAnchor.constraint(equalToConstant: 290).isActive = true
        searchMembers.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        ageTextTitle.centerXAnchor.constraint(equalTo: searchMembersPopup.centerXAnchor).isActive = true
        ageTextTitle.topAnchor.constraint(equalTo: searchMembers.bottomAnchor, constant: 20).isActive = true
        ageTextTitle.widthAnchor.constraint(equalToConstant: 290).isActive = true
        ageTextTitle.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        ageFromTextField.centerXAnchor.constraint(equalTo: searchMembersPopup.centerXAnchor).isActive = true
        ageFromTextField.topAnchor.constraint(equalTo: ageTextTitle.bottomAnchor, constant: 10).isActive = true
        ageFromTextField.widthAnchor.constraint(equalToConstant: 290).isActive = true
        ageFromTextField.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        ageToTextField.centerXAnchor.constraint(equalTo: searchMembersPopup.centerXAnchor).isActive = true
        ageToTextField.topAnchor.constraint(equalTo: ageFromTextField.bottomAnchor, constant: 10).isActive = true
        ageToTextField.widthAnchor.constraint(equalToConstant: 290).isActive = true
        ageToTextField.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        usernameTextTitle.centerXAnchor.constraint(equalTo: searchMembersPopup.centerXAnchor).isActive = true
        usernameTextTitle.topAnchor.constraint(equalTo: ageToTextField.bottomAnchor, constant: 20).isActive = true
        usernameTextTitle.widthAnchor.constraint(equalToConstant: 290).isActive = true
        usernameTextTitle.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        usernameSearchMembers.centerXAnchor.constraint(equalTo: searchMembersPopup.centerXAnchor).isActive = true
        usernameSearchMembers.topAnchor.constraint(equalTo: usernameTextTitle.bottomAnchor, constant: 10).isActive = true
        usernameSearchMembers.widthAnchor.constraint(equalToConstant: 290).isActive = true
        usernameSearchMembers.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        smSearchLocTextTitle.centerXAnchor.constraint(equalTo: searchMembersPopup.centerXAnchor).isActive = true
        smSearchLocTextTitle.topAnchor.constraint(equalTo: usernameSearchMembers.bottomAnchor, constant: 20).isActive = true
        smSearchLocTextTitle.widthAnchor.constraint(equalToConstant: 290).isActive = true
        smSearchLocTextTitle.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        smSearchLocTextField.centerXAnchor.constraint(equalTo: searchMembersPopup.centerXAnchor).isActive = true
        smSearchLocTextField.topAnchor.constraint(equalTo: smSearchLocTextTitle.bottomAnchor, constant: 10).isActive = true
        smSearchLocTextField.widthAnchor.constraint(equalToConstant: 290).isActive = true
        smSearchLocTextField.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        searchMemberGoButton.centerXAnchor.constraint(equalTo: searchMembersPopup.centerXAnchor).isActive = true
        searchMemberGoButton.topAnchor.constraint(equalTo: smSearchLocTextField.bottomAnchor, constant: 20).isActive = true
        searchMemberGoButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        searchMemberGoButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        backButton.centerXAnchor.constraint(equalTo: searchMembersPopup.centerXAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: searchMembersPopup.bottomAnchor, constant: -60).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 290).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.titleLabel?.leftAnchor.constraint(equalTo: backButton.leftAnchor).isActive = true
    }
    
    let optionsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    let sortResultsActiveSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let sortResultsActive: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(activeSortAction), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("Active", for: .normal)
        cb.backgroundColor = UIColor.lightGray
        cb.setTitleColor(CustomColors.commonGrey1, for: .normal)
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cb
    }()
    let sortResultsSignUpSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let sortResultsSignUp: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(signUpSortAction), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("Sign up date", for: .normal)
        cb.backgroundColor = UIColor.white
        cb.setTitleColor(CustomColors.commonGrey1, for: .normal)
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cb
    }()
    let sortResultsRandomSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let sortResultsRandom: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(randomSortAction), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("Random", for: .normal)
        cb.backgroundColor = UIColor.white
        cb.setTitleColor(CustomColors.commonGrey1, for: .normal)
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cb
    }()
    let sortMembersTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "  Sort members by:"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 18)
        return tt
    }()
    @objc func activeSortAction() {
        sortResultsActive.backgroundColor = UIColor.lightGray
        sortResultsSignUp.backgroundColor = UIColor.white
        sortResultsRandom.backgroundColor = UIColor.white
        sortMethod = "active"//"random" "active" "signUp"
    }
    @objc func signUpSortAction() {
        sortResultsActive.backgroundColor = UIColor.white
        sortResultsSignUp.backgroundColor = UIColor.lightGray
        sortResultsRandom.backgroundColor = UIColor.white
        sortMethod = "signUp"//"random" "active" "signUp"
    }
    @objc func randomSortAction() {
        sortResultsActive.backgroundColor = UIColor.white
        sortResultsSignUp.backgroundColor = UIColor.white
        sortResultsRandom.backgroundColor = UIColor.lightGray
        sortMethod = "random"//"random" "active" "signUp"
    }
    func optionsContainerSetup(){//sortResultsActiveSeperatorView sortResultsActive sortResultsSignUpSeperatorView sortResultsSignUp sortResultsRandomSeperatorView sortResultsRandom sortMembersTitle
        view.addSubview(optionsContainer)
        optionsContainer.addSubview(sortMembersTitle)
        optionsContainer.addSubview(sortResultsActiveSeperatorView)
        optionsContainer.addSubview(sortResultsActive)
        optionsContainer.addSubview(sortResultsSignUpSeperatorView)
        optionsContainer.addSubview(sortResultsSignUp)
        optionsContainer.addSubview(sortResultsRandomSeperatorView)
        optionsContainer.addSubview(sortResultsRandom)
        
        optionsContainer.rightAnchor.constraint(equalTo: welcomeTextsContainerView.rightAnchor).isActive = true
        optionsContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        optionsContainer.widthAnchor.constraint(equalToConstant: 200).isActive = true
        optionsContainer.heightAnchor.constraint(equalToConstant: 197).isActive = true
        optionsContainer.isHidden = true
        
        sortMembersTitle.topAnchor.constraint(equalTo: optionsContainer.topAnchor).isActive = true
        sortMembersTitle.centerXAnchor.constraint(equalTo: optionsContainer.centerXAnchor).isActive = true
        sortMembersTitle.widthAnchor.constraint(equalTo: optionsContainer.widthAnchor).isActive = true
        sortMembersTitle.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        sortResultsActiveSeperatorView.topAnchor.constraint(equalTo: sortMembersTitle.bottomAnchor).isActive = true
        sortResultsActiveSeperatorView.centerXAnchor.constraint(equalTo: optionsContainer.centerXAnchor).isActive = true
        sortResultsActiveSeperatorView.widthAnchor.constraint(equalTo: optionsContainer.widthAnchor).isActive = true
        sortResultsActiveSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        sortResultsActive.topAnchor.constraint(equalTo: sortResultsActiveSeperatorView.bottomAnchor).isActive = true
        sortResultsActive.centerXAnchor.constraint(equalTo: optionsContainer.centerXAnchor).isActive = true
        sortResultsActive.widthAnchor.constraint(equalTo: optionsContainer.widthAnchor).isActive = true
        sortResultsActive.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        sortResultsSignUpSeperatorView.topAnchor.constraint(equalTo: sortResultsActive.bottomAnchor).isActive = true
        sortResultsSignUpSeperatorView.centerXAnchor.constraint(equalTo: optionsContainer.centerXAnchor).isActive = true
        sortResultsSignUpSeperatorView.widthAnchor.constraint(equalTo: optionsContainer.widthAnchor).isActive = true
        sortResultsSignUpSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        sortResultsSignUp.topAnchor.constraint(equalTo: sortResultsSignUpSeperatorView.bottomAnchor).isActive = true
        sortResultsSignUp.centerXAnchor.constraint(equalTo: optionsContainer.centerXAnchor).isActive = true
        sortResultsSignUp.widthAnchor.constraint(equalTo: optionsContainer.widthAnchor).isActive = true
        sortResultsSignUp.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        sortResultsRandomSeperatorView.topAnchor.constraint(equalTo: sortResultsSignUp.bottomAnchor).isActive = true
        sortResultsRandomSeperatorView.centerXAnchor.constraint(equalTo: optionsContainer.centerXAnchor).isActive = true
        sortResultsRandomSeperatorView.widthAnchor.constraint(equalTo: optionsContainer.widthAnchor).isActive = true
        sortResultsRandomSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        sortResultsRandom.topAnchor.constraint(equalTo: sortResultsRandomSeperatorView.bottomAnchor).isActive = true
        sortResultsRandom.centerXAnchor.constraint(equalTo: optionsContainer.centerXAnchor).isActive = true
        sortResultsRandom.widthAnchor.constraint(equalTo: optionsContainer.widthAnchor).isActive = true
        sortResultsRandom.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    func textsContainerSetup(){
//        welcomeTextsContainerView.addSubview(welcomeTitle)
        welcomeTextsContainerView.addSubview(searchMembersButton)
        welcomeTextsContainerView.addSubview(allMembersButton)
        welcomeTextsContainerView.addSubview(contactsOnlyButton)
        welcomeTextsContainerView.addSubview(searchLocTextTitle)
        welcomeTextsContainerView.addSubview(searchLocTextField)
        welcomeTextsContainerView.addSubview(searchLocSeperatorView)
        welcomeTextsContainerView.addSubview(searchButton)
        
        welcomeTextsContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        welcomeTextsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeTextsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        welcomeTextsContainerView.heightAnchor.constraint(equalToConstant: 310).isActive = true
        
//        welcomeTitle.centerXAnchor.constraint(equalTo: welcomeTextsContainerView.centerXAnchor).isActive = true
//        welcomeTitle.topAnchor.constraint(equalTo: welcomeTextsContainerView.topAnchor).isActive = true
//        welcomeTitle.widthAnchor.constraint(equalToConstant: 90).isActive = true
//        welcomeTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        searchMembersButton.centerXAnchor.constraint(equalTo: welcomeTextsContainerView.centerXAnchor).isActive = true
        searchMembersButton.topAnchor.constraint(equalTo: welcomeTextsContainerView.topAnchor, constant: 60).isActive = true
        searchMembersButton.widthAnchor.constraint(equalToConstant: 290).isActive = true
        searchMembersButton.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        allMembersButton.topAnchor.constraint(equalTo: searchMembersButton.bottomAnchor, constant: 20).isActive = true
        allMembersButton.widthAnchor.constraint(equalToConstant: 147).isActive = true
        allMembersButton.rightAnchor.constraint(equalTo: welcomeTextsContainerView.centerXAnchor, constant: -1).isActive = true
        allMembersButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contactsOnlyButton.topAnchor.constraint(equalTo: allMembersButton.topAnchor).isActive = true
        contactsOnlyButton.leftAnchor.constraint(equalTo: welcomeTextsContainerView.centerXAnchor, constant: 1).isActive = true
        contactsOnlyButton.widthAnchor.constraint(equalToConstant: 147).isActive = true
        contactsOnlyButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        searchLocTextTitle.centerXAnchor.constraint(equalTo:  welcomeTextsContainerView.centerXAnchor, constant: 3).isActive = true
        searchLocTextTitle.topAnchor.constraint(equalTo: allMembersButton.bottomAnchor, constant: 15).isActive = true
        searchLocTextTitle.widthAnchor.constraint(equalToConstant: 290).isActive = true
        searchLocTextTitle.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        searchLocTextField.centerXAnchor.constraint(equalTo:  welcomeTextsContainerView.centerXAnchor, constant: 12).isActive = true
        searchLocTextField.topAnchor.constraint(equalTo: searchLocTextTitle.bottomAnchor, constant: 10).isActive = true
        searchLocTextField.widthAnchor.constraint(equalToConstant: 290).isActive = true
        searchLocTextField.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        searchLocSeperatorView.leftAnchor.constraint(equalTo:  searchLocTextField.leftAnchor, constant: -4).isActive = true
        searchLocSeperatorView.topAnchor.constraint(equalTo: searchLocTextField.topAnchor, constant: 1).isActive = true
        searchLocSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        searchLocSeperatorView.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        searchButton.centerXAnchor.constraint(equalTo: welcomeTextsContainerView.centerXAnchor).isActive = true
        searchButton.topAnchor.constraint(equalTo: searchLocTextField.topAnchor, constant: 30).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func lookingForSetupContainerView(){
        view.addSubview(lookingForContainerView)
        lookingForContainerView.addSubview(lookingForTitle)
        lookingForContainerView.addSubview(search_travelCheckboxButton)
        lookingForContainerView.addSubview(search_meetCheckboxButton)
        lookingForContainerView.addSubview(search_dateCheckboxButton)
        lookingForContainerView.addSubview(search_discoverCheckboxButton)
        
        lookingForContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lookingForContainerView.topAnchor.constraint(equalTo: welcomeTextsContainerView.bottomAnchor, constant: 10).isActive = true
        lookingForContainerView.widthAnchor.constraint(equalToConstant: 290).isActive = true
        lookingForContainerView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        
        lookingForTitle.leftAnchor.constraint(equalTo:  lookingForContainerView.leftAnchor).isActive = true
        lookingForTitle.topAnchor.constraint(equalTo: lookingForContainerView.topAnchor).isActive = true
        lookingForTitle.widthAnchor.constraint(equalTo: lookingForContainerView.widthAnchor).isActive = true
        lookingForTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        search_travelCheckboxButton.leftAnchor.constraint(equalTo: lookingForContainerView.leftAnchor).isActive = true
        search_travelCheckboxButton.topAnchor.constraint(equalTo: lookingForTitle.bottomAnchor, constant: 5).isActive = true
        search_travelCheckboxButton.widthAnchor.constraint(equalTo: lookingForContainerView.widthAnchor).isActive = true
        search_travelCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        search_travelCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: search_travelCheckboxButton.leftAnchor).isActive = true
        
        search_meetCheckboxButton.leftAnchor.constraint(equalTo: lookingForContainerView.leftAnchor).isActive = true
        search_meetCheckboxButton.topAnchor.constraint(equalTo: search_travelCheckboxButton.bottomAnchor, constant: 5).isActive = true
        search_meetCheckboxButton.widthAnchor.constraint(equalTo: lookingForContainerView.widthAnchor).isActive = true
        search_meetCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        search_meetCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: search_meetCheckboxButton.leftAnchor).isActive = true
        
        search_dateCheckboxButton.leftAnchor.constraint(equalTo: lookingForContainerView.leftAnchor).isActive = true
        search_dateCheckboxButton.topAnchor.constraint(equalTo: search_meetCheckboxButton.bottomAnchor, constant: 5).isActive = true
        search_dateCheckboxButton.widthAnchor.constraint(equalTo: lookingForContainerView.widthAnchor).isActive = true
        search_dateCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        search_dateCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: search_dateCheckboxButton.leftAnchor).isActive = true
        
        search_discoverCheckboxButton.leftAnchor.constraint(equalTo: lookingForContainerView.leftAnchor).isActive = true
        search_discoverCheckboxButton.topAnchor.constraint(equalTo: search_dateCheckboxButton.bottomAnchor, constant: 5).isActive = true
        search_discoverCheckboxButton.widthAnchor.constraint(equalTo: lookingForContainerView.widthAnchor).isActive = true
        search_discoverCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        search_discoverCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: search_dateCheckboxButton.leftAnchor).isActive = true
    }
    func optionsContainerViewSetup(){
        view.addSubview(optionsContainerView)
//        optionsContainerView.addSubview(lookingForGenderTitle)
        optionsContainerView.addSubview(femaleCheckboxButton)
        optionsContainerView.addSubview(maleCheckboxButton)
        optionsContainerView.addSubview(bothCheckboxButton)
        
        optionsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        optionsContainerView.topAnchor.constraint(equalTo: lookingForContainerView.bottomAnchor, constant: 20).isActive = true
        optionsContainerView.widthAnchor.constraint(equalToConstant: 290).isActive = true
        optionsContainerView.heightAnchor.constraint(equalToConstant: 700).isActive = true
        
//        lookingForGenderTitle.leftAnchor.constraint(equalTo:  optionsContainerView.leftAnchor).isActive = true
//        lookingForGenderTitle.topAnchor.constraint(equalTo: optionsContainerView.topAnchor).isActive = true
//        lookingForGenderTitle.widthAnchor.constraint(equalToConstant: 290).isActive = true
//        lookingForGenderTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        femaleCheckboxButton.leftAnchor.constraint(equalTo:  search_dateCheckboxButton.leftAnchor).isActive = true
        femaleCheckboxButton.topAnchor.constraint(equalTo: optionsContainerView.topAnchor).isActive = true
        femaleCheckboxButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        femaleCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        femaleCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: femaleCheckboxButton.leftAnchor).isActive = true
        
        maleCheckboxButton.leftAnchor.constraint(equalTo: femaleCheckboxButton.rightAnchor).isActive = true
        maleCheckboxButton.topAnchor.constraint(equalTo: femaleCheckboxButton.topAnchor).isActive = true
        maleCheckboxButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        maleCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        maleCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: maleCheckboxButton.leftAnchor).isActive = true
        
        bothCheckboxButton.leftAnchor.constraint(equalTo:  search_dateCheckboxButton.leftAnchor).isActive = true
        bothCheckboxButton.topAnchor.constraint(equalTo: femaleCheckboxButton.bottomAnchor, constant: 5).isActive = true
        bothCheckboxButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        bothCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bothCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: bothCheckboxButton.leftAnchor).isActive = true
    }
    func setupPopup(){
        view.addSubview(popup)
        popup.addSubview(lookingForGenderTitle)
        popup.addSubview(femaleCheckboxButton)
        popup.addSubview(maleCheckboxButton)
        popup.addSubview(bothCheckboxButton)
        popup.addSubview(popupOkButton)
        
        popup.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popup.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popup.heightAnchor.constraint(equalToConstant: 350).isActive = true
        popup.widthAnchor.constraint(equalToConstant: 210).isActive = true
        
        lookingForGenderTitle.centerXAnchor.constraint(equalTo:  popup.centerXAnchor).isActive = true
        lookingForGenderTitle.topAnchor.constraint(equalTo: popup.topAnchor, constant: 20).isActive = true
        lookingForGenderTitle.widthAnchor.constraint(equalToConstant: 120).isActive = true
        lookingForGenderTitle.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        femaleCheckboxButton.centerXAnchor.constraint(equalTo: popup.centerXAnchor).isActive = true
        femaleCheckboxButton.topAnchor.constraint(equalTo: lookingForGenderTitle.bottomAnchor, constant: 25).isActive = true
        femaleCheckboxButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        femaleCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        femaleCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: femaleCheckboxButton.leftAnchor).isActive = true
        
        maleCheckboxButton.centerXAnchor.constraint(equalTo: popup.centerXAnchor).isActive = true
        maleCheckboxButton.topAnchor.constraint(equalTo: femaleCheckboxButton.bottomAnchor, constant: 25).isActive = true
        maleCheckboxButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        maleCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        maleCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: maleCheckboxButton.leftAnchor).isActive = true
        
        bothCheckboxButton.centerXAnchor.constraint(equalTo: popup.centerXAnchor).isActive = true
        bothCheckboxButton.topAnchor.constraint(equalTo: maleCheckboxButton.bottomAnchor, constant: 25).isActive = true
        bothCheckboxButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        bothCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bothCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: bothCheckboxButton.leftAnchor).isActive = true
        
        popupOkButton.centerXAnchor.constraint(equalTo: popup.centerXAnchor).isActive = true
        popupOkButton.topAnchor.constraint(equalTo: bothCheckboxButton.bottomAnchor, constant: 25).isActive = true
        popupOkButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        popupOkButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        popup.isHidden = true
    }
    func optionsContainerOrPopupSelection(){
        let screenHeight = Int(view.frame.height)
        if screenHeight < 666 {
            setupPopup()
        } else {
            optionsContainerViewSetup()
        }
    }
    @objc func wayToSearching(){
        let screenHeight = Int(view.frame.height)
        var phone = String()
        if screenHeight < 666 {
            phone = "old"
        } else {
            phone = "new"
        }
        checkIfAnyChecked(phone: phone)
    }
    @objc func goAC(){
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .region
        acController.autocompleteFilter = filter
        present(acController, animated: true, completion: nil)
    }
    @objc func goACSM(){
        whatFieldSM = "SM"
        goAC()
    }
    @objc func goACN(){
        whatFieldSM = "NORMAL"
        goAC()
    }
}
var whatFieldSM = "" //"SM", "NORMAL"
extension SearchController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if whatFieldSM == "SM"{
            smSearchLocTextField.text = place.formattedAddress
        } else {
            searchLocTextField.text = place.formattedAddress
        }
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        if error != nil {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
//extension UITextField {
//    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        return false
//    }
//}
