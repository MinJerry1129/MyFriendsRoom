//
//  ContactsController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 08.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import MessageUI
import Firebase
class ContactsController: UIViewController, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, FBSDKAppInviteDialogDelegate {
    var youAreBanned = false
    var friendsCount = Int()
    var contactsCount = Int()
    var requestsReceivedCount = Int()
    var requestsSentCount = Int()
    var blacklistCount = Int()
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        let resultObject = NSDictionary(dictionary: results)
        if let didCancel = resultObject.value(forKey: "completionGesture"){
            if (didCancel as AnyObject).caseInsensitiveCompare("Cancel") == ComparisonResult.orderedSame{
                print("User Canceled invitation dialog")
            }
        }
    }
    func itemsCounter() {
        print("contacts")
        contactsCount = yourFriendsOfFriendsArray.count
        let uid = Auth.auth().currentUser?.uid
        let friendList = Database.database().reference().child("users-friends").child(uid!)
        friendList.observeSingleEvent(of: .value, with: { (snapshot) in
            let items = snapshot.children.allObjects
            self.friendsCount = items.count
            setBadges()
            print("contacts1")
        })
        let requestsReceived = Database.database().reference().child("users-friends-proposals").child(uid!).child("received")
        requestsReceived.observeSingleEvent(of: .value, with: { (snapshot) in
            let items = snapshot.children.allObjects
            self.requestsReceivedCount = items.count
            setBadges()
            print("contacts2")
        })
        let requestsSent = Database.database().reference().child("users-friends-proposals").child(uid!).child("sent-to")
        requestsSent.observeSingleEvent(of: .value, with: { (snapshot) in
            let items = snapshot.children.allObjects
            self.requestsSentCount = items.count
            setBadges()
            print("contacts3")
        })
        let blackList = Database.database().reference().child("users-blacklists").child(uid!)
        blackList.observeSingleEvent(of: .value, with: { (snapshot) in
            let items = snapshot.children.allObjects
            self.blacklistCount = items.count
            setBadges()
            print("contacts4")
        })
        func setBadges() {
            print("contactsCount: ", contactsCount, ", friendsCount: ", friendsCount, ", requestsReceivedCount: ", requestsReceivedCount, ", requestsSentCount: ", requestsSentCount, ", blacklistCount: ", blacklistCount)
            if friendsCount != 0 {
                friendsBadge.text = String(friendsCount)
            }
            if contactsCount != 0 {
                contactsBadge.text = String(contactsCount)
            }
            if requestsReceivedCount != 0 {
                requestsReceivedBadge.text = String(requestsReceivedCount)
            }
            if requestsSentCount != 0 {
                requestsSentBadge.text = String(requestsSentCount)
            }
            if blacklistCount != 0 {
                blacklistBadge.text = String(blacklistCount)
            }
            
        }
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
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        print("Error tool place in appInviteDialog \(error)")
    }
    let friendsBadge: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = CustomColors.commonBlue1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let contactsBadge: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = CustomColors.commonBlue1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let requestsReceivedBadge: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = CustomColors.commonBlue1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let requestsSentBadge: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = CustomColors.commonBlue1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let blacklistBadge: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = CustomColors.commonBlue1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor.white
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.layer.masksToBounds = true
        return sv
    }()
    let contactsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let contactsTitle: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.lightOrange1
        tt.text = "Contacts"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 25)
        return tt
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
    let friendsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Friends only", for: .normal)
        button.setFATitleColor(color: CustomColors.commonGrey1)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(goFriends), for: .touchUpInside)
        return button
    }()
    let friendsOfFriendsButtont: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("All contacts", for: .normal)
        button.setFATitleColor(color: CustomColors.commonGrey1)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(goFriendsOfFriends), for: .touchUpInside)
        return button
    }()
    let friendsProposalsReceivedButtont: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Friend requests", for: .normal)
        button.setFATitleColor(color: CustomColors.commonGrey1)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(goFriendsProposalsReceived), for: .touchUpInside)
        return button
    }()
    let friendsProposalsSentButtont: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Requests sent", for: .normal)
        button.setFATitleColor(color: CustomColors.commonGrey1)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(goFriendsProposalsSent), for: .touchUpInside)
        return button
    }()
    let blacklistButtont: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Blacklist", for: .normal)
        button.setFATitleColor(color: CustomColors.commonGrey1)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(goBlacklist), for: .touchUpInside)
        return button
    }()
    let friendsButtonIcon: UIImageView = {
        let bi = UIImageView()
        bi.image = UIImage(named: "arrow-right")
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.layer.masksToBounds = true
        bi.contentMode = .scaleAspectFill
        return bi
    }()
    let fofButtonIcon: UIImageView = {
        let bi = UIImageView()
        bi.image = UIImage(named: "arrow-right")
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.layer.masksToBounds = true
        bi.contentMode = .scaleAspectFill
        return bi
    }()
    let proposalsReceivedButtonIcon: UIImageView = {
        let bi = UIImageView()
        bi.image = UIImage(named: "arrow-right")
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.layer.masksToBounds = true
        bi.contentMode = .scaleAspectFill
        return bi
    }()
    let proposalsSentButtonIcon: UIImageView = {
        let bi = UIImageView()
        bi.image = UIImage(named: "arrow-right")
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.layer.masksToBounds = true
        bi.contentMode = .scaleAspectFill
        return bi
    }()
    let blacklistButtonIcon: UIImageView = {
        let bi = UIImageView()
        bi.image = UIImage(named: "arrow-right")
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.layer.masksToBounds = true
        bi.contentMode = .scaleAspectFill
        return bi
    }()
    let inviteFriendsTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Invite friends from"
        tt.font = UIFont.systemFont(ofSize: 20)
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    var facebookButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = CustomColors.facebookColor
        button.setTitle("Facebook messenger", for: [])
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textColor = UIColor.white
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(inviteFacebookFriends), for: .touchUpInside)
        return button
    }()
    var whatsappButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = CustomColors.whatsappColor
        button.setTitle("Whatsapp", for: [])
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textColor = UIColor.white
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(inviteWhatsappFriends), for: .touchUpInside)
        return button
    }()
    var smsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = CustomColors.commonGrey1
        button.setTitle("Phone contacts", for: [])
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textColor = UIColor.white
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(inviteSmsFriends), for: .touchUpInside)
        return button
    }()
    @objc func inviteFacebookFriends(){
        let linkContent = FBSDKShareLinkContent()
        linkContent.quote = "Hey! Be my friend on this great new travel app."
        linkContent.contentURL = URL(string: "https://itunes.apple.com/app/id1439459277")
        
        let dialog = FBSDKMessageDialog()
        dialog.shareContent = linkContent
        dialog.shouldFailOnDataError = true
        
        if dialog.canShow() {
            dialog.show()
        }
    }
    @objc func inviteWhatsappFriends(){
        let msg = "Hey! Be my friend on this great new travel app.\nhttps://itunes.apple.com/app/id1439459277"
        let urlWhats = "whatsapp://send?text=\(msg)"
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.openURL(whatsappURL as URL)
                } else {
                    print("please install watsapp")
                }
            }
        }
    }
    @objc func inviteSmsFriends(){
        print("inviteSmsFriends")
        if MFMessageComposeViewController.canSendText() {
            let text = "Hey! Be my friend on this great new travel app.\nhttps://itunes.apple.com/app/id1439459277"
            let messageComposeViewController = MFMessageComposeViewController()
            messageComposeViewController.body = text
            messageComposeViewController.messageComposeDelegate = self
            present(messageComposeViewController, animated: true, completion: nil)
            
            print("canSendText")
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print("DISMISING")
        controller.dismiss(animated: true, completion: nil)
    }
//    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
//        print("wasa")
//        switch (result.rawValue) {
//        case MessageComposeResult.cancelled.rawValue:
//            print("Message was cancelled")
//            controller.dismiss(animated: true, completion: nil)
//        case MessageComposeResult.failed.rawValue:
//            print("Message failed")
//            controller.dismiss(animated: true, completion: nil)
//        case MessageComposeResult.sent.rawValue:
//            print("Message was sent")
//            controller.dismiss(animated: true, completion: nil)
//        default:
//            break;
//        }
//    }
    func setupPhotosContainerView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contactsContainerView)
        contactsContainerView.addSubview(friendsButton)
        contactsContainerView.addSubview(friendsBadge)
        contactsContainerView.addSubview(friendsButtonIcon)
        contactsContainerView.addSubview(friendsOfFriendsButtont)
        contactsContainerView.addSubview(contactsBadge)
        contactsContainerView.addSubview(fofButtonIcon)
        contactsContainerView.addSubview(friendsProposalsReceivedButtont)
        contactsContainerView.addSubview(requestsReceivedBadge)
        contactsContainerView.addSubview(proposalsReceivedButtonIcon)
        contactsContainerView.addSubview(friendsProposalsSentButtont)//friendsBadge contactsBadge requestsReceivedBadge requestsSentBadge blacklistBadge
        contactsContainerView.addSubview(requestsSentBadge)
        contactsContainerView.addSubview(proposalsSentButtonIcon)
        contactsContainerView.addSubview(blacklistButtont)
        contactsContainerView.addSubview(blacklistBadge)
        contactsContainerView.addSubview(blacklistButtonIcon)
        contactsContainerView.addSubview(inviteFriendsTitle)
        contactsContainerView.addSubview(facebookButton)
        contactsContainerView.addSubview(whatsappButton)
        contactsContainerView.addSubview(smsButton)
        
        
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -64).isActive = true
        
        contactsContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contactsContainerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        contactsContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//        contactsContainerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        contactsContainerView.heightAnchor.constraint(equalToConstant: 568).isActive = true
        contactsContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    
        friendsButton.leftAnchor.constraint(equalTo: contactsContainerView.leftAnchor).isActive = true
        friendsButton.topAnchor.constraint(equalTo: contactsContainerView.topAnchor).isActive = true
        friendsButton.widthAnchor.constraint(equalTo: contactsContainerView.widthAnchor).isActive = true
        friendsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        friendsButton.titleLabel?.leftAnchor.constraint(equalTo: friendsButton.leftAnchor, constant: 60).isActive = true
        
        friendsBadge.rightAnchor.constraint(equalTo: friendsButtonIcon.leftAnchor).isActive = true//
        friendsBadge.centerYAnchor.constraint(equalTo: friendsButtonIcon.centerYAnchor).isActive = true
        friendsBadge.widthAnchor.constraint(equalToConstant: 60).isActive = true
        friendsBadge.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        friendsButtonIcon.rightAnchor.constraint(equalTo: whatsappButton.rightAnchor).isActive = true
        friendsButtonIcon.centerYAnchor.constraint(equalTo: (friendsButton.titleLabel?.centerYAnchor)!).isActive = true
        friendsButtonIcon.widthAnchor.constraint(equalToConstant: 10).isActive = true
        friendsButtonIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        friendsOfFriendsButtont.leftAnchor.constraint(equalTo: contactsContainerView.leftAnchor).isActive = true
        friendsOfFriendsButtont.topAnchor.constraint(equalTo: friendsButton.bottomAnchor).isActive = true
        friendsOfFriendsButtont.widthAnchor.constraint(equalTo: contactsContainerView.widthAnchor).isActive = true
        friendsOfFriendsButtont.heightAnchor.constraint(equalToConstant: 60).isActive = true
        friendsOfFriendsButtont.titleLabel?.leftAnchor.constraint(equalTo: friendsOfFriendsButtont.leftAnchor, constant: 60).isActive = true
        
        contactsBadge.rightAnchor.constraint(equalTo: fofButtonIcon.leftAnchor).isActive = true//
        contactsBadge.centerYAnchor.constraint(equalTo: fofButtonIcon.centerYAnchor).isActive = true
        contactsBadge.widthAnchor.constraint(equalToConstant: 60).isActive = true
        contactsBadge.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        fofButtonIcon.rightAnchor.constraint(equalTo: whatsappButton.rightAnchor).isActive = true
        fofButtonIcon.centerYAnchor.constraint(equalTo: (friendsOfFriendsButtont.titleLabel?.centerYAnchor)!).isActive = true
        fofButtonIcon.widthAnchor.constraint(equalToConstant: 10).isActive = true
        fofButtonIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        friendsProposalsReceivedButtont.leftAnchor.constraint(equalTo: contactsContainerView.leftAnchor).isActive = true
        friendsProposalsReceivedButtont.topAnchor.constraint(equalTo: friendsOfFriendsButtont.bottomAnchor).isActive = true
        friendsProposalsReceivedButtont.widthAnchor.constraint(equalTo: contactsContainerView.widthAnchor).isActive = true
        friendsProposalsReceivedButtont.heightAnchor.constraint(equalToConstant: 60).isActive = true
        friendsProposalsReceivedButtont.titleLabel?.leftAnchor.constraint(equalTo: friendsProposalsReceivedButtont.leftAnchor, constant: 60).isActive = true
        
        requestsReceivedBadge.rightAnchor.constraint(equalTo: proposalsReceivedButtonIcon.leftAnchor).isActive = true//
        requestsReceivedBadge.centerYAnchor.constraint(equalTo: proposalsReceivedButtonIcon.centerYAnchor).isActive = true
        requestsReceivedBadge.widthAnchor.constraint(equalToConstant: 60).isActive = true
        requestsReceivedBadge.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        proposalsReceivedButtonIcon.rightAnchor.constraint(equalTo: whatsappButton.rightAnchor).isActive = true
        proposalsReceivedButtonIcon.centerYAnchor.constraint(equalTo: (friendsProposalsReceivedButtont.titleLabel?.centerYAnchor)!).isActive = true
        proposalsReceivedButtonIcon.widthAnchor.constraint(equalToConstant: 10).isActive = true
        proposalsReceivedButtonIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        friendsProposalsSentButtont.leftAnchor.constraint(equalTo: contactsContainerView.leftAnchor).isActive = true
        friendsProposalsSentButtont.topAnchor.constraint(equalTo: friendsProposalsReceivedButtont.bottomAnchor).isActive = true
        friendsProposalsSentButtont.widthAnchor.constraint(equalTo: contactsContainerView.widthAnchor).isActive = true
        friendsProposalsSentButtont.heightAnchor.constraint(equalToConstant: 60).isActive = true
        friendsProposalsSentButtont.titleLabel?.leftAnchor.constraint(equalTo: friendsProposalsSentButtont.leftAnchor, constant: 60).isActive = true
        
        requestsSentBadge.rightAnchor.constraint(equalTo: proposalsSentButtonIcon.leftAnchor).isActive = true//
        requestsSentBadge.centerYAnchor.constraint(equalTo: proposalsSentButtonIcon.centerYAnchor).isActive = true
        requestsSentBadge.widthAnchor.constraint(equalToConstant: 60).isActive = true
        requestsSentBadge.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        proposalsSentButtonIcon.rightAnchor.constraint(equalTo: whatsappButton.rightAnchor).isActive = true
        proposalsSentButtonIcon.centerYAnchor.constraint(equalTo: (friendsProposalsSentButtont.titleLabel?.centerYAnchor)!).isActive = true
        proposalsSentButtonIcon.widthAnchor.constraint(equalToConstant: 10).isActive = true
        proposalsSentButtonIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        blacklistButtont.leftAnchor.constraint(equalTo: contactsContainerView.leftAnchor).isActive = true
        blacklistButtont.topAnchor.constraint(equalTo: friendsProposalsSentButtont.bottomAnchor).isActive = true
        blacklistButtont.widthAnchor.constraint(equalTo: contactsContainerView.widthAnchor).isActive = true
        blacklistButtont.heightAnchor.constraint(equalToConstant: 60).isActive = true
        blacklistButtont.titleLabel?.leftAnchor.constraint(equalTo: friendsProposalsSentButtont.leftAnchor, constant: 60).isActive = true
        
        blacklistBadge.rightAnchor.constraint(equalTo: blacklistButtonIcon.leftAnchor).isActive = true//
        blacklistBadge.centerYAnchor.constraint(equalTo: blacklistButtonIcon.centerYAnchor).isActive = true
        blacklistBadge.widthAnchor.constraint(equalToConstant: 60).isActive = true
        blacklistBadge.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        blacklistButtonIcon.rightAnchor.constraint(equalTo: whatsappButton.rightAnchor).isActive = true
        blacklistButtonIcon.centerYAnchor.constraint(equalTo: (blacklistButtont.titleLabel?.centerYAnchor)!).isActive = true
        blacklistButtonIcon.widthAnchor.constraint(equalToConstant: 10).isActive = true
        blacklistButtonIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        inviteFriendsTitle.topAnchor.constraint(equalTo: blacklistButtont.bottomAnchor, constant: 20).isActive = true
        inviteFriendsTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20).isActive = true
        inviteFriendsTitle.widthAnchor.constraint(equalToConstant: 290).isActive = true
        inviteFriendsTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        whatsappButton.topAnchor.constraint(equalTo: inviteFriendsTitle.bottomAnchor, constant: 10).isActive = true
        whatsappButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        whatsappButton.widthAnchor.constraint(equalTo: inviteFriendsTitle.widthAnchor).isActive = true
        whatsappButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        facebookButton.topAnchor.constraint(equalTo: whatsappButton.bottomAnchor, constant: 10).isActive = true
        facebookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookButton.widthAnchor.constraint(equalTo: whatsappButton.widthAnchor).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        smsButton.topAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: 10).isActive = true
        smsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        smsButton.widthAnchor.constraint(equalTo: facebookButton.widthAnchor).isActive = true
        smsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    func setupNavBarItems(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.lightOrange1]
        let backImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "Contacts"
    }
    @objc func goFriends() {
        checkIfYouAreBanned()
        let friendsController = FriendsController()
        friendsController.contactsController = self
        let friendsNav = UINavigationController(rootViewController: friendsController)
        self.present(friendsNav, animated: true, completion: nil)
    }
    @objc func goFriendsOfFriends() {
        checkIfYouAreBanned()
        let allContactsController = AllContactsController()
        allContactsController.contactsController = self
        let allContactsNav = UINavigationController(rootViewController: allContactsController)
        self.present(allContactsNav, animated: true, completion: nil)
    }
    @objc func goFriendsProposalsReceived() {
        checkIfYouAreBanned()
        let proposalsReceivedController = ProposalsReceivedController()
        proposalsReceivedController.contactsController = self
        let proposalsReceivedNav = UINavigationController(rootViewController: proposalsReceivedController)
        self.present(proposalsReceivedNav, animated: true, completion: nil)
    }
    @objc func goFriendsProposalsSent() {
        checkIfYouAreBanned()
        let proposalsSentController = ProposalsSentController()
        proposalsSentController.contactsController = self
        let proposalsSentNav = UINavigationController(rootViewController: proposalsSentController)
        self.present(proposalsSentNav, animated: true, completion: nil)
    }
    @objc func goBlacklist() {
        checkIfYouAreBanned()
        let blacklistController = BlacklistController()
        blacklistController.contactsController = self
        let blacklistNav = UINavigationController(rootViewController: blacklistController)
        self.present(blacklistNav, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        checkIfYouAreBanned()
        setupNavBarItems()
        setupPhotosContainerView()
        itemsCounter()
    }
}
//extension UIViewController: MFMessageComposeViewControllerDelegate {
//    
//    
//    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
//        switch (result.rawValue) {
//        case MessageComposeResult.cancelled.rawValue:
//            print("Message was cancelled")
//            controller.dismiss(animated: true, completion: nil)
//        case MessageComposeResult.failed.rawValue:
//            print("Message failed")
//            controller.dismiss(animated: true, completion: nil)
//        case MessageComposeResult.sent.rawValue:
//            print("Message was sent")
//            controller.dismiss(animated: true, completion: nil)
//        default:
//            break;
//        }
//    }
//}
