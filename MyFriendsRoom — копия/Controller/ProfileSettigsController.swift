//
//  ProfileSettigsController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 29.09.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation
import GooglePlaces

class ProfileSettingsController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, UITextViewDelegate{
    let aboutServicesPlaceholder = "tell us about your service"
    let aboutMePlaceholder = "tell us about yourself"
    let aboutMyPlacePlaceholder = "tell us about your place"
    var acSelection = Int()
    var youAreBanned = false
    var adresesArray = [GMSAutocompletePrediction]()
    var aboutServicesEnabled = false
    
//    var currentSettings = [String: Any]()
    lazy var filter: GMSAutocompleteFilter = {
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        return filter
    }()
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor.white
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.layer.masksToBounds = true
        return sv
    }()
    let settingsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let profileTitle: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.lightOrange1
        tt.text = "My profile"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 25)
        return tt
    }()
    let nameTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Name"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "what is your name?", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
   let nameSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    let ageTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Age"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    let ageTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "how old are you?", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = UIKeyboardType.decimalPad
        return tf
    }()
    let ageSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let whatDYDTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "What do you do?"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    let whatDYDTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "...", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = "..."
        return tf
    }()
    let whatDYDSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let emailTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Email"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    let emailCHANGEButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CHANGE", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(CustomColors.commonBlue1, for: [])
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(emailChangeButtonAction), for: .touchUpInside)
        return button
    }()
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "enter your email...", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.keyboardType = UIKeyboardType.emailAddress
        tf.isUserInteractionEnabled = false
        return tf
    }()
    let emailSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Change password", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(CustomColors.commonBlue1, for: [])
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(changePasswordButtonAction), for: .touchUpInside)
        return button
    }()
    let usernameTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Username"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "enter your username...", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = UIKeyboardType.emailAddress
        tf.isUserInteractionEnabled = true
        return tf
    }()
    let usernameSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
