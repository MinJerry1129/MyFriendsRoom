//
//  ContactMemberController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 28.09.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class ContactMemberController: UIViewController, UITextViewDelegate {
    var inBlacklist = false
    var blacklistPopupWasShown = false
    var userInBlacklist = false
    var youAreBanned = false
    
    let contactTitleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let memberNameAndAge: UITextView = {
        let tt = UITextView()
        tt.isUserInteractionEnabled = false
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.text = "%Username% 00"
        tt.textColor = CustomColors.commonGrey1
        tt.font = .boldSystemFont(ofSize: 20)
        return tt
    }()
    let currentLocationView: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Current location:"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 20)
        return tt
    }()
    let homeLocationView: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Home location:"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 20)
        return tt
    }()
    let lookingForTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "I am interested in"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 20)
        return tt
    }()
    let welcomeTextsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let travelCheckboxButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(travelCheck), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  travel accommodation", size: 20, forState: .normal)
        tcb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return tcb
    }()
    let meetCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(meetCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  to meet up with people", size: 20, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    let dateCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(dateCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  to date", size: 20, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    let contactTEXTSContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let messageTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Message"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 20)
        return tt
    }()
    let sendContactTextView: UITextView = {
        let tt = UITextView()
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.textColor = CustomColors.commonGrey1
        tt.font = .boldSystemFont(ofSize: 15)
        tt.layer.borderWidth = 2
        tt.layer.borderColor = CustomColors.commonGrey1.cgColor
        return tt
    }()
    var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = CustomColors.commonBlue1
        button.setTitle("GO", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: [])
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
//        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contactToMember)))
        button.addTarget(self, action: #selector(contactToMember), for: .touchUpInside)
        return button
    }()
    let pickerOverlayer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    var acceptTimeFromPicker: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("OK", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.titleLabel?.textColor = CustomColors.commonBlue1
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.addTarget(self, action: #selector(acceptTime), for: .touchUpInside)
        return button
    }()
    var datepicker: UIDatePicker!
    let travelDateTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "My travel dates"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 20)
        return tt
    }()
    let fromDateTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "From: "
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 20)
        return tt
    }()
    var fromDatePicker: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("pick date", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.titleLabel?.textColor = CustomColors.commonGrey1
        button.setTitleColor(CustomColors.commonBlue1, for: [])
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(fromPicker), for: .touchUpInside)
        return button
    }()
    let toDateTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "To: "
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 20)
        return tt
    }()
    var toDatePicker: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("pick date", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.titleLabel?.textColor = CustomColors.commonGrey1
        button.setTitleColor(CustomColors.commonBlue1, for: [])
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(toPicker), for: .touchUpInside)
        return button
    }()
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor.white
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.layer.masksToBounds = true
        return sv
    }()
    var selectedPicker = Int()
    @objc func fromPicker(_ sender: UITapGestureRecognizer){
        selectedPicker = 1
        pickerOverlayer.isHidden = false
    }
    @objc func toPicker(_ sender: UITapGestureRecognizer){
        selectedPicker = 2
        pickerOverlayer.isHidden = false
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
    @objc func contactToMember(){
        print("тааак")
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            let homeLocation = value["loc"] as! String
            let name = value["name"] as! String
            let age = value["age"] as! String
            let occupation = value["occupation"] as! String
            var startingInterested = "\nInterested in: "
            var messageTravelDate = ""
            var message_currentLocation = ""
            var messageTravelDateFrom = "-"
            var messageTravelDateTo = "-"
            let currentLocationVAlue = value["currentLoc"] as? String
            if self.travelChecked == true {
                startingInterested = startingInterested + "\n - travel accommodation"
            }
            if self.meetChecked == true {
                startingInterested = startingInterested + "\n - to meet up"
            }
            if self.dateChecked == true {
                startingInterested = startingInterested + "\n - dating"
            }
            if self.fromDatePicker.titleLabel?.text != "pick date" || self.toDatePicker.titleLabel?.text  != "pick date" {
                messageTravelDate = "\nTravel dates"
            }
            if self.fromDatePicker.titleLabel?.text != "pick date" {
                let fromText = (self.fromDatePicker.titleLabel?.text)!
                messageTravelDateFrom = fromText as String
            }
            if self.toDatePicker.titleLabel?.text  != "pick date" {
                let toText = (self.toDatePicker.titleLabel?.text)!
                messageTravelDateTo = toText as String
            }
            if currentLocationVAlue != nil && currentLocationVAlue != "" {
                message_currentLocation = "\nCurrent location: " + currentLocationVAlue!
            }
            let message_homeLocation = "\nHome: " + homeLocation
            let nameAndAge = name + " " + age + "\n"
            let messageText = self.sendContactTextView.text!
            var messageTextFullPartOne = nameAndAge + occupation
            messageTextFullPartOne = messageTextFullPartOne + message_currentLocation + message_homeLocation + messageTravelDate
            let messageTextFull: String
            if startingInterested != "\nInterested in: " {
                messageTextFull = messageTextFullPartOne + startingInterested
            } else {
                messageTextFull = messageTextFullPartOne
            }
            print(messageTextFull)
//            let properties = ["text": messageTextFull] as [String : Any]
            let properties = ["homeLoc": homeLocation, "name": name, "age": age, "occupation": occupation, "travelDateFrom": messageTravelDateFrom, "travelDateTo": messageTravelDateTo, "travelChecked": self.travelChecked, "meetChecked": self.meetChecked, "dateChecked": self.dateChecked, "currentLoc": currentLocationVAlue] as [String : Any]
            print("======================================contact member======================================")
            let trimmedMessageText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedMessageText.count != 0 {
                self.sendMessagesWithProperties(properties: properties as [String : AnyObject], name: name, sentNotif: false)
                var timer = Timer()
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.sendSecondMessage), userInfo: ["messageText" : messageText, "name" : name], repeats: false)
                self.messageTitle.textColor = CustomColors.commonGrey1
            } else {
                let alert = UIAlertController(title: "Enter your message", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                self.messageTitle.textColor = CustomColors.lightOrange1
            }
        })

    }
    @objc func blacklistAlert() {
        var alertTitle = ""
        if inBlacklist == true && userInBlacklist == false {
            alertTitle = "This user has blacklisted you"
        } else if inBlacklist == false && userInBlacklist == true {
            alertTitle = "You blacklisted this user"
        } else if inBlacklist == true && userInBlacklist == true {
            alertTitle = "You and this user have added each other to the blacklist"
        }
        if alertTitle != ""  && blacklistPopupWasShown == false {
            let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            blacklistPopupWasShown = true
        }
    }
    func setupYouInBlacklistStatus(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users-blacklists").child(goToControllerByMemberUid!).child(uid!)
        ref.observeSingleEvent(of: .value) { (snap) in
            let snapValueType = type(of: snap.value!)
            if snapValueType != NSNull.self {
                print("You are in blacklist of this user")
                self.inBlacklist = true
                self.contactTEXTSContainerView.isHidden = true
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.blacklistAlert), userInfo: nil, repeats: false)
            }
        }
    }
    func setupUserBlockedStatus(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users-blacklists").child(uid!).child(goToControllerByMemberUid!)
        ref.observeSingleEvent(of: .value) { (snap) in
            let snapValueType = type(of: snap.value!)
            if snapValueType != NSNull.self {
                print("in black list")
                self.userInBlacklist = true
                self.contactTEXTSContainerView.isHidden = true
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.blacklistAlert), userInfo: nil, repeats: false)
            }
        }
    }
    @objc func sendSecondMessage(timer: Timer){
        let dict = timer.userInfo as! NSDictionary
        let message = dict["messageText"] as? String
        let name = dict["name"] as? String
        let properties = ["text": message!, "likeStatus": false] as [String : Any]
        self.sendMessagesWithProperties(properties: properties as [String : AnyObject], name: name!, sentNotif: true)
        let alert = UIAlertController(title: "Sent", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
        
    }
    private func sendMessagesWithProperties(properties: [String: AnyObject], name: String, sentNotif: Bool) {
        print("======================================sent======================================")
        checkIfYouAreBanned()
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = goToControllerByMemberUid
        let fromId = Auth.auth().currentUser!.uid
        let blacklistRef = Database.database().reference().child("users-blacklists").child(toId!).child(fromId)
        blacklistRef.observeSingleEvent(of: .value) { (snap) in
            let snapValueType = type(of: snap.value!)
            if snapValueType != NSNull.self {
                print("You are in blacklist of this user")
                self.inBlacklist = true
                self.contactTEXTSContainerView.isHidden = true
                let alert = UIAlertController(title: "This user has blacklisted you", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.blacklistAlert), userInfo: nil, repeats: false)
            } else {
                let timestamp = Int(NSDate().timeIntervalSince1970)//InstanceID.instanceID().token()
                var values = ["toId": toId!, "fromId": fromId, "timestamp": timestamp, "fromDevice":InstanceID.instanceID().token()] as [String : Any]
//                var values = ["toId": toId!, "fromId": fromId, "timestamp": timestamp, "fromDevice":AppDelegate.DEVICEID] as [String : Any]
                properties.forEach {values[$0] = $1}
                childRef.updateChildValues(values) { (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    self.sendContactTextView.text = nil
                    let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId!)
                    let messageId = childRef.key
                    userMessagesRef.updateChildValues([messageId: 1])
                    let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId!).child(fromId)
                    recipientUserMessagesRef.updateChildValues([messageId: 1])
                    print(recipientUserMessagesRef.updateChildValues([messageId: 1]))
                }
                
                if sentNotif == true {
                    self.fetchmessages(toId: toId!, properties: properties, name: name)
                }
            }
        }
    }
    
    func fetchmessages(toId: String, properties: [String: AnyObject], name: String) {
        Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let fromDevice = dictionary["fromDevice"] as? String else {return}
            
            print(fromDevice)
            self.setupPushNotification(toId: toId, fromDevice: fromDevice, properties: properties, name: name)
        }
    }
    
    
    func setupPushNotification(toId: String, fromDevice:String, properties: [String: AnyObject], name: String) {
        guard let message = properties["text"] else {return}
        let title = name
        let body = message
        let toDeviceID = fromDevice
        let uid = Auth.auth().currentUser?.uid
        let method = "chat"
    
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
//        let notification = ["to":"\(toDeviceID)", "notification":["body":body, "title":title, "badge":1, "sound":"default"], "data":["uid":uid, "method":method]] as [String : Any]
//        
//        Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            
//        }
    }
    func getMemberData(){
        checkIfYouAreBanned()
        let uid = goToControllerByMemberUid
        let ref = Database.database().reference().child("users").child(uid!)
        ref.observe(.value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            if let curLoc = value["currentLoc"] as! String? {
                if curLoc != "" {
                    self.currentLocationView.text = "Current location: \(curLoc)"
                    self.currentLocationView.heightAnchor.constraint(equalToConstant: 30).isActive = true
                } else {
                    self.currentLocationView.heightAnchor.constraint(equalToConstant: 0).isActive = true
                }
            } else {
                self.currentLocationView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            }
            let homeLocation = value["loc"] as! String
            let name = value["name"] as! String
            let age = value["age"] as! String
            self.homeLocationView.text = "Home location: " + homeLocation
            let nameAndAge = name + " " + age
            self.memberNameAndAge.text = nameAndAge
        })
    }
    func getCurentSettings(){
        checkIfYouAreBanned()
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("users").child(uid)
        ref.observe(.value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            self.travelChecked = value["travelChecked"] as! Bool
            self.meetChecked = value["meetChecked"] as! Bool
            self.dateChecked = value["dateChecked"] as! Bool
            if self.travelChecked == true {
                self.travelCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
            }
            if self.meetChecked == true {
                self.meetCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
            }
            if self.dateChecked == true {
                self.dateCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
            }
        })
        
    }
    var travelChecked = false, meetChecked = false, dateChecked = false
    @objc func travelCheck(){
        var color = UIColor()
        if travelChecked == true {
            color = CustomColors.commonBlue1
            travelChecked = false
        } else {
            color = CustomColors.lightOrange1
            travelChecked = true
        }
        travelCheckboxButton.setFATitleColor(color: color, forState: .normal)
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
        meetCheckboxButton.setFATitleColor(color: color, forState: .normal)
    }
    @objc func dateCheck(){
        var color = UIColor()
        if dateChecked == true {
            color = CustomColors.commonBlue1
            dateChecked = false
        } else {
            color = CustomColors.lightOrange1
            dateChecked = true
        }
        dateCheckboxButton.setFATitleColor(color: color, forState: .normal)
    }
    func textsContainerSetup(){  //
        view.addSubview(scrollView)
        scrollView.addSubview(contactTitleContainerView)
        contactTitleContainerView.addSubview(memberNameAndAge)
//        contactTitleContainerView.addSubview(currentLocationView)
//        contactTitleContainerView.addSubview(homeLocationView)
        contactTitleContainerView.addSubview(lookingForTitle)
        contactTitleContainerView.addSubview(travelCheckboxButton)
        contactTitleContainerView.addSubview(meetCheckboxButton)
        contactTitleContainerView.addSubview(dateCheckboxButton)
        contactTitleContainerView.addSubview(travelDateTitle)
        contactTitleContainerView.addSubview(fromDateTitle)
        contactTitleContainerView.addSubview(fromDatePicker)
        contactTitleContainerView.addSubview(toDateTitle)
        contactTitleContainerView.addSubview(toDatePicker)
        
        
        view.addSubview(contactTEXTSContainerView)
        contactTEXTSContainerView.addSubview(messageTitle)
        contactTEXTSContainerView.addSubview(sendContactTextView)
        contactTEXTSContainerView.addSubview(sendButton)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: 270).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -190).isActive = true
        
        contactTitleContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contactTitleContainerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        contactTitleContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contactTitleContainerView.heightAnchor.constraint(equalToConstant: 420).isActive = true
        contactTitleContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        memberNameAndAge.leftAnchor.constraint(equalTo: contactTitleContainerView.leftAnchor, constant: -4).isActive = true
        memberNameAndAge.topAnchor.constraint(equalTo: contactTitleContainerView.topAnchor).isActive = true
        memberNameAndAge.widthAnchor.constraint(equalTo: contactTitleContainerView.widthAnchor).isActive = true
        memberNameAndAge.heightAnchor.constraint(equalToConstant: 44).isActive = true
