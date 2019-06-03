//
//  SwipingSRController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 26.09.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
var goToControllerByMemberUid: String?
class SwipingSRControllet: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var youAreBanned = false
    var localFL = [searchResult]()
    let label: UITextField = {
        let label = UITextField()
        label.text = "No search results"
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = CustomColors.commonGrey1
        label.isUserInteractionEnabled = false
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.dataSource = self
        checkIfYouAreBanned()
        collectionView?.backgroundColor = CustomColors.lightBlue1
        collectionView?.register(ResultsPageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.isPagingEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(srReloadData), name: NSNotification.Name(rawValue: "newSignin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(srReloadData), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLocalFL(_:)), name: NSNotification.Name(rawValue: "sendLocalFL"), object: nil)
        setupLabel()
        
    }
    @objc func setLocalFL(_ notification: NSNotification){
        localFL = (notification.userInfo?["dict"] as? [searchResult])!
//        setupLabel()
        hideLabel()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return friendslineArray.count
//        return friendsLine.count
        return localFL.count
    }
    var some: String!
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("NEXT PAGE")
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ResultsPageCell
//        let theIndex = indexPath.item
//        print("theIndex", theIndex, "indexPath", indexPath)
//        let arrayIndexPathItem = friendslineArray[theIndex] as AnyObject
//        let input_meetChecked = arrayIndexPathItem.value(forKey: "meetChecked") as? Bool
//        let input_dateChecked = arrayIndexPathItem.value(forKey: "dateChecked") as? Bool
//        let input_occupation = arrayIndexPathItem.value(forKey: "occupation") as? String
//        let input_acceptingGuests = arrayIndexPathItem.value(forKey: "acceptingGuests") as? String
//        let input_home = arrayIndexPathItem.value(forKey: "loc") as? String
//        //        let input_CurrentLoc = arrayIndexPathItem.value(forKey: "currentLoc") as? AnyObject
//        //        print("arrayIndexPathItem: \(arrayIndexPathItem)")
//        let input_name = arrayIndexPathItem.value(forKey: "name") as? String
//        let profileImageUrl = arrayIndexPathItem.value(forKey: "profileImageUrl") as? String
//        let input_age = arrayIndexPathItem.value(forKey: "age") as? String
//        let input_nameAndAge = input_name! + " " + input_age!
//        let nameLen = input_name?.count
//        let ageLen = input_age?.count
//        let nameAgeLen = input_nameAndAge.count
//        let range = NSRange(location: 0, length: nameAgeLen)
//        let attributedStr = NSMutableAttributedString.init(string: input_nameAndAge)
//        attributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 22), range: range)
//        attributedStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 22), range: NSRange(location: nameLen! + 1, length: ageLen!))
//        attributedStr.addAttribute(.foregroundColor, value: CustomColors.commonGrey1, range: range)
//        cell.addToWishlistButton.isHidden = true
//        if input_occupation?.count == 0 {
//            cell.occupationText.heightAnchor.constraint(equalToConstant: 0).isActive = true
//        }
//        if input_meetChecked == true {
//            cell.meetingUpTextView.text = "Meeting up"
//            cell.meetingUpTextView.heightAnchor.constraint(equalToConstant: 32).isActive = true
//        } //else {
//        //            cell.meetingUpTextView.heightAnchor.constraint(equalToConstant: 0).isActive = true
//        //        }
//        if input_dateChecked == true {
//            cell.datingTextView.text = "Dating"
//        } else {
//            cell.datingTextView.isHidden = true
//        }
//        if input_acceptingGuests == "maybe"{
//            cell.accepingGuestsTextView.text = "Maybe accepting guests"
//            cell.accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 32).isActive = true
//        } else if input_acceptingGuests == "yes"{
//            cell.accepingGuestsTextView.text = "Accepting guests"
//            cell.accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 32) .isActive = true
//        } //else {
//        //            cell.accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 0).isActive = true
//        //        }
//        if profileImageUrl == "empty" {
//            cell.profileAvatarView.image = UIImage(named: "emptyavatar")
//        } else if profileImageUrl == "deleted" {
//            cell.profileAvatarView.image = UIImage(named: "deletedprofile")
//        } else {
//            cell.profileAvatarView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
//        }
//        //        print("1input_CurrentLoc: \(input_CurrentLoc)")
//
//        //        cell.currentLocationView.heightAnchor.constraint(equalToConstant: 32) .isActive = true
//        if let input_CurrentLoc = arrayIndexPathItem.value(forKey: "currentLoc") {
//            if (input_CurrentLoc as! String).count > 0 {
//                print("2input_CurrentLoc: \(input_CurrentLoc)")
//                cell.currentLocationView.text = "Current location: " + (input_CurrentLoc as! String)
//                cell.currentLocationView.heightAnchor.constraint(equalToConstant: 32).isActive = true
//            } //else {
//            //                cell.currentLocationView.heightAnchor.constraint(equalToConstant: 0).isActive = true
//            //            }
//        }// else {
//        //            cell.currentLocationView.heightAnchor.constraint(equalToConstant: 0).isActive = true
//        //        }
//        print("curLoc height: ", cell.currentLocationView.frame.height)
//        //        cell.profileAvatarView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
//        //        cell.memberNameButton.setTitle(input_nameAndAge, for: .normal)
//        cell.memberNameButton.setAttributedTitle(attributedStr, for: .normal)
//        cell.memberNameButton.tag = theIndex
//        cell.homeLocationView.text = "Home location: " + input_home!
//        cell.occupationText.text = input_occupation
//        cell.contactButton.tag = theIndex
//        cell.goToProfileButton.tag = theIndex
//        cell.addToWishlistButton.tag = theIndex
//        cell.profileAvatarView.tag = theIndex
//        cell.profileAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SwipingSRControllet.avGoToProfile)))
//        checkIfYouAreBanned()
//        return cell
//    }
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        //IT IS WORKING\
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ResultsPageCell
//        let arrayIndexPathItem = friendslineArray[indexPath.item] as AnyObject
//        let input_meetChecked = arrayIndexPathItem.value(forKey: "meetChecked") as? Bool
//        let input_dateChecked = arrayIndexPathItem.value(forKey: "dateChecked") as? Bool
//        let input_occupation = arrayIndexPathItem.value(forKey: "occupation") as? String
//        let input_acceptingGuests = arrayIndexPathItem.value(forKey: "acceptingGuests") as? String
//        let input_home = arrayIndexPathItem.value(forKey: "loc") as? String
////        let input_CurrentLoc = arrayIndexPathItem.value(forKey: "currentLoc") as? AnyObject
////        print("arrayIndexPathItem: \(arrayIndexPathItem)")
//        let input_name = arrayIndexPathItem.value(forKey: "name") as? String
//        let profileImageUrl = arrayIndexPathItem.value(forKey: "profileImageUrl") as? String
//        let input_age = arrayIndexPathItem.value(forKey: "age") as? String
//        let input_nameAndAge = input_name! + " " + input_age!
//        let nameLen = input_name?.count
//        let ageLen = input_age?.count
//        let nameAgeLen = input_nameAndAge.count
//        let range = NSRange(location: 0, length: nameAgeLen)
//        let attributedStr = NSMutableAttributedString.init(string: input_nameAndAge)
//        attributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 22), range: range)
//        attributedStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 22), range: NSRange(location: nameLen! + 1, length: ageLen!))
//        attributedStr.addAttribute(.foregroundColor, value: CustomColors.commonGrey1, range: range)
//        cell.addToWishlistButton.isHidden = true
//        if input_occupation?.count == 0 {
//            cell.occupationText.heightAnchor.constraint(equalToConstant: 0).isActive = true
//        }
//        if input_meetChecked == true {
//            cell.meetingUpTextView.text = "Meeting up"
//            cell.meetingUpTextView.heightAnchor.constraint(equalToConstant: 32).isActive = true
//        } //else {
////            cell.meetingUpTextView.heightAnchor.constraint(equalToConstant: 0).isActive = true
////        }
//        if input_dateChecked == true {
//            cell.datingTextView.text = "Dating"
//        } else {
//            cell.datingTextView.isHidden = true
//        }
//        if input_acceptingGuests == "maybe"{
//            cell.accepingGuestsTextView.text = "Maybe accepting guests"
//            cell.accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 32).isActive = true
//        } else if input_acceptingGuests == "yes"{
//            cell.accepingGuestsTextView.text = "Accepting guests"
//            cell.accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 32) .isActive = true
//        } //else {
////            cell.accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 0).isActive = true
////        }
//        if profileImageUrl == "empty" {
//            cell.profileAvatarView.image = UIImage(named: "emptyavatar")
//        } else if profileImageUrl == "deleted" {
//            cell.profileAvatarView.image = UIImage(named: "deletedprofile")
//        } else {
//            cell.profileAvatarView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
//        }
////        print("1input_CurrentLoc: \(input_CurrentLoc)")
//
////        cell.currentLocationView.heightAnchor.constraint(equalToConstant: 32) .isActive = true
//        if let input_CurrentLoc = arrayIndexPathItem.value(forKey: "currentLoc") {
//            if (input_CurrentLoc as! String).count > 0 {
//                print("2input_CurrentLoc: \(input_CurrentLoc)")
//                cell.currentLocationView.text = "Current location: " + (input_CurrentLoc as! String)
//                cell.currentLocationView.heightAnchor.constraint(equalToConstant: 32).isActive = true
//            } //else {
////                cell.currentLocationView.heightAnchor.constraint(equalToConstant: 0).isActive = true
////            }
//        }// else {
////            cell.currentLocationView.heightAnchor.constraint(equalToConstant: 0).isActive = true
////        }
//        print("curLoc height: ", cell.currentLocationView.frame.height)
////        cell.profileAvatarView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
////        cell.memberNameButton.setTitle(input_nameAndAge, for: .normal)
//        cell.memberNameButton.setAttributedTitle(attributedStr, for: .normal)
//        cell.memberNameButton.tag = indexPath.item
//        cell.homeLocationView.text = "Home location: " + input_home!
//        cell.occupationText.text = input_occupation
//        cell.contactButton.tag = indexPath.item
//        cell.goToProfileButton.tag = indexPath.item
//        cell.addToWishlistButton.tag = indexPath.item
//        cell.profileAvatarView.tag = indexPath.item
//        cell.profileAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SwipingSRControllet.avGoToProfile)))
////        cell.theItem = indexPath.item
////        print("indexPath.item: ", indexPath.item)
////        checkIfYouAreBanned()
////        cell.setData()
//        print("friendslineArray: ", friendslineArray.count)
//        return cell
//    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ResultsPageCell
//        var arrayIndexPathItem = friendsLine[indexPath.item] as AnyObject
        var arrayIndexPathItem = localFL[indexPath.item] as AnyObject
        cell.number = indexPath.item
        cell.profileAvatarView.tag = indexPath.item
//        cell.profileAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SwipingSRControllet.avGoToProfile(_:))))
        cell.theItem = arrayIndexPathItem as! searchResult
        return cell
    }
    @objc func addToWishlist(_ sender: UIButton){
//        let memberUid = (friendslineArray[sender.tag] as AnyObject).value(forKey: "userId") as! String
//        let memberUid = (friendsLine[sender.tag]).userId
        let memberUid = (self.localFL[sender.tag]).userId
//        let addItToWishlistByUid = memberUid
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference(fromURL: "https://myfriendsroomtest.firebaseio.com/")
        let usersReference = ref.child("users-wishlists").child(uid)
        usersReference.updateChildValues([memberUid!: 1])
    }
    @objc func contactMember(_ sender: UIButton){
//        let memberUid = (friendslineArray[sender.tag] as AnyObject).value(forKey: "userId") as! String
//        let memberUid = (friendsLine[sender.tag]).userId
        let memberUid = (self.localFL[sender.tag]).userId
        goToControllerByMemberUid = memberUid
        let contactMemberController = ContactMemberController()
        let contactMemberNav = UINavigationController(rootViewController: contactMemberController)
        self.present(contactMemberNav, animated: true, completion: nil)
    }
    
    @objc func avGoToProfile(_ sender: UITapGestureRecognizer){
        print("tap")
//        let memberUid = (friendslineArray[sender.tag] as AnyObject).value(forKey: "userId") as! String
//        goToControllerByMemberUid = memberUid
//        let memberProfileController = MemberProfileController()
//        let memberProfileNav = UINavigationController(rootViewController: memberProfileController)
//        self.present(memberProfileNav, animated: true, completion: nil)
        if let image = sender.view as? UIImageView {
            let imageTag = image.tag
            print(imageTag)
//            let memberUid = (friendslineArray[imageTag] as AnyObject).value(forKey: "userId") as! String
//            let memberUid = (friendsLine[imageTag]).userId
            let memberUid = (self.localFL[imageTag]).userId
            goToControllerByMemberUid = memberUid
            print(goToControllerByMemberUid)
            let memberProfileController = MemberProfileController()
            let memberProfileNav = UINavigationController(rootViewController: memberProfileController)
            self.present(memberProfileNav, animated: true, completion: nil)
        }
    }
    @objc func goToProfile(_ sender: UIButton){
//        let memberUid = (friendslineArray[sender.tag] as AnyObject).value(forKey: "userId") as! String
//        let memberUid = (friendsLine[sender.tag]).userId
        let memberUid = (self.localFL[sender.tag]).userId
        print("TAG`: ", self.localFL, ", SNGL: ", self.localFL[sender.tag], "MMBRID: ", (self.localFL[sender.tag]).name)
        goToControllerByMemberUid = memberUid
        let memberProfileController = MemberProfileController()
        let memberProfileNav = UINavigationController(rootViewController: memberProfileController)
        self.present(memberProfileNav, animated: true, completion: nil)
    }
    @objc func srReloadData(){
//        localFL = friendsLine
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView?.reloadData()
        hideLabel()
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
    func hideLabel(){
//        if friendslineArray.count != 0 {
//        if friendsLine.count != 0 {
        if localFL.count != 0 {
            label.isHidden = true
        } else {
            label.isHidden = false
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    func setupLabel(){
        view.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.widthAnchor.constraint(equalToConstant: 170).isActive = true
        hideLabel()
    }
}