//    let aboutMeEDITButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("EDIT", for: [])
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitleColor(CustomColors.commonBlue1, for: [])
//        button.layer.masksToBounds = true
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
//        button.addTarget(self, action: #selector(aboutMeEDITButtonAction), for: .touchUpInside)
//        return button
//    }()
    let aboutMeTextView: UITextView = {
        let tt = UITextView()
        tt.text = "tell us about yourself"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.textColor = CustomColors.commonGrey1
//        tt.isUserInteractionEnabled = false
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
//    let aboutMyPlaceEDITButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("EDIT", for: [])
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitleColor(CustomColors.commonBlue1, for: [])
//        button.layer.masksToBounds = true
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
//        button.addTarget(self, action: #selector(aboutMyPlaceEDITButtonAction), for: .touchUpInside)
//        return button
//    }()
    let aboutMyPlaceTextView: UITextView = {
        let tt = UITextView()
        tt.text = "tell us about your place"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.textColor = CustomColors.commonGrey1
//        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 15)
        return tt
    }()
    let offerAService: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(offerAServiceCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  Offer a local service", size: 16, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    let aboutMyServicesTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "About my service"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .boldSystemFont(ofSize: 16)
        return tt
    }()
    let aboutServicesTextView: UITextView = {
        let tt = UITextView()
        tt.text = "tell us about your service"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.textColor = CustomColors.commonGrey1
        tt.font = .systemFont(ofSize: 15)
        return tt
    }()
    let myProfilePhotosTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.lightOrange1
        tt.text = "My profile pics"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .boldSystemFont(ofSize: 17)
        return tt
    }()
    let myProfilePhotosEDITButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("EDIT", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(CustomColors.commonBlue1, for: [])
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(myProfilePhotosEDITButtonAction), for: .touchUpInside)
        return button
    }()
    let myPhotosTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.lightOrange1
        tt.text = "Pics of my place"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .boldSystemFont(ofSize: 17)
        return tt
    }()
    let myPhotosEDITButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("EDIT", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(CustomColors.commonBlue1, for: [])
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(myPhotosEDITButtonAction), for: .touchUpInside)
        return button
    }()
    let searchSettingsTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "My search settings"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .boldSystemFont(ofSize: 16)
        return tt
    }()
    let searchLocTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Search location"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .boldSystemFont(ofSize: 16)
        return tt
    }()
    let searchLocTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "where to search", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(goAC), for: UIControlEvents.editingDidBegin)
        return tf
    }()
    let searchLocSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let currentLocTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Current location (auto)"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .boldSystemFont(ofSize: 16)
        return tt
    }()
    let curentLocTextView: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.placeholder = "disabled"
        return tt
    }()
    let locTextTitle: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Home or Travel location\n(closest big city)"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .boldSystemFont(ofSize: 16)
        return tt
    }()
    let locTextDescr: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Change your location when you travel, so people can find you in search"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 12)
        return tt
    }()
    let locTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "where is your home?", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(goAC2), for: UIControlEvents.editingDidBegin)
        return tf
    }()
    let locSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let myHomeSettingsTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "My home settings"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .boldSystemFont(ofSize: 16)
        return tt
    }()
    let agYesCheckboxButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(agYesCheck), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  accepting guests", size: 16, forState: .normal)
        tcb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return tcb
    }()
    let agMaybeCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(agMaybeCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  maybe accepting guests", size: 16, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    let agNoCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(agNoCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  not accepting guests", size: 16, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    let meetCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(meetCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  to meet up with people", size: 16, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    let dateCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(dateCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  to date", size: 16, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    let myTravelSettingsTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "My travel settings"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .boldSystemFont(ofSize: 19)
        return tt
    }()
    let search_travelCheckboxButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(search_travelCheck), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  travel accommodation", size: 16, forState: .normal)
        tcb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return tcb
    }()
    let search_meetCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(search_meetCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  to meet up with people", size: 16, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    let search_dateCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(search_dateCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  to date", size: 16, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    var saveSettingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Save settings", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(CustomColors.commonBlue1, for: [])
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(saveSettings), for: .touchUpInside)
        return button
    }()
    var deleteAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Delete account", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(CustomColors.commonBlue1, for: [])
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        return button
    }()
    var bugReportButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Bug report", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(CustomColors.commonBlue1, for: [])
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(goToBugReportController), for: .touchUpInside)
        return button
    }()
    @objc func goToBugReportController(){
        let bugReportController = BugReportController()
        let navController = UINavigationController(rootViewController: bugReportController)
        present(navController, animated: true, completion: nil)
    }
    var offerServiseChecked = false
    @objc func offerAServiceCheck(){
        var color = UIColor()
        
        aboutServicesTextViewHeightAnchor?.isActive = false
        aboutServicesTextTitleTopAnchor?.isActive = false
        aboutServicesTextTitleHeightAnchor?.isActive = false
        aboutServicesTextViewTopAnchor?.isActive = false
        if offerServiseChecked == true {
            color = CustomColors.commonBlue1
            offerServiseChecked = false
            aboutServicesTextTitleTopAnchor = aboutMyServicesTextTitle.topAnchor.constraint(equalTo: offerAService.bottomAnchor, constant: 0)
            aboutServicesTextTitleHeightAnchor = aboutMyServicesTextTitle.heightAnchor.constraint(equalToConstant: 0)
            aboutServicesTextViewTopAnchor = aboutServicesTextView.topAnchor.constraint(equalTo: aboutMyServicesTextTitle.bottomAnchor, constant: 0)
            aboutServicesTextViewHeightAnchor = aboutServicesTextView.heightAnchor.constraint(equalToConstant: 0)
        } else {
            color = CustomColors.lightOrange1
            offerServiseChecked = true
            aboutServicesTextTitleTopAnchor = aboutMyServicesTextTitle.topAnchor.constraint(equalTo: offerAService.bottomAnchor, constant: 10)
            aboutServicesTextTitleHeightAnchor = aboutMyServicesTextTitle.heightAnchor.constraint(equalToConstant: 23)
            aboutServicesTextViewTopAnchor = aboutServicesTextView.topAnchor.constraint(equalTo: aboutMyServicesTextTitle.bottomAnchor, constant: 3)
            if aboutServicesTextView.text != nil && aboutServicesTextView.text != "" {
                let height3 = self.estimateFrameForText(text: aboutServicesTextView.text!).height + 30
                aboutServicesTextViewHeightAnchor = aboutServicesTextView.heightAnchor.constraint(equalToConstant: height3)
            } else {
                aboutServicesTextView.text! = aboutServicesPlaceholder
                aboutServicesTextViewHeightAnchor = aboutServicesTextView.heightAnchor.constraint(equalToConstant: 23)
            }
        }
        offerAService.setFATitleColor(color: color, forState: .normal)
        aboutServicesTextViewHeightAnchor?.isActive = true
        aboutServicesTextTitleTopAnchor?.isActive = true
        aboutServicesTextTitleHeightAnchor?.isActive = true
        aboutServicesTextViewTopAnchor?.isActive = true
        
    }
    
    
    @objc func emailChangeButtonAction(){
//        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
//            // ...
//        }
        let alert = UIAlertController(title: "Please enter your new email", message:  nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { email in
            email.placeholder = "Input your password here..."
        })
        alert.addTextField(configurationHandler: { email in
            email.placeholder = "Input your new email here..."
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let user = Auth.auth().currentUser
            let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: (alert.textFields?.first?.text)!)
            user?.reauthenticate(with: credential) { error in
                if error == nil {
                    Auth.auth().currentUser?.updateEmail(to: (alert.textFields?.last?.text)!) { (error) in
                        var title: String?
                        var message: String?
                        if error == nil {
                            title = "Success"
                            message = "Your email was changed"
                            let newEmail = alert.textFields?.last?.text
                            self.emailTextField.text = newEmail
                            let uid = Auth.auth().currentUser?.uid
                            let ref = Database.database().reference().child("users").child(uid!).child("email")
                            ref.setValue(newEmail)
                        } else {
                            title = "Error"
                            message = error?.localizedDescription
                        }
                        let alert2 = UIAlertController(title: title, message:  message, preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert2, animated: true)
                    }
                } else {
                    let alert2 = UIAlertController(title: "Error", message:  error?.localizedDescription, preferredStyle: .alert)
                    alert2.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert2, animated: true)
                }
            }
        }))
        alert.textFields![0].isSecureTextEntry = true
        alert.textFields?.last?.keyboardType = UIKeyboardType.emailAddress
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    @objc func changePasswordButtonAction(){
        
        let alert1 = UIAlertController(title: "Password change", message:  "Enter your old and new password below", preferredStyle: .alert)
        alert1.addTextField(configurationHandler: { password in
            password.placeholder = "Old passwprd..."
        })
        alert1.addTextField(configurationHandler: { password in
            password.placeholder = "New passwprd..."
        })
        alert1.addTextField(configurationHandler: { password in
            password.placeholder = "Repeat it..."
        })
        alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if alert1.textFields![1].text == alert1.textFields?.last?.text {
                
                let user = Auth.auth().currentUser
                let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: (alert1.textFields?.first?.text)!)
                user?.reauthenticate(with: credential) { error in
                    if error == nil {
                        Auth.auth().currentUser?.updatePassword(to: (alert1.textFields?.last?.text)!) { (error) in
                            var title: String?
                            var message: String?
                            if error == nil {
                                title = "Success"
                                message = "Your password was changed"
                            } else {
                                title = "Error"
                                message = error?.localizedDescription
                            }
                            let alert2 = UIAlertController(title: title, message:  message, preferredStyle: .alert)
                            alert2.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert2, animated: true)
                        }
                    } else {
                        let alert2 = UIAlertController(title: "Error", message:  error?.localizedDescription, preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert2, animated: true)
                    }
                }
                
            } else {
                let alert2 = UIAlertController(title: "Passwords does non match", message:  nil, preferredStyle: .alert)
                alert2.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert2, animated: true)
            }
        }))
        alert1.textFields![0].isSecureTextEntry = true
        alert1.textFields![1].isSecureTextEntry = true
        alert1.textFields![2].isSecureTextEntry = true
        alert1.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert1, animated: true)
    }
    
    @objc func deleteAccount() {
        let alert = UIAlertController(title: "Do you realy want to delete your account?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {action in
            let alert = UIAlertController(title: "Are you sure?", message: "It can be restored by signing in again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {action in
                let uid = Auth.auth().currentUser?.uid
                let ref = Database.database().reference().child("users").child(uid!)
                ref.observeSingleEvent(of: .value) { (snap) in
                    guard let value = snap.value as? [String: Any] else {return}
                    let currentAvatar = value["profileImageUrl"] as! String
                    let currentHomeLocation = value["loc"] as! String
                    let archiveArray = ["arcProfileImageUrl": currentAvatar, "arcLoc": currentHomeLocation, "profileImageUrl": "deleted", "loc": "deleted", "wasDeleted": "bySelf"] as [String: Any]
                    ref.updateChildValues(archiveArray)
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
                }
            }))
            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
            self.present(alert, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
//    var aboutMeEDITButtonTapped = false, aboutMyPlaceEDITButtonTapped = false
//    @objc func aboutMeEDITButtonAction(){
//        if aboutMeEDITButtonTapped == false {
//            aboutMeEDITButtonTapped = true
//            aboutMeTextView.delegate = self
//            aboutMeTextView.isUserInteractionEnabled = true
//            aboutMeTextView.backgroundColor = CustomColors.lightBlue1
//            aboutMeEDITButton.setTitle("SAVE", for: [])
//            aboutMeTextView.textColor = CustomColors.commonBlue1
//        } else {
//            aboutMeEDITButtonTapped = false
//            aboutMeTextView.isUserInteractionEnabled = false
//            aboutMeTextView.backgroundColor = UIColor.white
//            aboutMeEDITButton.setTitle("EDIT", for: [])
//            aboutMeTextView.textColor = CustomColors.commonGrey1
//        }
//    }
//    @objc func aboutMyPlaceEDITButtonAction(){
//        if aboutMyPlaceEDITButtonTapped == false {
//            aboutMyPlaceEDITButtonTapped = true
//            aboutMyPlaceTextView.isUserInteractionEnabled = true
//            aboutMyPlaceTextView.backgroundColor = CustomColors.lightBlue1
//            aboutMyPlaceEDITButton.setTitle("SAVE", for: [])
//            aboutMyPlaceTextView.textColor = CustomColors.commonBlue1
//        } else {
//            aboutMyPlaceEDITButtonTapped = false
//            aboutMyPlaceTextView.isUserInteractionEnabled = false
//            aboutMyPlaceTextView.backgroundColor = UIColor.white
//            aboutMyPlaceEDITButton.setTitle("EDIT", for: [])
//            aboutMyPlaceTextView.textColor = CustomColors.commonGrey1
//        }
//    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        var placeholder: String?
        if textView == aboutMyPlaceTextView {
            placeholder = aboutMyPlacePlaceholder
        } else if textView ==  aboutServicesTextView {
            placeholder = aboutServicesPlaceholder
        } else if textView ==  aboutMeTextView {
            placeholder = aboutMePlaceholder
        }
        if textView.textColor == CustomColors.commonGrey1 {
            if textView.text == placeholder{
                textView.text = nil
            }
            textView.textColor = CustomColors.commonBlue1
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        var placeholder: String?
        if textView == aboutMyPlaceTextView {
            placeholder = aboutMyPlacePlaceholder
        } else if textView ==  aboutServicesTextView {
            placeholder = aboutServicesPlaceholder
        } else if textView ==  aboutMeTextView {
            placeholder = aboutMePlaceholder
        }
        if textView.text.isEmpty {
            textView.text = placeholder
        }
        textView.textColor = CustomColors.commonGrey1
    }
    func textViewDidChange(_ textView: UITextView){
        if textView == aboutMeTextView {
            self.aboutMeTextViewHeightAnchor?.isActive  = false
            if self.aboutMeTextView.text != "" {
                let height1 = self.estimateFrameForText(text: self.aboutMeTextView.text!).height + 25
                self.aboutMeTextViewHeightAnchor = self.aboutMeTextView.heightAnchor.constraint(equalToConstant: height1)
            }
            self.aboutMeTextViewHeightAnchor?.isActive  = true
        } else if textView == aboutMyPlaceTextView{
            self.aboutMyPlaceTextViewHeightAnchor?.isActive  = false
            if self.aboutMyPlaceTextView.text != "" {
                let height2 = self.estimateFrameForText(text: self.aboutMyPlaceTextView.text!).height + 25
                self.aboutMyPlaceTextViewHeightAnchor = self.aboutMyPlaceTextView.heightAnchor.constraint(equalToConstant: height2)
            }
            self.aboutMyPlaceTextViewHeightAnchor?.isActive  = true
        } else if textView == aboutServicesTextView{
            self.aboutServicesTextViewHeightAnchor?.isActive  = false
            if self.aboutServicesTextView.text != "" {
                let height3 = self.estimateFrameForText(text: self.aboutServicesTextView.text!).height + 25
                self.aboutServicesTextViewHeightAnchor = self.aboutServicesTextView.heightAnchor.constraint(equalToConstant: height3)
            }
            self.aboutServicesTextViewHeightAnchor?.isActive  = true
        }
    }
    var editingIsOk = true
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        var itIsOk: Bool
        let len = textView.text.count
        var limit = 0
        if textView == aboutMeTextView {
            limit = 500
        } else if textView == aboutMyPlaceTextView || textView == aboutServicesTextView{
            limit = 1500
        }
        if len > limit {
            itIsOk = false
            let alert = UIAlertController(title: "Notice", message: "Text can not be longer then \(limit) letters\nNow is \(len)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            itIsOk = true
        }
        editingIsOk = itIsOk
        return itIsOk
    }
    @objc func myProfilePhotosEDITButtonAction(){
        let userProfilePhotosController = UserProfilePhotosController()
        let userProfilePhotosControllerNav = UINavigationController(rootViewController: userProfilePhotosController)
        self.present(userProfilePhotosControllerNav, animated: true, completion: nil)
    }
    @objc func myPhotosEDITButtonAction(){
        let userPhotosController = UserPhotosController()
        let userPhotosControllerNav = UINavigationController(rootViewController: userPhotosController)
        self.present(userPhotosControllerNav, animated: true, completion: nil)
    }
    var acceptingGuests = ""
    @objc func agYesCheck(){
        checkIfYouAreBanned()
        agYesCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        agNoCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        agMaybeCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        acceptingGuests = "yes"
    }
    @objc func agNoCheck(){
        checkIfYouAreBanned()
        agYesCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        agNoCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        agMaybeCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        acceptingGuests = "no"
    }
    @objc func agMaybeCheck(){
        checkIfYouAreBanned()
        agYesCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        agNoCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        agMaybeCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        acceptingGuests = "maybe"
        
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

    var meetChecked = false, dateChecked = false
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
    var search_travelChecked = false, search_meetChecked = false, search_dateChecked = false
    @objc func search_travelCheck(){
        var color = UIColor()
        if search_travelChecked == true {
            color = CustomColors.commonBlue1
            search_travelChecked = false
        } else {
            color = CustomColors.lightOrange1
            search_travelChecked = true
        }
        search_travelCheckboxButton.setFATitleColor(color: color, forState: .normal)
    }
    @objc func search_meetCheck(){
        var color = UIColor()
        if search_meetChecked == true {
            color = CustomColors.commonBlue1
            search_meetChecked = false
        } else {
            color = CustomColors.lightOrange1
            search_meetChecked = true
        }
        search_meetCheckboxButton.setFATitleColor(color: color, forState: .normal)
    }
    @objc func search_dateCheck(){
        var color = UIColor()
        if search_dateChecked == true {
            color = CustomColors.commonBlue1
            search_dateChecked = false
        } else {
            color = CustomColors.lightOrange1
            search_dateChecked = true
        }
        search_dateCheckboxButton.setFATitleColor(color: color, forState: .normal)
    }
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        var result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        var isOk = false
        var attention: String?
        if textField == nameTextField {
            if nameTextField.text == "" {
                isOk = false
                attention = "Name is required"
            } else if nameTextField.text == "DELETED" {
                isOk = false
                attention = "Name can not be \"DELETED\""
            } else {
                isOk = true
            }
        } else if textField == ageTextField {
//            if ageTextField.text == "" {
//                attention = "Age is required"
//                isOk = false
//            } else if Int(ageTextField.text!) == nil {
            if Int(ageTextField.text!) == nil {
                attention = "Age can be only numerical"
                isOk = false
            }  else if Int(ageTextField.text!)! < 18 {
                attention = "Age can not be less than 18"
                isOk = false
            } else if Int(ageTextField.text!)! > 100 {
                attention = "Age can not be more than 100"
                isOk = false
            } else {
                isOk = true
            }
        } else if textField == emailTextField {
            if isValidEmail(testStr: emailTextField.text!) {
                isOk = true
            } else {
                attention = "Email is not valid"
                isOk = false
            }
        } else if textField == usernameTextField {
            if self.isValidUsername(testStr: self.usernameTextField.text!) &&  self.usernameTextField.text?.count != 0{
                //
            } else if self.usernameTextField.text?.count == 0 {
                //
            } else {
                attention = "Username is not valid"
            }
            isOk = true
        }
        if isOk == false {
            let alert = UIAlertController(title: "Notice", message: attention, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        editingIsOk = isOk
        return isOk
    }
    @objc func saveSettings(){
        if editingIsOk {
            checkIfYouAreBanned()
            var nameIsOk = false
            var ageIsOk = false
            var emailIsOk = false
            var usernameIsOk = true
            var usernameIsValid = false
            let uid = Auth.auth().currentUser!.uid
            if self.nameTextField.text == "" || self.nameTextField.text == "DELETED" {
                self.nameTextTitle.textColor = CustomColors.lightOrange1
                nameIsOk = false
            } else {
                self.nameTextTitle.textColor = CustomColors.commonGrey1
                nameIsOk = true
                print("nameTextField.text", self.nameTextField.text)
            }
            if isValidEmail(testStr: emailTextField.text!) {
                emailTextTitle.textColor = CustomColors.commonGrey1
                emailIsOk = true
                
            } else {
                emailTextTitle.textColor = CustomColors.lightOrange1
                emailIsOk = false
                
            }
            
            if self.ageTextField.text != "" {
                if Int(self.ageTextField.text!)! < 18 || Int(self.ageTextField.text!)! > 100 {
                    self.ageTextTitle.textColor = CustomColors.lightOrange1
                    ageIsOk = false
                } else {
                    self.ageTextTitle.textColor = CustomColors.commonGrey1
                    ageIsOk = true
                }
            } else {
                self.ageTextTitle.textColor = CustomColors.commonGrey1
                ageIsOk = true
            }///matchExists
//            if self.self.ageTextField.text == "" || Int(self.ageTextField.text!)! < 18 || Int(self.ageTextField.text!)! > 100 {
//                self.ageTextTitle.textColor = CustomColors.lightOrange1
//                ageIsOk = false
//            } else {
//                self.ageTextTitle.textColor = CustomColors.commonGrey1
//                ageIsOk = true
//            }///matchExists
            if self.usernameTextField.text! != ""{
                if self.isValidUsername(testStr: self.usernameTextField.text!){//} &&  self.usernameTextField.text?.count != 0{
                    //        if self.matchExists(for: "[a-z0-9]+[_-]+[0-9a-z]{1,}", in: self.usernameTextField.text!) &&  self.usernameTextField.text?.count != 0{
                    self.emailTextTitle.textColor = CustomColors.commonGrey1
                    usernameIsValid = true
                } else {
                    self.emailTextTitle.textColor = CustomColors.lightOrange1
                    usernameIsValid = false
                }
            } else {
                self.emailTextTitle.textColor = CustomColors.commonGrey1
                usernameIsValid = true
            }
//            if self.isValidUsername(testStr: self.usernameTextField.text!){//} &&  self.usernameTextField.text?.count != 0{
//                //        if self.matchExists(for: "[a-z0-9]+[_-]+[0-9a-z]{1,}", in: self.usernameTextField.text!) &&  self.usernameTextField.text?.count != 0{
//                self.emailTextTitle.textColor = CustomColors.commonGrey1
//                usernameIsValid = true
//
//            } else {
//                self.emailTextTitle.textColor = CustomColors.lightOrange1
//                usernameIsValid = false
//            }
            var myCurrentUsername = String()
            var resultUsername = String()
            let ref = Database.database().reference().child("users")
            let myUsernameRef = ref.child(uid).child("username")//Database.database().reference().child("users").queryOrdered(byChild: "username").queryEqual(toValue: usernameTextField.text)
            let query = Database.database().reference().child("users").queryOrdered(byChild: "username").queryEqual(toValue: usernameTextField.text)//ref.queryOrdered(byChild: "username").queryEqual(toValue: usernameTextField.text)
            myUsernameRef.observeSingleEvent(of: .value) { (mySnap) in
                let mySnapVal = mySnap.value
                let typus = type(of: mySnapVal!)
                if  typus != NSNull.self{
                    print("mySnap.val", mySnap)
                    myCurrentUsername = mySnapVal as! String
                }
                query.observeSingleEvent(of: .value) { (snap) in
                    print("username snap \n", snap)
                    for child in snap.children.allObjects as! [DataSnapshot] {
                        usernameIsOk = false
                        let foundResult = child.value as? [String: Any]
                        resultUsername = foundResult!["username"] as! String
                        print("foundResult: ", resultUsername)
                    }
                    if myCurrentUsername == resultUsername {
                        usernameIsOk = true
                    }
                    if nameIsOk == true && ageIsOk == true && emailIsOk == true && usernameIsOk == true && usernameIsValid == true {
                        guard let email = self.emailTextField.text, let name = self.nameTextField.text, let age = self.ageTextField.text, let loc = self.locTextField.text, let occupation = self.whatDYDTextField.text, let acceptingGuests = self.acceptingGuests as String?, let meetChecked = self.meetChecked as Bool?, let dateChecked = self.dateChecked as Bool?, let search_travelChecked = self.search_travelChecked as Bool?, let search_meetChecked = self.search_meetChecked as Bool?, let search_dateChecked = self.search_dateChecked as Bool?, let search_loc = self.searchLocTextField.text,/* let currentLoc = self.curentLocTextView.text, */let username = self.usernameTextField.text, var aboutMe = self.aboutMeTextView.text as String?, var aboutMyPlace = self.aboutMyPlaceTextView.text as String?, var aboutServices = self.aboutServicesTextView.text
                            else {
                                print("Form is not valid")
                                return
                        }
                        
                        if aboutMe == self.aboutMePlaceholder{
                            aboutMe = ""//"hello i am Emily"
                        }
                        if aboutMyPlace == self.aboutMyPlacePlaceholder{
                            aboutMyPlace = ""//"It is nice small apartment"
                        }
                        if aboutServices == self.aboutServicesPlaceholder{
                            aboutServices = ""
                        }
                        //aboutServicesPlaceholder aboutMePlaceholder aboutMyPlacePlaceholder
                        self.usernameTextTitle.textColor = CustomColors.commonGrey1
                        var values = [String:Any]()
                        if username != ""{
                            values = ["name": name, "email": email, "age": age, "loc": loc, "occupation": occupation, "acceptingGuests": acceptingGuests, "meetChecked": meetChecked, "dateChecked": dateChecked, "travelChecked": search_travelChecked, "searchMeetChecked": search_meetChecked, "searchDateChecked": search_dateChecked, "searchLoc": search_loc,/* "currentLoc": currentLoc, */"username": username, "aboutMe": aboutMe, "aboutMyPlace": aboutMyPlace, "aboutServices": aboutServices, "offerServiseChecked": self.offerServiseChecked] as [String : Any]
                        } else {
                            values = ["name": name, "email": email, "age": age, "loc": loc, "occupation": occupation, "acceptingGuests": acceptingGuests, "meetChecked": meetChecked, "dateChecked": dateChecked, "travelChecked": search_travelChecked, "searchMeetChecked": search_meetChecked, "searchDateChecked": search_dateChecked, "searchLoc": search_loc,/* "currentLoc": currentLoc,*/ "aboutMe": aboutMe, "aboutMyPlace": aboutMyPlace, "aboutServices": aboutServices, "offerServiseChecked": self.offerServiseChecked] as [String : Any]
                        }
//                        let values = ["name": name, "email": email, "age": age, "loc": loc, "occupation": occupation, "acceptingGuests": acceptingGuests, "meetChecked": meetChecked, "dateChecked": dateChecked, "travelChecked": search_travelChecked, "searchMeetChecked": search_meetChecked, "searchDateChecked": search_dateChecked, "searchLoc": search_loc, "currentLoc": currentLoc, "username": username, "aboutMe": aboutMe, "aboutMyPlace": aboutMyPlace, "aboutServices": aboutServices, "offerServiseChecked": self.offerServiseChecked] as [String : Any]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                    } else if  usernameIsOk == false {
                        self.usernameTextTitle.textColor = CustomColors.lightOrange1
                        let alert = UIAlertController(title: "Notice", message: "This username is already in use", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    } else if usernameIsValid != true {
                        let alert = UIAlertController(title: "Notice", message: "Username is not valid\nExample: Abc_Abc123", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Notice", message: "Please check and make sure all the fields are filled correctly", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
        
        
//        if nameTextField.text == "" || nameTextField.text == "DELETED" {
//            nameTextTitle.textColor = CustomColors.lightOrange1
//            nameIsOk = false
//        } else {
//            nameTextTitle.textColor = CustomColors.commonGrey1
//            nameIsOk = true
//            print("nameTextField.text", nameTextField.text)
//        }
//        
//        if ageTextField.text == "" || Int(ageTextField.text!)! < 18 || Int(ageTextField.text!)! > 100 {
//            ageTextTitle.textColor = CustomColors.lightOrange1
//            ageIsOk = false
//        } else {
//            ageTextTitle.textColor = CustomColors.commonGrey1
//            ageIsOk = true
//        }
//        if isValidEmail(testStr: emailTextField.text!) {
//            emailTextTitle.textColor = CustomColors.commonGrey1
//            emailIsOk = true
//            
//        } else {
//            emailTextTitle.textColor = CustomColors.lightOrange1
//            emailIsOk = false
//            
//        }
//        if nameIsOk == true && ageIsOk == true && emailIsOk == true {
//            guard let email = emailTextField.text, let name = nameTextField.text, let age = ageTextField.text, let loc = locTextField.text, let occupation = whatDYDTextField.text, let acceptingGuests = acceptingGuests as String?, let meetChecked = meetChecked as Bool?, let dateChecked = dateChecked as Bool?, let search_travelChecked = search_travelChecked as Bool?, let search_meetChecked = search_meetChecked as Bool?, let search_dateChecked = search_dateChecked as Bool?, let aboutMe = aboutMeTextView.text as String?, let aboutMyPlace = aboutMyPlaceTextView.text as String?, let search_loc = searchLocTextField.text, let currentLoc = curentLocTextView.text, let username = usernameTextField.text
//                else {
//                    print("Form is not valid")
//                    return
//            }
//            let uid = Auth.auth().currentUser!.uid
//            let values = ["name": name, "email": email, "age": age, "loc": loc, "occupation": occupation, "acceptingGuests": acceptingGuests, "meetChecked": meetChecked, "dateChecked": dateChecked, "travelChecked": search_travelChecked, "searchMeetChecked": search_meetChecked, "searchDateChecked": search_dateChecked, "aboutMe": aboutMe, "aboutMyPlace": aboutMyPlace, "searchLoc": search_loc, "currentLoc": currentLoc, "username": username] as [String : Any]
//            self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
//        } else {
//            let alert = UIAlertController(title: "Notice", message: "Please check and make sure all the fields are filled correctly", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true)
//        }
        
    }
    func isValidUsername(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let usernameRegEx = "^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$"
//        var usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
//        var result = usernameTest.evaluate(with: testStr)
        let Test = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        print("111 ", Test)
        print("222 ", testStr)
        return Test.evaluate(with: testStr)
//        return result
    }
//    func matchExists(for regex: String, in text: String) -> Bool {
//        return matches(for: regex, in: text).count > 0
//    }
//    func matches(for regex: String, in text: String) -> [String] {
//        do {
//            let regex = try NSRegularExpression(pattern: regex)
//            let results = regex.matches(in: text,
//                                        range: NSRange(text.startIndex..., in: text))
//            let finalResult = results.map {
//                String(text[Range($0.range, in: text)!])
//            }
//            return finalResult
//        } catch let error {
//            print("invalid regex: \(error.localizedDescription)")
//            return []
//        }
//    }
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        let ref = Database.database().reference(fromURL: "https://myfriendsroomtest.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
//            if self.curentLocTextView.text?.count == 0 {
//                usersReference.child("currentLoc").removeValue()
//            }
//            self.dismiss(animated: true, completion: nil)
            let alert = UIAlertController(title: "Settings saved", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadMyProfile"), object: nil)
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            
        })
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let width = scrollView.frame.width - 100
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)], context: nil)
    }
    func getCurentSettings(){
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("users").child(uid)
        ref.observe(.value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            
//            let email = value["email"] as? String
//            let name = value["name"] as? String
//            let age = value["age"] as? String
//            let loc = value["loc"] as? String
//            let occupation = value["occupation"] as? String
//            let acceptingGuests = value["acceptingGuests"] as? String
//            let meetChecked = value["meetChecked"] as? Bool
//            let dateChecked = value["dateChecked"] as? Bool
//            let travelChecked = value["travelChecked"] as? Bool
//            let aboutMe = value["aboutMe"] as? String
//            let aboutMyPlace = value["aboutMyPlace"] as? String
//            let search_loc = value["searchLoc"] as? String
//            let currentLoc = value["currentLoc"] as? String
//            let username = value["username"] as? String
//            self.currentSettings = ["name": name, "email": email, "age": age, "loc": loc, "occupation": occupation, "acceptingGuests": acceptingGuests, "meetChecked": meetChecked, "dateChecked": dateChecked, "travelChecked": travelChecked, "aboutMe": aboutMe, "aboutMyPlace": aboutMyPlace, "searchLoc": search_loc, "currentLoc": currentLoc, "username": username]
            if value["travelChecked"] != nil {
                self.search_travelChecked = value["travelChecked"] as! Bool
            }
            if value["aboutServicesEnabled"] != nil {
                self.aboutServicesEnabled = value["aboutServicesEnabled"] as! Bool
                if value["aboutServices"] != nil && value["aboutServices"] as? String != "" {
                    self.aboutServicesTextView.text = value["aboutServices"] as! String
                } else {
                    self.aboutServicesTextView.text! = self.aboutServicesPlaceholder
                }
            }
            
            if value["offerServiseChecked"] != nil {
                self.offerServiseChecked = value["offerServiseChecked"] as! Bool
                if self.offerServiseChecked {
                    self.offerAService.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
                }
            }
            
            
            self.offerAServicetopAnchor?.isActive = false
            self.offerAServiceheightAnchor?.isActive = false
            self.aboutServicesTextViewHeightAnchor?.isActive = false
            self.aboutServicesTextTitleTopAnchor?.isActive = false
            self.aboutServicesTextTitleHeightAnchor?.isActive = false
            self.aboutServicesTextViewTopAnchor?.isActive = false
            if self.aboutServicesEnabled {
                self.offerAServicetopAnchor = self.offerAService.topAnchor.constraint(equalTo: self.aboutMyPlaceTextView.bottomAnchor, constant: 20)
                self.offerAServiceheightAnchor = self.offerAService.heightAnchor.constraint(equalToConstant: 30)
            } else {
                self.offerAServicetopAnchor = self.offerAService.topAnchor.constraint(equalTo: self.self.aboutMyPlaceTextView.bottomAnchor, constant: 0)
                self.offerAServiceheightAnchor = self.offerAService.heightAnchor.constraint(equalToConstant: 0)
            }
            if self.aboutServicesEnabled && self.offerServiseChecked {
                
                self.aboutServicesTextTitleTopAnchor = self.aboutMyServicesTextTitle.topAnchor.constraint(equalTo: self.offerAService.bottomAnchor, constant: 10)
                self.aboutServicesTextTitleHeightAnchor = self.aboutMyServicesTextTitle.heightAnchor.constraint(equalToConstant: 23)
                self.aboutServicesTextViewTopAnchor = self.aboutServicesTextView.topAnchor.constraint(equalTo: self.aboutMyServicesTextTitle.bottomAnchor, constant: 3)
                if value["aboutServices"] != nil && value["aboutServices"] as? String != "" {
//                    self.aboutServicesTextView.text! = value["aboutServices"] as! String
                    let height3 = self.estimateFrameForText(text: self.aboutServicesTextView.text!).height + 30
                    self.aboutServicesTextViewHeightAnchor = self.aboutServicesTextView.heightAnchor.constraint(equalToConstant: height3)
                } else {
//                    self.aboutServicesTextView.text! = self.aboutServicesPlaceholder
                    self.aboutServicesTextViewHeightAnchor = self.aboutServicesTextView.heightAnchor.constraint(equalToConstant: 23)
                }
            } else {
                self.aboutServicesTextTitleTopAnchor = self.aboutMyServicesTextTitle.topAnchor.constraint(equalTo: self.offerAService.bottomAnchor, constant: 0)
                self.aboutServicesTextTitleHeightAnchor = self.aboutMyServicesTextTitle.heightAnchor.constraint(equalToConstant: 0)
                self.aboutServicesTextViewTopAnchor = self.aboutServicesTextView.topAnchor.constraint(equalTo: self.aboutMyServicesTextTitle.bottomAnchor, constant: 0)
                self.aboutServicesTextViewHeightAnchor = self.aboutServicesTextView.heightAnchor.constraint(equalToConstant: 0)
            }
            self.aboutServicesTextViewHeightAnchor?.isActive = true
            self.aboutServicesTextTitleTopAnchor?.isActive = true
            self.aboutServicesTextTitleHeightAnchor?.isActive = true
            self.aboutServicesTextViewTopAnchor?.isActive = true
            self.offerAServicetopAnchor?.isActive = true
            self.offerAServiceheightAnchor?.isActive = true
            if value["username"] != nil {
                self.usernameTextField.text = value["username"] as! String
            }
            if value["searchMeetChecked"] != nil {
                self.search_meetChecked = value["searchMeetChecked"] as! Bool
            }
            if value["searchDateChecked"] != nil {
                self.search_dateChecked = value["searchDateChecked"] as! Bool
            }
            if value["currentLoc"] != nil {
                self.curentLocTextView.text = value["currentLoc"] as! String
            }
            self.nameTextField.text = value["name"] as? String
            self.ageTextField.text = value["age"] as? String
            self.emailTextField.text = Auth.auth().currentUser?.email//value["email"] as? String
            self.whatDYDTextField.text = value["occupation"] as? String
            self.locTextField.text = value["loc"] as? String
            if value["acceptingGuests"] != nil {
                self.acceptingGuests = value["acceptingGuests"] as! String
            }
            if value["meetChecked"] != nil {
                self.meetChecked = value["meetChecked"] as! Bool
            }
            if value["meetChecked"] != nil {
                self.meetChecked = value["meetChecked"] as! Bool
            }
            if value["dateChecked"] != nil {
                self.dateChecked = value["dateChecked"] as! Bool
            }
            self.aboutMeTextView.text = value["aboutMe"] as? String
            
            self.aboutMeTextViewHeightAnchor?.isActive  = false
            if self.aboutMeTextView.text != "" {
                let height1 = self.estimateFrameForText(text: self.aboutMeTextView.text!).height + 30
                self.aboutMeTextViewHeightAnchor = self.aboutMeTextView.heightAnchor.constraint(equalToConstant: height1)
            } else {
                self.aboutMeTextView.text = self.aboutMePlaceholder
            }
            self.aboutMeTextViewHeightAnchor?.isActive  = true
            
            self.aboutMyPlaceTextView.text = value["aboutMyPlace"] as? String
            
            self.aboutMyPlaceTextViewHeightAnchor?.isActive  = false
            if self.aboutMyPlaceTextView.text != "" {
                let height2 = self.estimateFrameForText(text: self.aboutMyPlaceTextView.text!).height + 30
                self.aboutMyPlaceTextViewHeightAnchor = self.aboutMyPlaceTextView.heightAnchor.constraint(equalToConstant: height2)
            } else {
                self.aboutMyPlaceTextView.text = self.aboutMyPlacePlaceholder
            }
            self.aboutMyPlaceTextViewHeightAnchor?.isActive  = true
            self.searchLocTextField.text = value["searchLoc"] as? String
            if self.search_travelChecked == true {
                self.search_travelCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
            }
            if self.search_meetChecked == true {
                self.search_meetCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
            }
            if self.search_dateChecked == true {
                self.search_dateCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
            }
            if self.meetChecked == true {
                self.meetCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
            }
            if self.dateChecked == true {
                self.dateCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
            }
            if self.acceptingGuests == "yes" {
                self.agYesCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
            } else if self.acceptingGuests == "maybe" {
                self.agMaybeCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
            } else {
                self.agNoCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
            }
        })
    }
    let locationManager = CLLocationManager()
    var aboutMeTextViewHeightAnchor: NSLayoutConstraint?
    var aboutMyPlaceTextViewHeightAnchor: NSLayoutConstraint?
    var aboutServicesTextTitleHeightAnchor: NSLayoutConstraint?
    var aboutServicesTextViewHeightAnchor: NSLayoutConstraint?//offerAServicetopAnchor offerAServiceheightAnchor
    var aboutServicesTextTitleTopAnchor: NSLayoutConstraint?
    var aboutServicesTextViewTopAnchor: NSLayoutConstraint?
    var offerAServicetopAnchor: NSLayoutConstraint?
    var offerAServiceheightAnchor: NSLayoutConstraint?
    func setupSettingsContainer(){
        self.view.addSubview(scrollView)
        scrollView.addSubview(settingsContainerView)
        settingsContainerView.addSubview(nameTextTitle)
        settingsContainerView.addSubview(nameTextField)
        settingsContainerView.addSubview(nameSeperatorView)
        settingsContainerView.addSubview(ageTextTitle)
        settingsContainerView.addSubview(ageTextField)
        settingsContainerView.addSubview(ageSeperatorView)
        settingsContainerView.addSubview(whatDYDTextTitle)//usernameTextTitle usernameTextField usernameSeperatorView
        settingsContainerView.addSubview(whatDYDTextField)
        settingsContainerView.addSubview(whatDYDSeperatorView)
        settingsContainerView.addSubview(emailTextTitle)
        settingsContainerView.addSubview(emailCHANGEButton)
        settingsContainerView.addSubview(emailTextField)
        settingsContainerView.addSubview(emailSeperatorView)
        settingsContainerView.addSubview(changePasswordButton)
        settingsContainerView.addSubview(usernameTextTitle)
        settingsContainerView.addSubview(usernameTextField)
        settingsContainerView.addSubview(usernameSeperatorView)
        settingsContainerView.addSubview(aboutMeTextTitle)
//        settingsContainerView.addSubview(aboutMeEDITButton)
        settingsContainerView.addSubview(aboutMeTextView)
        settingsContainerView.addSubview(aboutMyPlaceTextTitle)
//        settingsContainerView.addSubview(aboutMyPlaceEDITButton)
        settingsContainerView.addSubview(aboutMyPlaceTextView)
        settingsContainerView.addSubview(offerAService)
        settingsContainerView.addSubview(aboutMyServicesTextTitle)
        settingsContainerView.addSubview(aboutServicesTextView)
        settingsContainerView.addSubview(myProfilePhotosTextTitle)
        settingsContainerView.addSubview(myProfilePhotosEDITButton)
        settingsContainerView.addSubview(myPhotosTextTitle)
        settingsContainerView.addSubview(myPhotosEDITButton)
        settingsContainerView.addSubview(searchSettingsTitle)
        settingsContainerView.addSubview(searchLocTextTitle)
        settingsContainerView.addSubview(searchLocTextField)
        settingsContainerView.addSubview(searchLocSeperatorView)
        settingsContainerView.addSubview(currentLocTextTitle)
        settingsContainerView.addSubview(curentLocTextView)
        settingsContainerView.addSubview(locTextTitle)
        settingsContainerView.addSubview(locTextDescr)
        settingsContainerView.addSubview(locTextField)
        settingsContainerView.addSubview(locSeperatorView)
        settingsContainerView.addSubview(myHomeSettingsTitle)
        settingsContainerView.addSubview(agYesCheckboxButton)
        settingsContainerView.addSubview(agMaybeCheckboxButton)
        settingsContainerView.addSubview(agNoCheckboxButton)
        settingsContainerView.addSubview(meetCheckboxButton)
        settingsContainerView.addSubview(dateCheckboxButton)
//        settingsContainerView.addSubview(myTravelSettingsTitle)
//        settingsContainerView.addSubview(search_travelCheckboxButton)
//        settingsContainerView.addSubview(search_meetCheckboxButton)
//        settingsContainerView.addSubview(search_dateCheckboxButton)
        settingsContainerView.addSubview(deleteAccountButton)
        settingsContainerView.addSubview(bugReportButton)
//        settingsContainerView.addSubview(saveSettingsButton)
        
        aboutServicesTextView.delegate = self
        aboutMeTextView.delegate = self
        aboutMyPlaceTextView.delegate = self
        
        nameTextField.delegate = self
//        ageTextField.delegate = self
        emailTextField.delegate = self
        usernameTextField.delegate = self
        
        let userInfo = Auth.auth().currentUser?.providerData
        var authMethod: String?
        for some in userInfo! {
            print("some: ", "\(some.providerID)")
            authMethod = "\(some.providerID)"
        }
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        settingsContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        settingsContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        settingsContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -100).isActive = true
//        settingsContainerView.heightAnchor.constraint(equalToConstant: 1250).isActive = true
        settingsContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        nameTextTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 3).isActive = true
        nameTextTitle.topAnchor.constraint(equalTo: settingsContainerView.topAnchor, constant: 20).isActive = true
        nameTextTitle.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        nameTextTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true

        nameTextField.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameTextTitle.bottomAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        nameSeperatorView.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 4).isActive = true
        nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.topAnchor, constant: 1).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        ageTextTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 3).isActive = true
        ageTextTitle.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor, constant: 20).isActive = true
        ageTextTitle.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        ageTextTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        ageTextField.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 12).isActive = true
        ageTextField.topAnchor.constraint(equalTo: ageTextTitle.bottomAnchor).isActive = true
        ageTextField.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        ageTextField.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        ageSeperatorView.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 4).isActive = true
        ageSeperatorView.topAnchor.constraint(equalTo: ageTextField.topAnchor, constant: 1).isActive = true
        ageSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        ageSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        whatDYDTextTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 3).isActive = true
        whatDYDTextTitle.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 20).isActive = true
        whatDYDTextTitle.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        whatDYDTextTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true

        whatDYDTextField.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 12).isActive = true
        whatDYDTextField.topAnchor.constraint(equalTo: whatDYDTextTitle.bottomAnchor).isActive = true
        whatDYDTextField.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        whatDYDTextField.heightAnchor.constraint(equalToConstant: 23).isActive = true

        whatDYDSeperatorView.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 4).isActive = true
        whatDYDSeperatorView.topAnchor.constraint(equalTo: whatDYDTextField.topAnchor, constant: 1).isActive = true
        whatDYDSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        whatDYDSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        emailTextTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 3).isActive = true
        emailTextTitle.topAnchor.constraint(equalTo: whatDYDTextField.bottomAnchor, constant: 20).isActive = true
        emailTextTitle.widthAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        emailCHANGEButton.topAnchor.constraint(equalTo: emailTextTitle.topAnchor).isActive = true
        emailCHANGEButton.leftAnchor.constraint(equalTo: emailTextTitle.rightAnchor, constant: 27).isActive = true
        emailCHANGEButton.heightAnchor.constraint(equalToConstant: authMethod == "password" ? 20 : 0).isActive = true
        emailCHANGEButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: emailTextTitle.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        emailSeperatorView.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 4).isActive = true
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 1).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        changePasswordButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: authMethod == "password" ? 20 : 0).isActive = true
        changePasswordButton.leftAnchor.constraint(equalTo: settingsContainerView.leftAnchor, constant: 4).isActive = true
        changePasswordButton.heightAnchor.constraint(equalToConstant: authMethod == "password" ? 30 : 0).isActive = true
        changePasswordButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        changePasswordButton.titleLabel?.leftAnchor.constraint(equalTo: changePasswordButton.leftAnchor)
        
        usernameTextTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 3).isActive = true
        usernameTextTitle.topAnchor.constraint(equalTo: changePasswordButton.bottomAnchor, constant: 20).isActive = true
        usernameTextTitle.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        usernameTextTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        usernameTextField.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 12).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: usernameTextTitle.bottomAnchor).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        usernameSeperatorView.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 4).isActive = true
        usernameSeperatorView.topAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: 1).isActive = true
        usernameSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        usernameSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        aboutMeTextTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 3).isActive = true
        aboutMeTextTitle.topAnchor.constraint(equalTo: usernameSeperatorView.bottomAnchor, constant: 20).isActive = true
        aboutMeTextTitle.widthAnchor.constraint(equalToConstant: 90).isActive = true
        aboutMeTextTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