//
//        currentLocationView.leftAnchor.constraint(equalTo: contactTitleContainerView.leftAnchor, constant: -4).isActive = true
//        currentLocationView.topAnchor.constraint(equalTo: memberNameAndAge.bottomAnchor, constant: 10).isActive = true
//        currentLocationView.widthAnchor.constraint(equalTo: contactTitleContainerView.widthAnchor).isActive = true
//        currentLocationView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
//        homeLocationView.leftAnchor.constraint(equalTo: contactTitleContainerView.leftAnchor, constant: -4).isActive = true
//        homeLocationView.topAnchor.constraint(equalTo: currentLocationView.bottomAnchor, constant: 10).isActive = true
//        homeLocationView.widthAnchor.constraint(equalTo: contactTitleContainerView.widthAnchor).isActive = true
//        homeLocationView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        lookingForTitle.leftAnchor.constraint(equalTo:  contactTitleContainerView.leftAnchor).isActive = true
        lookingForTitle.topAnchor.constraint(equalTo: memberNameAndAge.bottomAnchor, constant: 10).isActive = true
        lookingForTitle.widthAnchor.constraint(equalTo: contactTitleContainerView.widthAnchor).isActive = true
        lookingForTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        travelCheckboxButton.leftAnchor.constraint(equalTo: contactTitleContainerView.leftAnchor).isActive = true
        travelCheckboxButton.topAnchor.constraint(equalTo: lookingForTitle.bottomAnchor, constant: 5).isActive = true
        travelCheckboxButton.widthAnchor.constraint(equalTo: contactTitleContainerView.widthAnchor).isActive = true
        travelCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        travelCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: contactTitleContainerView.leftAnchor).isActive = true
        
        meetCheckboxButton.leftAnchor.constraint(equalTo: contactTitleContainerView.leftAnchor).isActive = true
        meetCheckboxButton.topAnchor.constraint(equalTo: travelCheckboxButton.bottomAnchor, constant: 5).isActive = true
        meetCheckboxButton.widthAnchor.constraint(equalTo: contactTitleContainerView.widthAnchor).isActive = true
        meetCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        meetCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: contactTitleContainerView.leftAnchor).isActive = true
        
        dateCheckboxButton.leftAnchor.constraint(equalTo: contactTitleContainerView.leftAnchor).isActive = true
        dateCheckboxButton.topAnchor.constraint(equalTo: meetCheckboxButton.bottomAnchor, constant: 5).isActive = true
        dateCheckboxButton.widthAnchor.constraint(equalTo: contactTitleContainerView.widthAnchor).isActive = true
        dateCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: contactTitleContainerView.leftAnchor).isActive = true
        
        travelDateTitle.leftAnchor.constraint(equalTo:  contactTitleContainerView.leftAnchor).isActive = true
        travelDateTitle.topAnchor.constraint(equalTo: dateCheckboxButton.bottomAnchor, constant: 10).isActive = true
        travelDateTitle.widthAnchor.constraint(equalTo: contactTitleContainerView.widthAnchor).isActive = true
        travelDateTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        fromDateTitle.leftAnchor.constraint(equalTo:  contactTitleContainerView.leftAnchor).isActive = true
        fromDateTitle.topAnchor.constraint(equalTo: travelDateTitle.bottomAnchor, constant: 5).isActive = true
        fromDateTitle.widthAnchor.constraint(equalToConstant: 70).isActive = true
        fromDateTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        fromDatePicker.leftAnchor.constraint(equalTo:  fromDateTitle.rightAnchor).isActive = true
        fromDatePicker.topAnchor.constraint(equalTo: travelDateTitle.bottomAnchor, constant: 5).isActive = true
        fromDatePicker.widthAnchor.constraint(equalToConstant: 130).isActive = true
        fromDatePicker.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        toDateTitle.leftAnchor.constraint(equalTo:  contactTitleContainerView.leftAnchor).isActive = true
        toDateTitle.topAnchor.constraint(equalTo: fromDateTitle.bottomAnchor, constant: 5).isActive = true
        toDateTitle.widthAnchor.constraint(equalToConstant: 70).isActive = true
        toDateTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        toDatePicker.leftAnchor.constraint(equalTo:  toDateTitle.rightAnchor).isActive = true
        toDatePicker.topAnchor.constraint(equalTo: fromDatePicker.bottomAnchor, constant: 5).isActive = true
        toDatePicker.widthAnchor.constraint(equalToConstant: 130).isActive = true
        toDatePicker.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        containerViewBottomAnchor = contactTEXTSContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10)
        containerViewBottomAnchor?.isActive = true
        contactTEXTSContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contactTEXTSContainerView.widthAnchor.constraint(equalToConstant: 270).isActive = true
        contactTEXTSContainerView.heightAnchor.constraint(equalToConstant: 230).isActive = true
        
        messageTitle.leftAnchor.constraint(equalTo:  contactTEXTSContainerView.leftAnchor).isActive = true
        messageTitle.topAnchor.constraint(equalTo: contactTEXTSContainerView.topAnchor).isActive = true
        messageTitle.widthAnchor.constraint(equalTo: contactTitleContainerView.widthAnchor).isActive = true
        messageTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true

        sendContactTextView.leftAnchor.constraint(equalTo:  contactTEXTSContainerView.leftAnchor).isActive = true
        sendContactTextView.topAnchor.constraint(equalTo: messageTitle.bottomAnchor, constant: 15).isActive = true
        sendContactTextView.widthAnchor.constraint(equalTo: contactTEXTSContainerView.widthAnchor, constant: -25).isActive = true
        sendContactTextView.heightAnchor.constraint(equalToConstant: 153).isActive = true

        sendButton.centerXAnchor.constraint(equalTo: sendContactTextView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: sendContactTextView.bottomAnchor, constant: -10).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        setupKeybordObservers()
    }
    func setupKeybordObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeybordWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeybordWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    var containerViewBottomAnchor: NSLayoutConstraint?
    @objc func handleKeybordWillShow(notification: NSNotification){
        let keyboardFrame: NSValue = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)!
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        let keyboardDuration: Double = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double)!
        containerViewBottomAnchor?.constant = -keyboardHeight
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func handleKeybordWillHide(notification: NSNotification){
        let keyboardDuration: Double = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double)!
        containerViewBottomAnchor?.constant = 10
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
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
        self.navigationItem.title = "Contact"
    }
    @objc func acceptTime(){
        pickerOverlayer.isHidden = true
    }
    func setupDatePicker(){
        datepicker = UIDatePicker()
        view.addSubview(pickerOverlayer)
        pickerOverlayer.addSubview(datepicker)
        pickerOverlayer.addSubview(acceptTimeFromPicker)
        
        pickerOverlayer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pickerOverlayer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pickerOverlayer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        pickerOverlayer.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        datepicker.datePickerMode = .date
//        let today = Date()
//        let oneYear: TimeInterval = 365 * 24 * 60 * 60
        datepicker.center = view.center
        datepicker.addTarget(self, action: #selector(datePickerChanged), for: UIControlEvents.valueChanged)
        
        acceptTimeFromPicker.topAnchor.constraint(equalTo: datepicker.bottomAnchor, constant: 20).isActive = true
        acceptTimeFromPicker.centerXAnchor.constraint(equalTo: pickerOverlayer.centerXAnchor).isActive = true
        acceptTimeFromPicker.widthAnchor.constraint(equalToConstant: 70).isActive = true
        acceptTimeFromPicker.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        pickerOverlayer.isHidden = true
    }
    @objc func datePickerChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: sender.date)
        if selectedPicker == 1 {
            fromDatePicker.titleLabel?.text = dateString
        } else if selectedPicker == 2 {
            toDatePicker.titleLabel?.text = dateString
        }
    }
    func checkIfUserDeleted() {
        let ref = Database.database().reference().child("users").child(goToControllerByMemberUid!).child("wasDeleted")
        ref.observeSingleEvent(of: .value) { (snap) in
            if snap.value as? String == "byAdministration" {
                let alert = UIAlertController(title: "This user got banned from MyFriendsRoom", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            } else if snap.value as? String == "bySelf" {
                let alert = UIAlertController(title: "This profile has been deleted", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        self.setupHideKeyboardOnTap()
        getCurentSettings()
        textsContainerSetup()
        getMemberData()
        setupNavBarItems()
        setupDatePicker()
        setupYouInBlacklistStatus()
        setupUserBlockedStatus()
    }
}
