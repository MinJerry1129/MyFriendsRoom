//
//  ChatLogController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 03.09.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import UserNotifications
var reportMessageId = String()
class ChatLogController: UICollectionViewController, UITextFieldDelegate, UITextViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var inBlacklist = false
    var blacklistPopupWasShown = false
    var userInBlacklist = false
    var youAreBanned = false
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
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
    let profile: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(viewProfile), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("CONTACT", for: .normal)
        cb.setTitleColor(CustomColors.commonGrey1, for: .normal)
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cb.isUserInteractionEnabled = true
        return cb
    }()
    @objc func viewProfile(){
        print("eshkere")
        let memberUid = (idOfUser as AnyObject)
        goToControllerByMemberUid = memberUid as! String
        let memberProfileController = MemberProfileController()
        let memberProfileNav = UINavigationController(rootViewController: memberProfileController)
        self.present(memberProfileNav, animated: true, completion: nil)
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
    func checkIfUserDeleted() {
        let ref = Database.database().reference().child("users").child((user?.id)!).child("wasDeleted")
        ref.observeSingleEvent(of: .value) { (snap) in
            if snap.value as? String == "byAdministration" {
                print("this user was deleted by administration")
                self.containerView.isHidden = true
                let alert = UIAlertController(title: "This user got banned from MyFriendsRoom", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else if snap.value as? String == "bySelf" {
                print("this user deletedd each self")
                self.containerView.isHidden = true
                let alert = UIAlertController(title: "This profile has been deleted", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    var messages = [Message]()
    var userMessagesRef: DatabaseReference!
    var messagesRef: DatabaseReference!
    var messagesRefArray = [DatabaseReference]()
    var funcRef: DatabaseReference!
//    var userMessagesRefHandle: DatabaseHandle!
//    var messagesRefHandle: DatabaseHandle!
//    var funcRefHandle: DatabaseHandle!
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else { return }
        userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
//        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
//        self.userMessagesRefHandle = userMessagesRef.observe(.childAdded, with: { (snapshot) in
        
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let values = [messageId: 2]
            self.userMessagesRef.updateChildValues(values)
            self.messagesRef = Database.database().reference().child("messages").child(messageId)
            self.messagesRefArray.append(self.messagesRef)
//            let messagesRef = Database.database().reference().child("messages").child(messageId)
            func obserSingle(id: String, changed: Bool){
                self.funcRef = Database.database().reference().child("messages").child(id)
                self.funcRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    //                print(snapshot)
                    guard var dictionary = snapshot.value as? [String: Any] else {
                        return
                    }
                    print(dictionary)
                    dictionary["messageId"] = messageId
                    if  let  timeResult = dictionary["timestamp"] {
                        let date = Date(timeIntervalSince1970: TimeInterval(timeResult as! NSNumber))
                        let dateFormatter = DateFormatter()
                        let timeFormatter = DateFormatter()
                        dateFormatter.timeStyle = DateFormatter.Style.none //Set time style
                        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                        dateFormatter.timeZone = NSTimeZone() as TimeZone
                        timeFormatter.timeStyle = DateFormatter.Style.short //Set time style
                        timeFormatter.dateStyle = DateFormatter.Style.none //Set date style
                        timeFormatter.timeZone = NSTimeZone() as TimeZone
                        let localDate = dateFormatter.string(from: date)
                        let localTime = timeFormatter.string(from: date)
//                        let width = estimateFrameForText(text: localDate).width + 10
//                        cell.dateWidthAnchor?.isActive = false
//                        cell.dateWidthAnchor = cell.bubbleView.widthAnchor.constraint(equalToConstant: width)
//                        cell.dateWidthAnchor?.isActive = true
                        dictionary["date"] = localDate
                        dictionary["time"] = localTime
                        print("localTime: ", localTime)
                    }
                    if let name = dictionary["name"] {
                        let travelChecked = dictionary["travelChecked"] as! Bool
                        let dateChecked = dictionary["dateChecked"] as! Bool
                        let meetChecked = dictionary["meetChecked"] as! Bool
                        let currentLoc = dictionary["currentLoc"] as? String
                        let homeLoc = dictionary["homeLoc"] as! String
                        let travelDateTo = dictionary["travelDateTo"] as? String
                        let travelDateFrom = dictionary["travelDateFrom"] as? String
                        let occupation = dictionary["occupation"] as? String
                        let name = dictionary["name"] as! String
                        let age = dictionary["age"] as! String
                        var messagePropsToText = ""
                        let nameAndAge = name + ", " + age
                        messagePropsToText = nameAndAge + "\n"
                        if currentLoc != nil {
                            if currentLoc != "" {
                                messagePropsToText = messagePropsToText + "Current location:\n " + currentLoc! + "\n"
                            }
                        }
                        if homeLoc != "" {
                            messagePropsToText = messagePropsToText + "Home location:\n " + homeLoc + "\n"
                        }
                        if occupation != nil {
                            if occupation != "" {
                                messagePropsToText = messagePropsToText + "Occupation:\n " + occupation! + "\n"
                            }
                        }
                        if travelChecked || dateChecked || meetChecked {
                            messagePropsToText = messagePropsToText + "Interested in:\n"
                            if travelChecked {
                                messagePropsToText = messagePropsToText + "- travel accommodation\n"
                            }
                            if meetChecked {
                                messagePropsToText = messagePropsToText + "- to meet up\n"
                            }
                            if dateChecked {
                                messagePropsToText = messagePropsToText + "- dating\n"
                            }
                        }
                        if travelDateFrom != "-" || travelDateTo != "-" {
                            messagePropsToText = messagePropsToText + "Travel dates:\n"
                            if travelDateFrom != "-" {
                                messagePropsToText = messagePropsToText + "From: " + travelDateFrom! + "\n"
                            }
                            if travelDateTo != "-" {
                                messagePropsToText = messagePropsToText + "To: " + travelDateTo! + "\n"
                            }
                            
                        }
                        dictionary["text"] = messagePropsToText
                    }
                    if changed == false {
                        self.messages.append(Message(dictionary: dictionary as [String : AnyObject]))
                    } else {
//                        self.messages
//                        let index = self.messages.index(of: Message(dictionary: dictionary["messageId"] = id))
                        
//                        print("INDEX`: ",self.messages)
                        var counter = 0
                        for single in self.messages {
                            if single.messId == id {
                                break
                            }
                            counter += 1
                        }
                        self.messages[counter] = Message(dictionary: dictionary as [String : AnyObject])
//                        self.messages.append(Message(dictionary: dictionary as [String : AnyObject]))
//                        print("INDEX`: ",self.messages)
                    }
                    DispatchQueue.main.async{
                        self.collectionView?.reloadData()
                        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                        self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    }
                }, withCancel: nil)
            }
            obserSingle(id: messageId, changed: false)
            self.messagesRef.observe(.childChanged, with: { (snap) in
                print("CHANGED`: ", messageId)
                obserSingle(id: messageId, changed: true)
            })
//            messagesRef.observe(.childRemoved, with: { (snap) in
//                print("CHANGED`: ", messageId)
//                obserSingle(id: messageId, changed: true)
//            })
        }, withCancel: nil)
    }
//    lazy var inputTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Enter message..."
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.delegate = self
//        return textField
//    }()
    lazy var inputTextField: UITextView = {
        let textField = UITextView()
        textField.text = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = CustomColors.commonGrey1
        return textField
    }()
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let placeholder = "Enter message..."
        if textView.text.isEmpty {
            textView.text = placeholder
        }
        textView.textColor = CustomColors.commonGrey1
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let placeholder = "Enter message..."
        if textView.textColor == CustomColors.commonGrey1 {
            if textView.text == placeholder{
                textView.text = nil
            }
            textView.textColor = CustomColors.commonBlue1
        }
    }
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = CustomColors.lightBlue1
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 108, 0)
        checkIfUserDeleted()
        setupInputComponents()
        setupKeyboardObserves()
        setupNavBarItems()
        optionsContainerSetup()
        setupYouInBlacklistStatus()
        setupUserBlockedStatus()
        checkIfYouAreBanned()
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
        let toId = user!.id!
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users-blacklists").child(toId).child(uid!)
        ref.observeSingleEvent(of: .value) { (snap) in
            let snapValueType = type(of: snap.value!)
            if snapValueType != NSNull.self {
                print("You are in blacklist of this user")
                self.inBlacklist = true
                self.containerView.isHidden = true
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.blacklistAlert), userInfo: nil, repeats: false)
            }
        }
    }
    func setupUserBlockedStatus(){
        let toId = user!.id!
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users-blacklists").child(uid!).child(toId)
        ref.observeSingleEvent(of: .value) { (snap) in
            let snapValueType = type(of: snap.value!)
            if snapValueType != NSNull.self {
                print("in black list")
                self.userInBlacklist = true
                self.containerView.isHidden = true
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.blacklistAlert), userInfo: nil, repeats: false)
            }
        }
    }
    @objc func goBack() {
        //userMessagesRef messagesRef
//        self.userMessagesRef.removeAllObservers()
        for single in messagesRefArray{
            single.removeAllObservers()
        }
        messagesRefArray = []
//        self.messagesRef.removeAllObservers()
//        self.funcRef.removeAllObservers()
        
        let uid = user?.id
        let userinfo = ["id": String(describing: uid!)]
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nilTheCounter"), object: nil, userInfo: userinfo)
        })
    }
    func setupNavBarItems(){
        
        let backImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
        let optionsImage = UIImage(named: "dotmenu")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        let optionsButton = UIBarButtonItem(image: optionsImage, style: .plain, target: self, action: #selector(hideUnhideOptions))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = optionsButton
        //profile
//        let cb = UIButton()
//        cb.addTarget(self, action: #selector(viewProfile), for: .touchUpInside)
//        cb.frame = cg
//        cb.translatesAutoresizingMaskIntoConstraints = false
//        cb.setTitle("CONTACT", for: .normal)
//        cb.setTitleColor(CustomColors.commonGrey1, for: .normal)
//        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        cb.isUserInteractionEnabled = true
//        cb.setTitle(nameOfUser, for: .normal)
//        let tt = UITextField()
//        tt.textColor = CustomColors.lightOrange1
//        tt.text = nameOfUser
//        tt.frame = CGRect(x: 100, y: 0, width: 100, height: 40)
//        tt.translatesAutoresizingMaskIntoConstraints = false
////        tt.isUserInteractionEnabled = false
//        tt.font = .systemFont(ofSize: 25)
//        self.navigationItem.titleView = tt
////        self.navigationItem.titleView = cb
        if #available(iOS 10.0, *) {
            let cb = UIButton()
            cb.addTarget(self, action: #selector(viewProfile), for: .touchUpInside)
            cb.translatesAutoresizingMaskIntoConstraints = false
            cb.setTitleColor(CustomColors.commonGrey1, for: .normal)
            cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            cb.isUserInteractionEnabled = true
            cb.setTitle(nameOfUser, for: .normal)
            self.navigationItem.titleView = cb
        } else {
            self.navigationItem.title = nameOfUser
        }
    }
    @objc func hideUnhideOptions(){
        if optionsContainer.isHidden == true {
            optionsContainer.isHidden = false
        } else {
            optionsContainer.isHidden = true
        }
    }
    @objc func reportAction(){
        let alert = UIAlertController(title: "Report this conversation?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {action in
            print("report")
            reportMethod = "chat"
            let reportController = ReportController()
            let reportControllerNav = UINavigationController(rootViewController: reportController)
            self.present(reportControllerNav, animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    func setupKeyboardObserves(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeybordDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeybordWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeybordWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func handleKeybordDidShow() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
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
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.chatLogController = self
        let message = messages[indexPath.item]
        
        setupCell(cell: cell, message: message)
        
        cell.textView.text = message.text
        cell.textView.tag = indexPath.item
//        if  let  timeResult = message.timestamp {
//            let date = Date(timeIntervalSince1970: TimeInterval(timeResult))
//            let dateFormatter = DateFormatter()
//            let timeFormatter = DateFormatter()
//            dateFormatter.timeStyle = DateFormatter.Style.none //Set time style
//            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
//            dateFormatter.timeZone = NSTimeZone() as TimeZone
//            timeFormatter.timeStyle = DateFormatter.Style.short //Set time style
//            timeFormatter.dateStyle = DateFormatter.Style.none //Set date style
//            timeFormatter.timeZone = NSTimeZone() as TimeZone
        let localDate = message.date
        let localTime = message.time
        let width = estimateFrameForText(text: localDate!).width + 10
        cell.dateWidthAnchor?.isActive = false
        cell.dateWidthAnchor = cell.date.widthAnchor.constraint(equalToConstant: width)
        cell.dateWidthAnchor?.isActive = true//dateHeightAnchor
        var prevMessageDate: String?
        if indexPath.item == 0 {
            prevMessageDate = ""
        } else {
            let prevMessage = messages[indexPath.item - 1]
            prevMessageDate = prevMessage.date
        }
        var dateHeight: CGFloat?
        if prevMessageDate == message.date {
            dateHeight = 0
        } else {
            dateHeight = 30
        }
        
        cell.dateHeightAnchor?.isActive = false
        cell.dateHeightAnchor = cell.date.heightAnchor.constraint(equalToConstant: dateHeight!)
        cell.dateHeightAnchor?.isActive = true
        
        cell.bubbleHeightAnchor?.isActive = false
        cell.bubbleHeightAnchor = cell.bubbleView.heightAnchor.constraint(equalTo: cell.heightAnchor, constant: 0 - dateHeight!)
        cell.bubbleHeightAnchor?.isActive = true
        cell.date.text = localDate
        cell.time.text = localTime
//        }
        cell.textView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(ChatLogController.selectBubbleFromChat)))
        cell.messageImageView.tag = indexPath.item
        if let text = message.text {
            cell.textView.isHidden = false
//            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
            
            let size = CGSize(width: 200, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let frame =  NSString(string: message.text!).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil) as CGRect
            var width = frame.width + 32
            if width < 75 {
                width = 75
            }
//            cell.bubbleWidthAnchor?.constant = width + 55
            cell.bubbleWidthAnchor?.isActive = false
            cell.bubbleWidthAnchor = cell.bubbleView.widthAnchor.constraint(equalToConstant: width)
            cell.bubbleWidthAnchor?.isActive = true
//            cell.bubbleText = message.text
        } else if (message.imageUrl != nil) {
            cell.bubbleWidthAnchor?.constant = 200
//            let width = estimateFrameForText(text: message.text!).width + 32
//            cell.width = width
//            cell.bubbleWidthAnchor?.isActive = false
//            cell.bubbleWidthAnchor = cell.bubbleView.widthAnchor.constraint(equalToConstant: width)
//            cell.bubbleWidthAnchor?.isActive = true
//            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
            cell.textView.isHidden = true
        }
//        print("======some new ", cell.bubbleView.frame)
        return cell
    }
    @objc func selectBubbleFromChat(_ sender: UILongPressGestureRecognizer){
        if let mess = sender.view as? UITextView {
            checkIfYouAreBanned()
            callReportMessageByTag(tag: mess.tag)
        }
    }
    func callReportMessageByTag(tag: Int){
        let messageId = messages[tag].messId
        let chatPartnerId = messages[tag].chatPartnerId()
        if messages[tag].fromId == Auth.auth().currentUser?.uid {
            deleteThisMessage(delMessageId: messageId!, chatPartner: chatPartnerId!, messageTag: tag)
        } else {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {action in
                self.deleteThisMessage(delMessageId: messageId!, chatPartner: chatPartnerId!, messageTag: tag)
            }))
            alert.addAction(UIAlertAction(title: "Report", style: .default, handler: {action in
                self.reportMessage(repMessageId: messageId!)
            }))
            if messages[tag].likeStatus == true {
                alert.addAction(UIAlertAction(title: "Unlike", style: .default, handler: {action in
                    self.unlikeMessage(messId: messageId!)
                }))
            } else {
                alert.addAction(UIAlertAction(title: "Like", style: .default, handler: {action in
                    self.likeMessage(messId: messageId!)
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    func unlikeMessage(messId: String){
        let ref = Database.database().reference().child("messages").child(messId).child("likeStatus")
        ref.updateChildValues(["likeStatus": false])
    }
    func likeMessage(messId: String){
        let ref = Database.database().reference().child("messages").child(messId)
        ref.updateChildValues(["likeStatus": true])
    }
    func deleteThisMessage(delMessageId: String, chatPartner: String, messageTag: Int) {
        let alert = UIAlertController(title: "Delete this message?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {action in
            let uid = Auth.auth().currentUser?.uid
            let arcRef = Database.database().reference().child("archive-user-messages").child(uid!).child(chatPartner)
            arcRef.updateChildValues([delMessageId: 1])
            let reference = Database.database().reference().child("user-messages").child(uid!).child(chatPartner).child(delMessageId)
            reference.removeValue { (error, ref) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    print("Error to delete message: ", error!)
                    return
                }
                self.messages.remove(at: messageTag)
                self.collectionView?.reloadData()
            }
        }))
        self.present(alert, animated: true)
    }
    func reportMessage(repMessageId: String){
        let alert = UIAlertController(title: "Report this message?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {action in
            print("report")
            reportMethod = "message"
            reportMessageId = repMessageId
            let reportController = ReportController()
            let reportControllerNav = UINavigationController(rootViewController: reportController)
            self.present(reportControllerNav, animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    private func setupCell(cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.profileImageUrl {
            if profileImageUrl == "empty" {
                cell.profileImageView.image = UIImage(named: "emptyavatar")
            } else if profileImageUrl == "deleted" {
                cell.profileImageView.image = UIImage(named: "deletedprofile")
            } else {
                cell.profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl)
            }
        }
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageusingCacheWithUrlString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
        } else {
            cell.messageImageView.isHidden = true
        }
        if message.likeStatus == true {
            cell.like.isHidden = false
        } else {
            cell.like.isHidden = true
        }
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = UIColor.white
            cell.textView.textColor = UIColor.gray
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.likeLeftAnchor?.isActive = false
            cell.likeRightAnchor?.isActive = true
        }
        else {
            cell.bubbleView.backgroundColor = UIColor.white
            cell.textView.textColor = CustomColors.lightOrange1
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.likeLeftAnchor?.isActive = true
            cell.likeRightAnchor?.isActive = false
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
//        var width: CGFloat = 200
        let message = messages[indexPath.item]
        var prevMessageDate: String?
        if indexPath.item == 0 {
            prevMessageDate = ""
        } else {
            let prevMessage = messages[indexPath.item - 1]
            prevMessageDate = prevMessage.date
        }
        var plusHeight: CGFloat?
        if message.imageUrl == nil {
            if prevMessageDate == message.date {
                plusHeight = 40
            } else {
                plusHeight = 70
            }
        } else {
            if prevMessageDate == message.date {
                plusHeight = 0
            } else {
                plusHeight = 30
            }
        }
        if let text = message.text {
            height = estimateFrameForText(text: text).height
//            width = estimateFrameForText(text: text).width
        } else if  let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        return CGSize(width: view.frame.width, height: height + plusHeight!)
//        return CGSize(width: width, height: height)
    }
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    func optionsContainerSetup(){
        view.addSubview(optionsContainer)
        optionsContainer.addSubview(reportButton)
        
        optionsContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        optionsContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        optionsContainer.widthAnchor.constraint(equalToConstant: 70).isActive = true
        optionsContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        optionsContainer.isHidden = true
        
        reportButton.topAnchor.constraint(equalTo: optionsContainer.topAnchor).isActive = true
        reportButton.centerXAnchor.constraint(equalTo: optionsContainer.centerXAnchor).isActive = true
        reportButton.widthAnchor.constraint(equalTo: optionsContainer.widthAnchor).isActive = true
        reportButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    var containerViewBottomAnchor: NSLayoutConstraint?
    func setupInputComponents(){
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "sendImage")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        containerView.addSubview(uploadImageView)
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        uploadImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
//        let sendButton = UIButton(type: .system)
//        sendButton.setTitle("Send", for: .normal)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
//        sendButton.tintColor = CustomColors.lightOrange1
//        containerView.addSubview(sendButton)
//        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let sendButton = UITextView()
        sendButton.text = "  Send"
        sendButton.isEditable = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSend)))
        sendButton.textColor = CustomColors.lightOrange1
        sendButton.font = .systemFont(ofSize: 16)
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 36).isActive = true

        containerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    @objc func handleUploadTap() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info ["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info ["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsigImage(image: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    private func uploadToFirebaseStorageUsigImage(image: UIImage){
        print("upload to firebase")
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("messages-images").child(imageName)
        if let uploadData = UIImageJPEGRepresentation(image, 0.2){
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    print("Failed to appload image: ", error!)
                    return
                }
                ref.downloadURL { (url, error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    let imageUrl = url?.absoluteString
                    self.sendMessageWithImageUrl(imageUrl: imageUrl!, image: image)
                }
            })
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    @objc func handleSend(){
        print("send pressed")
        checkIfYouAreBanned()
        let message = inputTextField.text
        let premessage = message?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        if (premessage?.count)! != 0 {
            let properties = ["text": message!] as [String : Any]
            sendMessagesWithProperties(properties: properties as [String : AnyObject])
        } else {
            print("message is empty")
        }
    }
    private func sendMessageWithImageUrl(imageUrl: String, image: UIImage){
        let properties = ["imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
        sendMessagesWithProperties(properties: properties as [String : AnyObject])
    }
    private func sendMessagesWithProperties(properties: [String: AnyObject]) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let blacklistRef = Database.database().reference().child("users-blacklists").child(toId).child(fromId)
        blacklistRef.observeSingleEvent(of: .value) { (snap) in
            let snapValueType = type(of: snap.value!)
            if snapValueType != NSNull.self {
                print("You are in blacklist of this user")
                self.inBlacklist = true
                self.containerView.isHidden = true
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.blacklistAlert), userInfo: nil, repeats: false)
            } else {
                let timestamp = Int(NSDate().timeIntervalSince1970)
                var values = ["toId": toId, "fromId": fromId, "timestamp": timestamp, "likeStatus": false] as [String : Any]
                properties.forEach {values[$0] = $1}
                childRef.updateChildValues(values) { (error, ref) in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        print(error)
                        return
                    }
                    self.inputTextField.text = nil
                    let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
                    let messageId = childRef.key
                    userMessagesRef.updateChildValues([messageId: 1])
                    let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
                    recipientUserMessagesRef.updateChildValues([messageId: 1])
                    print(recipientUserMessagesRef.updateChildValues([messageId: 1]))
                    
                    self.fetchmessages(toId: toId, fromId: fromId, properties: properties)
                }
            }
        }
        
    }
    
    func fetchmessages(toId: String, fromId: String, properties: [String: AnyObject]) {
//        counterbadge += 1
        Database.database().reference().child("users").child(fromId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            let name = dictionary["name"] as! String
            
            print(name)
            
            Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else {return}
                guard let fromDevice = dictionary["fromDevice"] as? String else {return}
                
                print(fromDevice)
                
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
//                let notification = ["to":"\(toDeviceID)", "notification":["body":body, "title":title, "badge": 1, "sound":"default"], "data":["uid":uid, "method":method]] as [String : Any]
////                let notification = ["to":"\(toDeviceID)", "notification":["body":body, "title":title, "sound":"default"]] as [String : Any]
//                Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
//
//                    
//                }
                
            }
            
        }
       
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        handleSend()
        return true
    }
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    var startingFrameTapLayout: UIView?
    func performZoomInForStartingImageView(startingImageView: UIImageView){
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        self.startingImageView?.backgroundColor = CustomColors.lightBlue1
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        if let keyWindow = UIApplication.shared.keyWindow {
            startingFrameTapLayout = UIView(frame: startingFrame!)
            startingFrameTapLayout?.backgroundColor = CustomColors.lightBlue1
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(startingFrameTapLayout!)
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.blackBackgroundView?.alpha = 1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height:  height)
                zoomingImageView.center = keyWindow.center
            }) { (completed) in
            }
        }
        zoomingImageView.backgroundColor = UIColor.red
        UIApplication.shared.keyWindow?.addSubview(zoomingImageView)
    }
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer){
        if let zoomOutImageView = tapGesture.view{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
            }) { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
                self.startingFrameTapLayout?.removeFromSuperview()
            }
        }
    }
}
