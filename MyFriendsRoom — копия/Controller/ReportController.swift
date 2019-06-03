//
//  ReportController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 21.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//
//1. Innapropriate messages
//2. Innapropriate photos
//3. Fake profile
//4. Spam
//5. Commercial profile
//6. Seems like a scam
//7. Other
import UIKit
import Firebase

class ReportController: UIViewController {
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor.white
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.layer.masksToBounds = true
        return sv
    }()
    let resonTitle: UITextField = {
        let tf = UITextField()
        tf.text = "Reason:"
        tf.font = .systemFont(ofSize: 20)
        tf.textColor = CustomColors.commonGrey1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isUserInteractionEnabled = false
        return tf
    }()
    let messagesCheckboxButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(messagesCheck), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  Innapropriate messages", size: 20, forState: .normal)
        tcb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return tcb
    }()
    let photosCheckboxButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(photosCheck), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  Innapropriate photos", size: 20, forState: .normal)
        tcb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return tcb
    }()
    let fakeCheckboxButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(fakeCheck), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  Fake profile", size: 20, forState: .normal)
        tcb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return tcb
    }()
    let spamCheckboxButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(spamCheck), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  Spam", size: 20, forState: .normal)
        tcb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return tcb
    }()
    let commercialCheckboxButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(commercialCheck), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  Commercial profile", size: 20, forState: .normal)
        tcb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return tcb
    }()
    let scamCheckboxButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(scamCheck), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  Seems like a scam", size: 20, forState: .normal)
        tcb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return tcb
    }()
    let otherCheckboxButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(otherCheck), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  Other", size: 20, forState: .normal)
        tcb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return tcb
    }()
    let reportTEXTSContainerView: UIView = {
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
    let reportTextView: UITextView = {
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
        button.setTitle("send", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: [])
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(sentReport), for: .touchUpInside)
        return button
    }()
    @objc func sentReport(){
        if reportReason != "" {
            let uid = Auth.auth().currentUser?.uid
            let timestamp = Int(NSDate().timeIntervalSince1970)
            var values = ["timestamp": timestamp, "reportReason": reportReason, "reportMessage": reportTextView.text, "reportMethod": reportMethod] as [String : Any]
            if reportMethod == "message" {
                values["messageId"] = reportMessageId
            }
            let ref = Database.database().reference().child("users-reports").child(goToControllerByMemberUid!).child(uid!)
            ref.updateChildValues(values)
            let alert = UIAlertController(title: "Report was sent", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.goBack() }))
            self.present(alert, animated: true)
            resonTitle.textColor = CustomColors.commonGrey1
        } else {
            let alert = UIAlertController(title: "Notice", message: "Please select one of reasons", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            resonTitle.textColor = CustomColors.lightOrange1
        }
    }
    var reportReason = ""
    @objc func messagesCheck(){
        messagesCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        photosCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        fakeCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        spamCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        commercialCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        scamCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        otherCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        reportReason = "Innapropriate messages"
    }
    @objc func photosCheck(){
        messagesCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        photosCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        fakeCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        spamCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        commercialCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        scamCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        otherCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        reportReason = "Innapropriate photos"
    }
    @objc func fakeCheck(){
        messagesCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        photosCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        fakeCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        spamCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        commercialCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        scamCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        otherCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        reportReason = "Fake profile"
    }
    @objc func spamCheck(){
        messagesCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        photosCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        fakeCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        spamCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        commercialCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        scamCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        otherCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        reportReason = "Spam"
    }
    @objc func commercialCheck(){
        messagesCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        photosCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        fakeCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        spamCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        commercialCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        scamCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        otherCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        reportReason = "Commercial profile"
    }
    @objc func scamCheck(){
        messagesCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        photosCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        fakeCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        spamCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        commercialCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        scamCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        otherCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        reportReason = "Seems like a scam"
    }
    @objc func otherCheck(){
        messagesCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        photosCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        fakeCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        spamCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        commercialCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        scamCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        otherCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        reportReason = "Other"
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
    func reportElementsSetup(){
        view.addSubview(scrollView)
        scrollView.addSubview(resonTitle)
        scrollView.addSubview(messagesCheckboxButton)
        scrollView.addSubview(photosCheckboxButton)
        scrollView.addSubview(fakeCheckboxButton)
        scrollView.addSubview(spamCheckboxButton)
        scrollView.addSubview(commercialCheckboxButton)
        scrollView.addSubview(scamCheckboxButton)
        scrollView.addSubview(otherCheckboxButton)
        
        view.addSubview(reportTEXTSContainerView)
        reportTEXTSContainerView.addSubview(messageTitle)
        reportTEXTSContainerView.addSubview(reportTextView)
        reportTEXTSContainerView.addSubview(sendButton)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -64).isActive = true
        
        resonTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        resonTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        resonTitle.widthAnchor.constraint(equalToConstant: 280).isActive = true
        resonTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true

        messagesCheckboxButton.centerXAnchor.constraint(equalTo:  scrollView.centerXAnchor).isActive = true
        messagesCheckboxButton.topAnchor.constraint(equalTo: resonTitle.bottomAnchor, constant: 15).isActive = true
        messagesCheckboxButton.widthAnchor.constraint(equalTo: resonTitle.widthAnchor).isActive = true
        messagesCheckboxButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        messagesCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: messagesCheckboxButton.leftAnchor).isActive = true
        
        photosCheckboxButton.centerXAnchor.constraint(equalTo:  scrollView.centerXAnchor).isActive = true
        photosCheckboxButton.topAnchor.constraint(equalTo: messagesCheckboxButton.bottomAnchor, constant: 15).isActive = true
        photosCheckboxButton.widthAnchor.constraint(equalTo: resonTitle.widthAnchor).isActive = true
        photosCheckboxButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        photosCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: photosCheckboxButton.leftAnchor).isActive = true
        
        fakeCheckboxButton.centerXAnchor.constraint(equalTo:  scrollView.centerXAnchor).isActive = true
        fakeCheckboxButton.topAnchor.constraint(equalTo: photosCheckboxButton.bottomAnchor, constant: 15).isActive = true
        fakeCheckboxButton.widthAnchor.constraint(equalTo: resonTitle.widthAnchor).isActive = true
        fakeCheckboxButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        fakeCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: fakeCheckboxButton.leftAnchor).isActive = true
        
        spamCheckboxButton.centerXAnchor.constraint(equalTo:  scrollView.centerXAnchor).isActive = true
        spamCheckboxButton.topAnchor.constraint(equalTo: fakeCheckboxButton.bottomAnchor, constant: 15).isActive = true
        spamCheckboxButton.widthAnchor.constraint(equalTo: resonTitle.widthAnchor).isActive = true
        spamCheckboxButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        spamCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: spamCheckboxButton.leftAnchor).isActive = true
        
        commercialCheckboxButton.centerXAnchor.constraint(equalTo:  scrollView.centerXAnchor).isActive = true
        commercialCheckboxButton.topAnchor.constraint(equalTo: spamCheckboxButton.bottomAnchor, constant: 15).isActive = true
        commercialCheckboxButton.widthAnchor.constraint(equalTo: resonTitle.widthAnchor).isActive = true
        commercialCheckboxButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        commercialCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: commercialCheckboxButton.leftAnchor).isActive = true
        
        scamCheckboxButton.centerXAnchor.constraint(equalTo:  scrollView.centerXAnchor).isActive = true
        scamCheckboxButton.topAnchor.constraint(equalTo: commercialCheckboxButton.bottomAnchor, constant: 15).isActive = true
        scamCheckboxButton.widthAnchor.constraint(equalTo: resonTitle.widthAnchor).isActive = true
        scamCheckboxButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        scamCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: scamCheckboxButton.leftAnchor).isActive = true
        
        otherCheckboxButton.centerXAnchor.constraint(equalTo:  scrollView.centerXAnchor).isActive = true
        otherCheckboxButton.topAnchor.constraint(equalTo: scamCheckboxButton.bottomAnchor, constant: 15).isActive = true
        otherCheckboxButton.widthAnchor.constraint(equalTo: resonTitle.widthAnchor).isActive = true
        otherCheckboxButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        otherCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: otherCheckboxButton.leftAnchor).isActive = true
