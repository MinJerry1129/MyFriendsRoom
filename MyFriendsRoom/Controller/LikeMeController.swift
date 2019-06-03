//
//  LikeMeController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 18.12.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
import Alamofire


class LikeMeController: UITableViewController {
    var youAreBanned = false
    
    let ref = Database.database().reference(fromURL: "https://myfriendsroomtest.firebaseio.com/")
    //    var addButtonsExclusions = [String]()
    var likeMeArray: Array = Array<Any>()
    let cellId = "cellId"
    
    @objc func reloadWishlist(){
        takeWisglist()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfYouAreBanned()
        takeWisglist()
        setupNavBarItems()
        tableView.register(LikeMeCell.self, forCellReuseIdentifier: cellId)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWishlist), name: NSNotification.Name(rawValue: "newSignin"), object: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likeMeArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! LikeMeCell
        cell.textLabel?.textColor = CustomColors.commonGrey1
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        let arrayIndexPathItem = likeMeArray[indexPath.row] as AnyObject
        let input_name = arrayIndexPathItem.value(forKey: "name") as? String
        let profileImageUrl = arrayIndexPathItem.value(forKey: "profileImageUrl") as? String
        let memberId = arrayIndexPathItem.value(forKey: "userId") as? String
        cell.textLabel?.text = input_name
        
        if profileImageUrl == "empty" {
            cell.profileImageView.image = UIImage(named: "emptyavatar")
        } else if profileImageUrl == "deleted" {
            cell.profileImageView.image = UIImage(named: "deletedprofile")
        } else {
            cell.profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
        }
        cell.viewButton.tag = indexPath.row
        return cell
    }
    func takeWisglist() {
        print("take wish func")
        likeMeArray = []
        let uid = Auth.auth().currentUser!.uid
        let wishList = Database.database().reference().child("users-likes").child(uid)
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
                self.likeMeArray.append(singleUserArray)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        })
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
        myImagesURLSArray = [String]()
        self.dismiss(animated: true, completion: nil)
    }
    func setupNavBarItems(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.lightOrange1]
        self.navigationItem.title = "People who like me"
        let backImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
    }
    @objc func viewProfile(_ sender: UIButton){
        checkIfYouAreBanned()
        let memberUid = (likeMeArray[sender.tag] as AnyObject).value(forKey: "userId") as! String
        goToControllerByMemberUid = memberUid
        let memberProfileController = MemberProfileController()
        let memberProfileNav = UINavigationController(rootViewController: memberProfileController)
        self.present(memberProfileNav, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