//        aboutMeEDITButton.leftAnchor.constraint(equalTo:  aboutMeTextTitle.rightAnchor).isActive = true
//        aboutMeEDITButton.bottomAnchor.constraint(equalTo: aboutMeTextTitle.bottomAnchor).isActive = true
//        aboutMeEDITButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        aboutMeEDITButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
//        aboutMeEDITButton.titleLabel?.bottomAnchor.constraint(equalTo: aboutMeEDITButton.bottomAnchor).isActive = true
        
        aboutMeTextView.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: -1).isActive = true
        aboutMeTextView.topAnchor.constraint(equalTo: aboutMeTextTitle.bottomAnchor, constant: 3).isActive = true
        aboutMeTextView.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        aboutMeTextViewHeightAnchor = aboutMeTextView.heightAnchor.constraint(equalToConstant: 35)
        aboutMeTextViewHeightAnchor?.isActive = true
        
        aboutMyPlaceTextTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 4).isActive = true
        aboutMyPlaceTextTitle.topAnchor.constraint(equalTo: aboutMeTextView.bottomAnchor, constant: 20).isActive = true
        aboutMyPlaceTextTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        aboutMyPlaceTextTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
//        aboutMyPlaceEDITButton.leftAnchor.constraint(equalTo:  aboutMyPlaceTextTitle.rightAnchor).isActive = true
//        aboutMyPlaceEDITButton.bottomAnchor.constraint(equalTo: aboutMyPlaceTextTitle.bottomAnchor).isActive = true
//        aboutMyPlaceEDITButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        aboutMyPlaceEDITButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
//        aboutMyPlaceEDITButton.titleLabel?.bottomAnchor.constraint(equalTo: aboutMyPlaceEDITButton.bottomAnchor).isActive = true
        
        aboutMyPlaceTextView.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: -1).isActive = true
        aboutMyPlaceTextView.topAnchor.constraint(equalTo: aboutMyPlaceTextTitle.bottomAnchor, constant: 3).isActive = true
        aboutMyPlaceTextView.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        aboutMyPlaceTextViewHeightAnchor = aboutMyPlaceTextView.heightAnchor.constraint(equalToConstant: 35)
        aboutMyPlaceTextViewHeightAnchor?.isActive = true
        
        
        offerAService.leftAnchor.constraint(equalTo: settingsContainerView.leftAnchor, constant: 3).isActive = true
        offerAServicetopAnchor = offerAService.topAnchor.constraint(equalTo: aboutMyPlaceTextView.bottomAnchor, constant: 20)
        offerAServicetopAnchor?.isActive = true
        offerAService.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        offerAServiceheightAnchor = offerAService.heightAnchor.constraint(equalToConstant: 30)
        offerAServiceheightAnchor?.isActive = true
        offerAService.titleLabel?.leftAnchor.constraint(equalTo: offerAService.leftAnchor).isActive = true
        
        aboutMyServicesTextTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 3).isActive = true
        aboutServicesTextTitleTopAnchor = aboutMyServicesTextTitle.topAnchor.constraint(equalTo: offerAService.bottomAnchor, constant: 10)
        aboutServicesTextTitleTopAnchor?.isActive = true
        aboutMyServicesTextTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        aboutServicesTextTitleHeightAnchor = aboutMyServicesTextTitle.heightAnchor.constraint(equalToConstant: 23)
        aboutServicesTextTitleHeightAnchor?.isActive = true
        
        aboutServicesTextView.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: -1).isActive = true
        aboutServicesTextViewTopAnchor = aboutServicesTextView.topAnchor.constraint(equalTo: aboutMyServicesTextTitle.bottomAnchor, constant: 3)
        aboutServicesTextViewTopAnchor?.isActive = true
        aboutServicesTextView.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        aboutServicesTextViewHeightAnchor = aboutServicesTextView.heightAnchor.constraint(equalToConstant: 35)
        aboutServicesTextViewHeightAnchor?.isActive = true
        
        myProfilePhotosTextTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 3).isActive = true
        myProfilePhotosTextTitle.topAnchor.constraint(equalTo: aboutServicesTextView.bottomAnchor, constant: 20).isActive = true
        myProfilePhotosTextTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        myProfilePhotosTextTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        myProfilePhotosEDITButton.leftAnchor.constraint(equalTo:  myProfilePhotosTextTitle.rightAnchor).isActive = true
        myProfilePhotosEDITButton.bottomAnchor.constraint(equalTo: myProfilePhotosTextTitle.bottomAnchor).isActive = true
        myProfilePhotosEDITButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        myProfilePhotosEDITButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        myProfilePhotosEDITButton.titleLabel?.bottomAnchor.constraint(equalTo: myProfilePhotosEDITButton.bottomAnchor).isActive = true
        
        myPhotosTextTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 3).isActive = true
        myPhotosTextTitle.topAnchor.constraint(equalTo: myProfilePhotosEDITButton.bottomAnchor, constant: 20).isActive = true
        myPhotosTextTitle.widthAnchor.constraint(equalToConstant: 180).isActive = true
        myPhotosTextTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        myPhotosEDITButton.leftAnchor.constraint(equalTo:  myPhotosTextTitle.rightAnchor).isActive = true
        myPhotosEDITButton.bottomAnchor.constraint(equalTo: myPhotosTextTitle.bottomAnchor).isActive = true
        myPhotosEDITButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        myPhotosEDITButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        myPhotosEDITButton.titleLabel?.bottomAnchor.constraint(equalTo: myPhotosEDITButton.bottomAnchor).isActive = true

        searchSettingsTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 3).isActive = true
        searchSettingsTitle.topAnchor.constraint(equalTo: myPhotosEDITButton.bottomAnchor, constant: 20).isActive = true
        searchSettingsTitle.widthAnchor.constraint(equalToConstant: 180).isActive = true
        searchSettingsTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        searchLocTextTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 3).isActive = true
        searchLocTextTitle.topAnchor.constraint(equalTo: searchSettingsTitle.bottomAnchor, constant: 20).isActive = true
        searchLocTextTitle.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        searchLocTextTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        searchLocTextField.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 12).isActive = true
        searchLocTextField.topAnchor.constraint(equalTo: searchLocTextTitle.bottomAnchor).isActive = true
        searchLocTextField.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        searchLocTextField.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        searchLocSeperatorView.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 4).isActive = true
        searchLocSeperatorView.topAnchor.constraint(equalTo: searchLocTextField.topAnchor, constant: 1).isActive = true
        searchLocSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        searchLocSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        currentLocTextTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 3).isActive = true
        currentLocTextTitle.topAnchor.constraint(equalTo: searchLocTextField.bottomAnchor, constant: 20).isActive = true
        currentLocTextTitle.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        currentLocTextTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        curentLocTextView.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 3).isActive = true
        curentLocTextView.topAnchor.constraint(equalTo: currentLocTextTitle.bottomAnchor).isActive = true
        curentLocTextView.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        curentLocTextView.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        locTextTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: -3).isActive = true
        locTextTitle.topAnchor.constraint(equalTo: curentLocTextView.bottomAnchor, constant: 20).isActive = true
        locTextTitle.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        locTextTitle.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        locTextDescr.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: -3).isActive = true
        locTextDescr.topAnchor.constraint(equalTo: locTextTitle.bottomAnchor).isActive = true
        locTextDescr.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor, constant: 20).isActive = true
        locTextDescr.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        locTextField.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 12).isActive = true
        locTextField.topAnchor.constraint(equalTo: locTextDescr.bottomAnchor).isActive = true
        locTextField.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        locTextField.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        locSeperatorView.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 4).isActive = true
        locSeperatorView.topAnchor.constraint(equalTo: locTextField.topAnchor, constant: 1).isActive = true
        locSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        locSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        myHomeSettingsTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 3).isActive = true
        myHomeSettingsTitle.topAnchor.constraint(equalTo: locTextField.bottomAnchor, constant: 20).isActive = true
        myHomeSettingsTitle.widthAnchor.constraint(equalToConstant: 180).isActive = true
        myHomeSettingsTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        agYesCheckboxButton.leftAnchor.constraint(equalTo: settingsContainerView.leftAnchor, constant: 3).isActive = true
        agYesCheckboxButton.topAnchor.constraint(equalTo: myHomeSettingsTitle.bottomAnchor).isActive = true
        agYesCheckboxButton.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        agYesCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        agYesCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: agYesCheckboxButton.leftAnchor).isActive = true
        
        agMaybeCheckboxButton.leftAnchor.constraint(equalTo: settingsContainerView.leftAnchor, constant: 3).isActive = true
        agMaybeCheckboxButton.topAnchor.constraint(equalTo: agYesCheckboxButton.bottomAnchor).isActive = true
        agMaybeCheckboxButton.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        agMaybeCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        agMaybeCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: agMaybeCheckboxButton.leftAnchor).isActive = true
        
        agNoCheckboxButton.leftAnchor.constraint(equalTo: settingsContainerView.leftAnchor, constant: 3).isActive = true
        agNoCheckboxButton.topAnchor.constraint(equalTo: agMaybeCheckboxButton.bottomAnchor).isActive = true
        agNoCheckboxButton.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        agNoCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        agNoCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: agNoCheckboxButton.leftAnchor).isActive = true
        
        meetCheckboxButton.leftAnchor.constraint(equalTo: settingsContainerView.leftAnchor, constant: 3).isActive = true
        meetCheckboxButton.topAnchor.constraint(equalTo: agNoCheckboxButton.bottomAnchor).isActive = true
        meetCheckboxButton.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        meetCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        meetCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: meetCheckboxButton.leftAnchor).isActive = true
        
        dateCheckboxButton.leftAnchor.constraint(equalTo: settingsContainerView.leftAnchor, constant: 3).isActive = true
        dateCheckboxButton.topAnchor.constraint(equalTo: meetCheckboxButton.bottomAnchor).isActive = true
        dateCheckboxButton.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
        dateCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: dateCheckboxButton.leftAnchor).isActive = true
        