//        otherCheckboxButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        containerViewBottomAnchor = reportTEXTSContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10)
        containerViewBottomAnchor?.isActive = true
        reportTEXTSContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reportTEXTSContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        reportTEXTSContainerView.heightAnchor.constraint(equalToConstant: 180).isActive = true
//        reportTEXTSContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        
        messageTitle.centerXAnchor.constraint(equalTo:  reportTEXTSContainerView.centerXAnchor).isActive = true
        messageTitle.topAnchor.constraint(equalTo: reportTEXTSContainerView.topAnchor).isActive = true
        messageTitle.widthAnchor.constraint(equalToConstant: 280).isActive = true
        messageTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        reportTextView.leftAnchor.constraint(equalTo:  messageTitle.leftAnchor).isActive = true
        reportTextView.topAnchor.constraint(equalTo: messageTitle.bottomAnchor, constant: 15).isActive = true
        reportTextView.widthAnchor.constraint(equalToConstant: 245).isActive = true
        reportTextView.heightAnchor.constraint(equalToConstant: 103).isActive = true
        
        sendButton.centerXAnchor.constraint(equalTo: reportTextView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: reportTextView.bottomAnchor, constant: -10).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    func setupNavBarItems(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.lightOrange1]
        let backImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "Report"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.setupHideKeyboardOnTap()
        reportElementsSetup()
        setupNavBarItems()
        setupKeybordObservers()
    }
    
}
