//
//  InviteFrindsController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 17.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import MessageUI

class InviteFriendsController: UIViewController, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the message compose view controller.
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            controller.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            controller.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            controller.dismiss(animated: true, completion: nil)
        default:
            break;
        }
//        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
    let inviteText: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.commonGrey1
        let str = "Invite your friends and you will be\nconnected to their friends.\nMyFriendsRoom works with\nconnections. Otherwise you can only search for members you don’t know."
        let attributedStr = NSMutableAttributedString.init(string: str)
        attributedStr.addAttribute(.foregroundColor, value: CustomColors.commonGrey1, range: NSRange(location: 0, length: str.count))
        attributedStr.addAttribute(.foregroundColor, value: CustomColors.commonBlue1, range: NSRange(location: 0, length: 19))
        tt.attributedText = attributedStr
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 15)
        return tt
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
    let laterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Later", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(CustomColors.commonBlue1, for: [])
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(later), for: .touchUpInside)
        return button
    }()
    @objc func later(){
        if itWasRegistration == true {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "wasItRegistration"), object: nil)
            itWasRegistration = false
        }
        self.dismiss(animated: true, completion: nil)
    }
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
        if MFMessageComposeViewController.canSendText() {
            let text = "Hey! Be my friend on this great new travel app.\nhttps://itunes.apple.com/app/id1439459277"
            let messageComposeViewController = MFMessageComposeViewController()
            messageComposeViewController.messageComposeDelegate = self
            messageComposeViewController.body = text
            self.present(messageComposeViewController, animated: true, completion: nil)
        
        }
     
        
        
    }
    func inviteFriendsSetup(){
        view.addSubview(inviteText)
        view.addSubview(inviteFriendsTitle)
        view.addSubview(facebookButton)
        view.addSubview(whatsappButton)
        view.addSubview(smsButton)
        view.addSubview(laterButton)
        
        inviteText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inviteText.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        inviteText.widthAnchor.constraint(equalToConstant: 290).isActive = true
        inviteText.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        inviteFriendsTitle.topAnchor.constraint(equalTo: inviteText.bottomAnchor, constant: 30).isActive = true
        inviteFriendsTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20).isActive = true
        inviteFriendsTitle.widthAnchor.constraint(equalTo: inviteText.widthAnchor).isActive = true
        inviteFriendsTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        whatsappButton.topAnchor.constraint(equalTo: inviteFriendsTitle.bottomAnchor, constant: 10).isActive = true
        whatsappButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        whatsappButton.widthAnchor.constraint(equalTo: inviteText.widthAnchor).isActive = true
        whatsappButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        facebookButton.topAnchor.constraint(equalTo: whatsappButton.bottomAnchor, constant: 10).isActive = true
        facebookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookButton.widthAnchor.constraint(equalTo: inviteText.widthAnchor).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        smsButton.topAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: 10).isActive = true
        smsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        smsButton.widthAnchor.constraint(equalTo: facebookButton.widthAnchor).isActive = true
        smsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        laterButton.topAnchor.constraint(equalTo: smsButton.bottomAnchor, constant: 10).isActive = true
        laterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        laterButton.widthAnchor.constraint(equalTo: inviteText.widthAnchor).isActive = true
        laterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        inviteFriendsSetup()
        print("InviteFriendsController \(itWasRegistration)")
    }
}



    
    
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