//        myTravelSettingsTitle.leftAnchor.constraint(equalTo:  settingsContainerView.leftAnchor, constant: 3).isActive = true
//        myTravelSettingsTitle.topAnchor.constraint(equalTo: dateCheckboxButton.bottomAnchor, constant: 20).isActive = true
//        myTravelSettingsTitle.widthAnchor.constraint(equalToConstant: 180).isActive = true
//        myTravelSettingsTitle.heightAnchor.constraint(equalToConstant: 23).isActive = true
//
//        search_travelCheckboxButton.leftAnchor.constraint(equalTo: settingsContainerView.leftAnchor, constant: 3).isActive = true
//        search_travelCheckboxButton.topAnchor.constraint(equalTo: myTravelSettingsTitle.bottomAnchor).isActive = true
//        search_travelCheckboxButton.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
//        search_travelCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        search_travelCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: search_travelCheckboxButton.leftAnchor).isActive = true
//
//        search_meetCheckboxButton.leftAnchor.constraint(equalTo: settingsContainerView.leftAnchor, constant: 3).isActive = true
//        search_meetCheckboxButton.topAnchor.constraint(equalTo: search_travelCheckboxButton.bottomAnchor).isActive = true
//        search_meetCheckboxButton.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
//        search_meetCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        search_meetCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: search_meetCheckboxButton.leftAnchor).isActive = true
//
//        search_dateCheckboxButton.leftAnchor.constraint(equalTo: settingsContainerView.leftAnchor, constant: 3).isActive = true
//        search_dateCheckboxButton.topAnchor.constraint(equalTo: search_meetCheckboxButton.bottomAnchor).isActive = true
//        search_dateCheckboxButton.widthAnchor.constraint(equalTo: settingsContainerView.widthAnchor).isActive = true
//        search_dateCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        search_dateCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: search_dateCheckboxButton.leftAnchor).isActive = true
        
        deleteAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deleteAccountButton.topAnchor.constraint(equalTo: dateCheckboxButton.bottomAnchor, constant: 12).isActive = true
        deleteAccountButton.widthAnchor.constraint(equalTo: dateCheckboxButton.widthAnchor).isActive = true
        deleteAccountButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        deleteAccountButton.titleLabel?.leftAnchor.constraint(equalTo: deleteAccountButton.leftAnchor).isActive = true
        
        bugReportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bugReportButton.topAnchor.constraint(equalTo: deleteAccountButton.bottomAnchor, constant: 12).isActive = true
        bugReportButton.widthAnchor.constraint(equalTo: deleteAccountButton.widthAnchor).isActive = true
        bugReportButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bugReportButton.titleLabel?.leftAnchor.constraint(equalTo: bugReportButton.leftAnchor).isActive = true
        bugReportButton.bottomAnchor.constraint(equalTo: settingsContainerView.bottomAnchor).isActive = true

