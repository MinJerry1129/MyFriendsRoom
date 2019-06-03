//
//  BugReportController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 12.11.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase

class BugReportController: UIViewController {
    let resonTitle: UITextField = {
        let tf = UITextField()
        tf.text = "Found a bug? Tell us about it"
        tf.font = .systemFont(ofSize: 20)
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isUserInteractionEnabled = false
        return tf
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
        if reportTextView.text != "" {
            let uid = Auth.auth().currentUser?.uid
            let timestamp = Int(NSDate().timeIntervalSince1970)
            var values = ["timestamp": timestamp, "reportMessage": reportTextView.text] as [String : Any]
            let ref = Database.database().reference().child("bug-reports").child(uid!)
            ref.updateChildValues(values)
            let alert = UIAlertController(title: "Report was sent", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.goBack() }))
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Notice", message: "Please describe a bug", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            resonTitle.textColor = CustomColors.lightOrange1
        }
    }
    func reportElementsSetup(){
        view.addSubview(resonTitle)
        view.addSubview(messageTitle)
        view.addSubview(reportTextView)
        view.addSubview(sendButton)
        
        resonTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resonTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        resonTitle.widthAnchor.constraint(equalToConstant: 280).isActive = true
        resonTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        messageTitle.centerXAnchor.constraint(equalTo:  view.centerXAnchor).isActive = true
        messageTitle.topAnchor.constraint(equalTo: resonTitle.bottomAnchor).isActive = true
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
        self.navigationItem.title = "Report bug"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.setupHideKeyboardOnTap()
        reportElementsSetup()
        setupNavBarItems()
    }
    
}