//        saveSettingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        saveSettingsButton.topAnchor.constraint(equalTo: bugReportButton.bottomAnchor, constant: 12).isActive = true
//        saveSettingsButton.widthAnchor.constraint(equalTo: search_dateCheckboxButton.widthAnchor).isActive = true
//        saveSettingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        saveSettingsButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
//        let screenSize: CGRect = UIScreen.main.bounds
//        let screenWidth = screenSize.width
//        scrollView.contentSize = CGSize(width: screenWidth, height: 1500)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        getCurentSettings()
        view.backgroundColor = UIColor.white
        setupSettingsContainer()
//        isAuthorizedtoGetUserLocation()
//        getCurentLocation()
        setupNavBarItems()
//        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(getCurentLocation), userInfo: nil, repeats: true)
        
    }
    func setupNavBarItems(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.lightOrange1]
        self.navigationItem.title = "My profile"
        let backImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        let rightNavbarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveSettings))
        rightNavbarButton.tintColor = CustomColors.commonBlue1
        navigationItem.rightBarButtonItem = rightNavbarButton
    }
    @objc func goBack() {
        if editingIsOk {
//            let email = self.emailTextField.text
//            let name = self.nameTextField.text
//            let age = self.ageTextField.text
//            let loc = self.locTextField.text
//            let occupation = self.whatDYDTextField.text
//            let acceptingGuests = self.acceptingGuests as String?
//            let meetChecked = self.meetChecked as Bool?
//            let dateChecked = self.dateChecked as Bool?
//            let travelChecked = self.search_travelChecked as Bool?
//            let aboutMe = self.aboutMeTextView.text as String?
//            let aboutMyPlace = self.aboutMyPlaceTextView.text as String?
//            let search_loc = self.searchLocTextField.text
//            let currentLoc = self.curentLocTextView.text
//            let username = self.usernameTextField.text
//            let values = ["name": name, "email": email, "age": age, "loc": loc, "occupation": occupation, "acceptingGuests": acceptingGuests, "meetChecked": meetChecked, "dateChecked": dateChecked, "travelChecked": travelChecked, "aboutMe": aboutMe, "aboutMyPlace": aboutMyPlace, "searchLoc": search_loc, "currentLoc": currentLoc, "username": username] as [String : Any]
//            print("current settings: ", currentSettings, "\nNew settings: ", values)
//            if self.currentSettings == values {
//                print("equal")
//            } else {
//                print("not equal")
//            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadMyProfile"), object: nil)
            myImagesURLSArray = [String]()
            self.dismiss(animated: true, completion: nil)
        }
    }
//    @objc func getCurentLocation(){
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
//    }
//    func isAuthorizedtoGetUserLocation() {
//        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            print("User allowed us to access location")
//        }
//    }
//    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
//        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
//            completion(placemarks?.first?.locality,
//                       placemarks?.first?.country,
//                       error)
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("Did location updates is called")
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
//        fetchCityAndCountry(from: location) { city, country, error in
//            guard let city = city, let country = country, error == nil else { return }
//            print(city + ", " + country)
//            self.curentLocTextView.text = city + ", " + country
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Did location updates is called but failed getting location \(error)")
//        self.curentLocTextView.placeholder = "disabled"
//    }
    func presentAC(){
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .region
        acController.autocompleteFilter = filter
        present(acController, animated: true, completion: nil)
    }
    @objc func goAC(){
        acSelection = 1
        presentAC()
    }
    @objc func goAC2(){
        acSelection = 2
        presentAC()
    }
}
extension ProfileSettingsController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if acSelection == 1 {
            searchLocTextField.text = place.formattedAddress
        } else if acSelection == 2 {
            locTextField.text = place.formattedAddress
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
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
