//
//  FBLoginController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 14.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import GoogleMaps
import GooglePlaces
import FBSDKLoginKit

var fb_acceptingGuests: String?
var fb_whatDYDTextField: String?
var fb_aboutMeTextField: String?
var fb_meetChecked: Bool?
var fb_dateChecked: Bool?
var fb_travelChecked: Bool?
var fb_userId: String?

class FBLoginController: UIViewController, UITextFieldDelegate {
    let loginMethodController = LoginMethodController()
    var userFull : UserFull = UserFull()
    var messagesController: MessagesController?
    var welcomeController = WelcomeController()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor.white
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.layer.masksToBounds = true
        return sv
    }()
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Next", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(CustomColors.commonBlue1, for: [])
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
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
            if ageTextField.text == "" {
                attention = "Age is required"
                isOk = false
            } else if Int(ageTextField.text!) == nil {
                attention = "Age can be only numerical"
                isOk = false
            } else if Int(ageTextField.text!)! < 18 {
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
        }
        if isOk == false {
            let alert = UIAlertController(title: "Notice", message: attention, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        return isOk
    }
    @objc func handleLoginRegister() {
        var nameIsOk = false
        var ageIsOk = false
        var emailIsOk = false
        var locIsOk = false
        var genderIsOk = false
        var referalSelectedIsOk = false
        var referalFromPersonIsOk = false
        if selectedReferalMethod == "" {
            referalTitle.textColor = CustomColors.lightOrange1
            referalSelectedIsOk = false
        } else {
            referalTitle.textColor = CustomColors.commonGrey1
            referalSelectedIsOk = true
        }
        if selectedReferalMethod == "from a person" && refCodeTextField.text == "" && refNameTextField.text == "" && refCompanyTextField.text == "" {
            referalFromPersonIsOk = false
        } else {
            referalFromPersonIsOk = true
        }
        if nameTextField.text == "" || nameTextField.text == "DELETED" {
            nameTextTitle.textColor = CustomColors.lightOrange1
            nameIsOk = false
        } else {
            nameTextTitle.textColor = CustomColors.commonGrey1
            nameIsOk = true
        }
        
        if ageTextField.text == "" || Int(ageTextField.text!)! < 12 || Int(ageTextField.text!)! > 100 {
            ageTextTitle.textColor = CustomColors.lightOrange1
            ageIsOk = false
        } else {
            ageTextTitle.textColor = CustomColors.commonGrey1
            ageIsOk = true
        }
        if isValidEmail(testStr: emailTextField.text!) {
            emailTextTitle.textColor = CustomColors.commonGrey1
            emailIsOk = true
            
        } else {
            emailTextTitle.textColor = CustomColors.lightOrange1
            emailIsOk = false
            
        }
        if yourSex != "male" && yourSex != "female" {
            youeSexTitle.textColor = CustomColors.lightOrange1
            genderIsOk = false
        } else {
            youeSexTitle.textColor = CustomColors.commonGrey1
            genderIsOk = true
        }
        if (locTextField.text?.count)! < 2 {
            locTextTitle.textColor = CustomColors.lightOrange1
            locIsOk = false
        } else {
            locTextTitle.textColor = CustomColors.commonGrey1
            locIsOk = true
        }
        
        var message: String?
        if nameIsOk == true && ageIsOk == true && emailIsOk == true && genderIsOk == true && locIsOk == true  && referalSelectedIsOk == true && referalFromPersonIsOk == true{
            self.messagesController?.refreshMessages()
            let welcomeC = WelcomeController()
            welcomeC.fbLoginController = self
            let welcomeCNav = UINavigationController(rootViewController: welcomeC)
            self.present(welcomeCNav, animated: true, completion: nil)
        } else if referalSelectedIsOk == false {
            message = "Select one option"
        } else if referalFromPersonIsOk == false {
            message = "Fill one of the fields or select another option"
        } else {
            message = "Please check and make sure all the fields are filled correctly"
        }
        if message != nil {
            let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
    }
//    @objc func handleLogin() {
//        guard let email = emailTextField.text, let password = passwordTextField.text else {
//            print("Form is not valid")
//            return
//        }
//        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
//            if error != nil {
//                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true)
//                print(error as Any)
//                return
//            }
//            self.messagesController?.refreshMessages()
//            self.dismiss(animated: true, completion: nil)
//        })
//    }
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
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "enter your email...", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = UIKeyboardType.emailAddress
        return tf
    }()
    let emailSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let passwordSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let ageTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "how old are you?", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = UIKeyboardType.numberPad
        return tf
    }()
    let ageSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let locTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "My closest big city, e.g London", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(goAC), for: UIControlEvents.editingDidBegin)
        return tf
    }()
    
    let locSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let locTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Home or Travel location"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    let ageTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Age"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    let passwordTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Password"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    let emailTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Email"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
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
    let avatarTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Add your profile picture"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
//    let passwordTextField: UITextField = {
//        let tf = UITextField()
//        tf.attributedPlaceholder = NSAttributedString(string: "enter your password...", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
//        tf.textColor = CustomColors.commonBlue1
//        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.isSecureTextEntry = true
//        return tf
//    }()
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyavatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let youeSexTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Are you:"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 17)
        return tt
    }()
    let femaleCheckboxButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(femalesCheck), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  female", size: 17, forState: .normal)
        tcb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return tcb
    }()
    let maleCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(maleCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  male", size: 17, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    let loaderOverlayer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let referalContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let referalTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "How did you learn about this app?"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 17)
        return tt
    }()
    let selectorReferalButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(referalMethodSelect), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setTitle("select", for: [])
        tcb.setTitleColor(CustomColors.commonGrey1, for: [])
        tcb.backgroundColor = CustomColors.lightGrey1
        return tcb
    }()
    let optionsReferalContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    let fromPersonReferalButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(fromPersonReferalSelect), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setTitle("From a person", for: [])
        tcb.setTitleColor(CustomColors.commonGrey1, for: [])
        tcb.backgroundColor = CustomColors.lightGrey1
        return tcb
    }()
    let portoDiscountButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(portoDiscountReferalSelect), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setTitle("Porto discount card", for: [])
        tcb.setTitleColor(CustomColors.commonGrey1, for: [])
        tcb.backgroundColor = CustomColors.lightGrey1
        return tcb
    }()
    let appStoreReferalButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(appStoreReferalSelect), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setTitle("App Store", for: [])
        tcb.setTitleColor(CustomColors.commonGrey1, for: [])
        tcb.backgroundColor = CustomColors.lightGrey1
        return tcb
    }()
    let playStoreReferalButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(playStoreReferalSelect), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setTitle("Play Store", for: [])
        tcb.setTitleColor(CustomColors.commonGrey1, for: [])
        tcb.backgroundColor = CustomColors.lightGrey1
        return tcb
    }()
    let instagramReferalButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(instagramReferalSelect), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setTitle("Instagram", for: [])
        tcb.setTitleColor(CustomColors.commonGrey1, for: [])
        tcb.backgroundColor = CustomColors.lightGrey1
        return tcb
    }()
    let facebookReferalButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(facebookReferalSelect), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setTitle("Facebook", for: [])
        tcb.setTitleColor(CustomColors.commonGrey1, for: [])
        tcb.backgroundColor = CustomColors.lightGrey1
        return tcb
    }()
    let mfrSiteReferalButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(mfrSiteReferalSelect), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setTitle("MyFriendsRoom website", for: [])
        tcb.setTitleColor(CustomColors.commonGrey1, for: [])
        tcb.backgroundColor = CustomColors.lightGrey1
        return tcb
    }()
    let mfrMeetUpReferalButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(mfrMeetUpReferalSelect), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setTitle("MyFriendsRoom meetup", for: [])
        tcb.setTitleColor(CustomColors.commonGrey1, for: [])
        tcb.backgroundColor = CustomColors.lightGrey1
        return tcb
    }()
    let googleReferalButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(googleStoreReferalSelect), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setTitle("Google", for: [])
        tcb.setTitleColor(CustomColors.commonGrey1, for: [])
        tcb.backgroundColor = CustomColors.lightGrey1
        return tcb
    }()
    let otherReferalButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(otherStoreReferalSelect), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setTitle("Other", for: [])
        tcb.setTitleColor(CustomColors.commonGrey1, for: [])
        tcb.backgroundColor = CustomColors.lightGrey1
        return tcb
    }()
    let refCodeSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let refCodeTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "code", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.keyboardType = UIKeyboardType.numberPad
        return tf
    }()
    let refNameSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let refNameTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.keyboardType = UIKeyboardType.numberPad
        return tf
    }()
    let refCompanySeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let refCompanyTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "company", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.keyboardType = UIKeyboardType.numberPad
        return tf
    }()
    @objc func referalMethodSelect(){
        print("click")
        if optionsReferalContainer.isHidden == true {
            optionsReferalContainer.isHidden = false
        } else {
            optionsReferalContainer.isHidden = true
        }
    }
    var fromPerson = false
    var selectedReferalMethod = ""
    @objc func fromPersonReferalSelect(){
        let selectorReferalTitle = "From a person"
        selectorReferalButton.setTitle(selectorReferalTitle, for: [])
        fromPersonReferalButton.backgroundColor = CustomColors.lightBlue1
        portoDiscountButton.backgroundColor = CustomColors.lightGrey1
        appStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        playStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        instagramReferalButton.backgroundColor = CustomColors.lightGrey1
        facebookReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrSiteReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrMeetUpReferalButton.backgroundColor = CustomColors.lightGrey1
        googleReferalButton.backgroundColor = CustomColors.lightGrey1
        otherReferalButton.backgroundColor = CustomColors.lightGrey1
        optionsReferalContainer.isHidden = true
        hideUnhideReferalInputs(action: "unhide")
        fromPerson = true
        selectedReferalMethod = "from a person"
    }
    @objc func portoDiscountReferalSelect(){
        let selectorReferalTitle = "Porto discount card"
        selectorReferalButton.setTitle(selectorReferalTitle, for: [])
        fromPersonReferalButton.backgroundColor = CustomColors.lightGrey1
        portoDiscountButton.backgroundColor = CustomColors.lightBlue1
        appStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        playStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        instagramReferalButton.backgroundColor = CustomColors.lightGrey1
        facebookReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrSiteReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrMeetUpReferalButton.backgroundColor = CustomColors.lightGrey1
        googleReferalButton.backgroundColor = CustomColors.lightGrey1
        otherReferalButton.backgroundColor = CustomColors.lightGrey1
        optionsReferalContainer.isHidden = true
        hideUnhideReferalInputs(action: "hide")
        fromPerson = false
        selectedReferalMethod = "porto discount card"
        
    }
    @objc func appStoreReferalSelect(){
        let selectorReferalTitle = "App Store"
        selectorReferalButton.setTitle(selectorReferalTitle, for: [])
        fromPersonReferalButton.backgroundColor = CustomColors.lightGrey1
        portoDiscountButton.backgroundColor = CustomColors.lightGrey1
        appStoreReferalButton.backgroundColor = CustomColors.lightBlue1
        playStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        instagramReferalButton.backgroundColor = CustomColors.lightGrey1
        facebookReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrSiteReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrMeetUpReferalButton.backgroundColor = CustomColors.lightGrey1
        googleReferalButton.backgroundColor = CustomColors.lightGrey1
        otherReferalButton.backgroundColor = CustomColors.lightGrey1
        optionsReferalContainer.isHidden = true
        hideUnhideReferalInputs(action: "hide")
        fromPerson = false
        selectedReferalMethod = "app store"
        
    }
    @objc func playStoreReferalSelect(){
        let selectorReferalTitle = "Play Store"
        selectorReferalButton.setTitle(selectorReferalTitle, for: [])
        fromPersonReferalButton.backgroundColor = CustomColors.lightGrey1
        portoDiscountButton.backgroundColor = CustomColors.lightGrey1
        appStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        playStoreReferalButton.backgroundColor = CustomColors.lightBlue1
        instagramReferalButton.backgroundColor = CustomColors.lightGrey1
        facebookReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrSiteReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrMeetUpReferalButton.backgroundColor = CustomColors.lightGrey1
        googleReferalButton.backgroundColor = CustomColors.lightGrey1
        otherReferalButton.backgroundColor = CustomColors.lightGrey1
        optionsReferalContainer.isHidden = true
        hideUnhideReferalInputs(action: "hide")
        fromPerson = false
        selectedReferalMethod = "play store"
        
    }
    @objc func instagramReferalSelect(){
        let selectorReferalTitle = "Instagram"
        selectorReferalButton.setTitle(selectorReferalTitle, for: [])
        fromPersonReferalButton.backgroundColor = CustomColors.lightGrey1
        portoDiscountButton.backgroundColor = CustomColors.lightGrey1
        appStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        playStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        instagramReferalButton.backgroundColor = CustomColors.lightBlue1
        facebookReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrSiteReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrMeetUpReferalButton.backgroundColor = CustomColors.lightGrey1
        googleReferalButton.backgroundColor = CustomColors.lightGrey1
        otherReferalButton.backgroundColor = CustomColors.lightGrey1
        optionsReferalContainer.isHidden = true
        hideUnhideReferalInputs(action: "hide")
        fromPerson = false
        selectedReferalMethod = "instagram"
        
    }
    @objc func facebookReferalSelect(){
        let selectorReferalTitle = "Facebook"
        selectorReferalButton.setTitle(selectorReferalTitle, for: [])
        fromPersonReferalButton.backgroundColor = CustomColors.lightGrey1
        portoDiscountButton.backgroundColor = CustomColors.lightGrey1
        appStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        playStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        instagramReferalButton.backgroundColor = CustomColors.lightGrey1
        facebookReferalButton.backgroundColor = CustomColors.lightBlue1
        mfrSiteReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrMeetUpReferalButton.backgroundColor = CustomColors.lightGrey1
        googleReferalButton.backgroundColor = CustomColors.lightGrey1
        otherReferalButton.backgroundColor = CustomColors.lightGrey1
        optionsReferalContainer.isHidden = true
        hideUnhideReferalInputs(action: "hide")
        fromPerson = false
        selectedReferalMethod = "facebook"
        
    }
    @objc func mfrSiteReferalSelect(){
        let selectorReferalTitle = "MyFriendsRoom website"
        selectorReferalButton.setTitle(selectorReferalTitle, for: [])
        fromPersonReferalButton.backgroundColor = CustomColors.lightGrey1
        portoDiscountButton.backgroundColor = CustomColors.lightGrey1
        appStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        playStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        instagramReferalButton.backgroundColor = CustomColors.lightGrey1
        facebookReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrSiteReferalButton.backgroundColor = CustomColors.lightBlue1
        mfrMeetUpReferalButton.backgroundColor = CustomColors.lightGrey1
        googleReferalButton.backgroundColor = CustomColors.lightGrey1
        otherReferalButton.backgroundColor = CustomColors.lightGrey1
        optionsReferalContainer.isHidden = true
        hideUnhideReferalInputs(action: "hide")
        fromPerson = false
        selectedReferalMethod = "mfr site"
        
    }
    @objc func mfrMeetUpReferalSelect(){
        let selectorReferalTitle = "MyFriendsRoom meetup"
        selectorReferalButton.setTitle(selectorReferalTitle, for: [])
        fromPersonReferalButton.backgroundColor = CustomColors.lightGrey1
        portoDiscountButton.backgroundColor = CustomColors.lightGrey1
        appStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        playStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        instagramReferalButton.backgroundColor = CustomColors.lightGrey1
        facebookReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrSiteReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrMeetUpReferalButton.backgroundColor = CustomColors.lightBlue1
        googleReferalButton.backgroundColor = CustomColors.lightGrey1
        otherReferalButton.backgroundColor = CustomColors.lightGrey1
        optionsReferalContainer.isHidden = true
        hideUnhideReferalInputs(action: "hide")
        fromPerson = false
        selectedReferalMethod = "mfr meetup"
        
    }
    @objc func googleStoreReferalSelect(){
        let selectorReferalTitle = "Google"
        selectorReferalButton.setTitle(selectorReferalTitle, for: [])
        fromPersonReferalButton.backgroundColor = CustomColors.lightGrey1
        portoDiscountButton.backgroundColor = CustomColors.lightGrey1
        appStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        playStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        instagramReferalButton.backgroundColor = CustomColors.lightGrey1
        facebookReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrSiteReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrMeetUpReferalButton.backgroundColor = CustomColors.lightGrey1
        googleReferalButton.backgroundColor = CustomColors.lightBlue1
        otherReferalButton.backgroundColor = CustomColors.lightGrey1
        optionsReferalContainer.isHidden = true
        hideUnhideReferalInputs(action: "hide")
        fromPerson = false
        selectedReferalMethod = "google"
        
    }
    @objc func otherStoreReferalSelect(){
        let selectorReferalTitle = "Other"
        selectorReferalButton.setTitle(selectorReferalTitle, for: [])
        fromPersonReferalButton.backgroundColor = CustomColors.lightGrey1
        portoDiscountButton.backgroundColor = CustomColors.lightGrey1
        appStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        playStoreReferalButton.backgroundColor = CustomColors.lightGrey1
        instagramReferalButton.backgroundColor = CustomColors.lightGrey1
        facebookReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrSiteReferalButton.backgroundColor = CustomColors.lightGrey1
        mfrMeetUpReferalButton.backgroundColor = CustomColors.lightGrey1
        googleReferalButton.backgroundColor = CustomColors.lightGrey1
        otherReferalButton.backgroundColor = CustomColors.lightBlue1
        optionsReferalContainer.isHidden = true
        hideUnhideReferalInputs(action: "hide")
        fromPerson = false
        selectedReferalMethod = "other"
        
    }
    func hideUnhideReferalInputs(action: String){
        let textHeight: CGFloat
        let separatorHeight: CGFloat
        let containerHeight: CGFloat
        if action == "hide"{
            textHeight = 0
            separatorHeight = 0
            containerHeight = 70
        } else {
            textHeight = 37
            separatorHeight = 20
            containerHeight = 181
        }
        refCodeTextHeightAnchor?.isActive = false
        refCodeSeperatorHeightAnchor?.isActive = false
        refNameTextHeightAnchor?.isActive = false
        refNameSeperatorHeightAnchor?.isActive = false
        refCompanyTextHeightAnchor?.isActive = false
        refCompanySeperatorHeightAnchor?.isActive = false
        referalContainerViewHeightAnchor?.isActive = false
        refCodeTextHeightAnchor = refCodeTextField.heightAnchor.constraint(equalToConstant: textHeight)
        refCodeSeperatorHeightAnchor = refCodeSeperatorView.heightAnchor.constraint(equalToConstant: separatorHeight)
        refNameTextHeightAnchor = refNameTextField.heightAnchor.constraint(equalToConstant: textHeight)
        refNameSeperatorHeightAnchor = refNameSeperatorView.heightAnchor.constraint(equalToConstant: separatorHeight)
        refCompanyTextHeightAnchor = refCompanyTextField.heightAnchor.constraint(equalToConstant: textHeight)
        refCompanySeperatorHeightAnchor = refCompanySeperatorView.heightAnchor.constraint(equalToConstant: separatorHeight)
        referalContainerViewHeightAnchor = referalContainerView.heightAnchor.constraint(equalToConstant: containerHeight)
        refCodeTextHeightAnchor?.isActive = true
        refCodeSeperatorHeightAnchor?.isActive = true
        refNameTextHeightAnchor?.isActive = true
        refNameSeperatorHeightAnchor?.isActive = true
        refCompanyTextHeightAnchor?.isActive = true
        refCompanySeperatorHeightAnchor?.isActive = true
        referalContainerViewHeightAnchor?.isActive = true
    }
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var yourSex: String?
    
    func setupActivityView(){
        view.addSubview(loaderOverlayer)
        loaderOverlayer.addSubview(activityView)
        
        loaderOverlayer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loaderOverlayer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loaderOverlayer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        loaderOverlayer.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        activityView.color = CustomColors.commonBlue1
        activityView.startAnimating()
        activityView.center = self.view.center
        activityView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    @objc func femalesCheck(){
        femaleCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        maleCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        yourSex = "female"
        print("yourSex: ", yourSex!)
    }
    @objc func maleCheck(){
        femaleCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        maleCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        yourSex = "male"
        print("yourSex: ", yourSex!)
    }
    
    @objc func goAC(){
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .region
        acController.autocompleteFilter = filter
        present(acController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        view.backgroundColor = UIColor.white
        selcectedLoginMethod = "facebook"
        //handleFBlogin()
        print("=================================================log")
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(handleFBlogin), userInfo: nil, repeats: false)
        view.addSubview(scrollView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(inputsContainerView)
        scrollView.addSubview(nextButton)
        scrollView.addSubview(avatarTitle)
        
        scrollView.addSubview(referalContainerView)
        referalContainerView.addSubview(referalTitle)
        referalContainerView.addSubview(selectorReferalButton)
        referalContainerView.addSubview(refCodeSeperatorView)
        referalContainerView.addSubview(refCodeTextField)
        referalContainerView.addSubview(refNameSeperatorView)
        referalContainerView.addSubview(refNameTextField)
        referalContainerView.addSubview(refCompanySeperatorView)
        referalContainerView.addSubview(refCompanyTextField)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        avatarTitleView()
        setupActivityView()
        setupNavBarItems()
        setupReferralSegment()
    }
    var refCodeTextHeightAnchor: NSLayoutConstraint?
    var refCodeSeperatorHeightAnchor: NSLayoutConstraint?
    var refNameTextHeightAnchor: NSLayoutConstraint?
    var refNameSeperatorHeightAnchor: NSLayoutConstraint?
    var refCompanyTextHeightAnchor: NSLayoutConstraint?
    var refCompanySeperatorHeightAnchor: NSLayoutConstraint?
    var referalContainerViewHeightAnchor: NSLayoutConstraint?
    func setupReferralSegment(){
        
        scrollView.addSubview(optionsReferalContainer)//portoDiscountButton
        optionsReferalContainer.addSubview(fromPersonReferalButton)
        optionsReferalContainer.addSubview(portoDiscountButton)
        optionsReferalContainer.addSubview(appStoreReferalButton)
        optionsReferalContainer.addSubview(playStoreReferalButton)
        optionsReferalContainer.addSubview(instagramReferalButton)
        optionsReferalContainer.addSubview(facebookReferalButton)
        optionsReferalContainer.addSubview(mfrSiteReferalButton)
        optionsReferalContainer.addSubview(mfrMeetUpReferalButton)
        optionsReferalContainer.addSubview(googleReferalButton)
        optionsReferalContainer.addSubview(otherReferalButton)
        
        referalContainerView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        referalContainerView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        referalContainerView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        referalContainerViewHeightAnchor = referalContainerView.heightAnchor.constraint(equalToConstant: 70)
        referalContainerViewHeightAnchor?.isActive = true
        
        
        referalTitle.leftAnchor.constraint(equalTo:  referalContainerView.leftAnchor, constant: 5).isActive = true
        referalTitle.topAnchor.constraint(equalTo: referalContainerView.topAnchor).isActive = true
        referalTitle.widthAnchor.constraint(equalTo: referalContainerView.widthAnchor).isActive = true
        referalTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        selectorReferalButton.widthAnchor.constraint(equalTo: referalContainerView.widthAnchor).isActive = true
        selectorReferalButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        selectorReferalButton.leftAnchor.constraint(equalTo: referalContainerView.leftAnchor).isActive = true
        selectorReferalButton.topAnchor.constraint(equalTo: referalTitle.bottomAnchor, constant: 10).isActive = true
        selectorReferalButton.titleLabel?.leftAnchor.constraint(equalTo: selectorReferalButton.leftAnchor, constant: 10).isActive = true
        
        optionsReferalContainer.widthAnchor.constraint(equalTo: referalContainerView.widthAnchor).isActive = true
        optionsReferalContainer.heightAnchor.constraint(equalToConstant: 270).isActive = true
        optionsReferalContainer.topAnchor.constraint(equalTo: selectorReferalButton.topAnchor).isActive = true
        optionsReferalContainer.leftAnchor.constraint(equalTo: referalContainerView.leftAnchor).isActive = true
        optionsReferalContainer.isHidden = true
        
        fromPersonReferalButton.topAnchor.constraint(equalTo: optionsReferalContainer.topAnchor).isActive = true
        fromPersonReferalButton.leftAnchor.constraint(equalTo: optionsReferalContainer.leftAnchor).isActive = true
        fromPersonReferalButton.widthAnchor.constraint(equalTo: optionsReferalContainer.widthAnchor).isActive = true
        fromPersonReferalButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        fromPersonReferalButton.titleLabel?.leftAnchor.constraint(equalTo: fromPersonReferalButton.leftAnchor, constant: 10).isActive = true
        
        portoDiscountButton.topAnchor.constraint(equalTo: fromPersonReferalButton.bottomAnchor).isActive = true
        portoDiscountButton.leftAnchor.constraint(equalTo: optionsReferalContainer.leftAnchor).isActive = true
        portoDiscountButton.widthAnchor.constraint(equalTo: optionsReferalContainer.widthAnchor).isActive = true
        portoDiscountButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        portoDiscountButton.titleLabel?.leftAnchor.constraint(equalTo: appStoreReferalButton.leftAnchor, constant: 10).isActive = true
        
        appStoreReferalButton.topAnchor.constraint(equalTo: portoDiscountButton.bottomAnchor).isActive = true
        appStoreReferalButton.leftAnchor.constraint(equalTo: optionsReferalContainer.leftAnchor).isActive = true
        appStoreReferalButton.widthAnchor.constraint(equalTo: optionsReferalContainer.widthAnchor).isActive = true
        appStoreReferalButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        appStoreReferalButton.titleLabel?.leftAnchor.constraint(equalTo: appStoreReferalButton.leftAnchor, constant: 10).isActive = true
        
        playStoreReferalButton.topAnchor.constraint(equalTo: appStoreReferalButton.bottomAnchor).isActive = true
        playStoreReferalButton.leftAnchor.constraint(equalTo: optionsReferalContainer.leftAnchor).isActive = true
        playStoreReferalButton.widthAnchor.constraint(equalTo: optionsReferalContainer.widthAnchor).isActive = true
        playStoreReferalButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        playStoreReferalButton.titleLabel?.leftAnchor.constraint(equalTo: playStoreReferalButton.leftAnchor, constant: 10).isActive = true
        
        instagramReferalButton.topAnchor.constraint(equalTo: playStoreReferalButton.bottomAnchor).isActive = true
        instagramReferalButton.leftAnchor.constraint(equalTo: optionsReferalContainer.leftAnchor).isActive = true
        instagramReferalButton.widthAnchor.constraint(equalTo: optionsReferalContainer.widthAnchor).isActive = true
        instagramReferalButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        instagramReferalButton.titleLabel?.leftAnchor.constraint(equalTo: playStoreReferalButton.leftAnchor, constant: 10).isActive = true
        
        facebookReferalButton.topAnchor.constraint(equalTo: instagramReferalButton.bottomAnchor).isActive = true
        facebookReferalButton.leftAnchor.constraint(equalTo: optionsReferalContainer.leftAnchor).isActive = true
        facebookReferalButton.widthAnchor.constraint(equalTo: optionsReferalContainer.widthAnchor).isActive = true
        facebookReferalButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        facebookReferalButton.titleLabel?.leftAnchor.constraint(equalTo: playStoreReferalButton.leftAnchor, constant: 10).isActive = true
        
        mfrSiteReferalButton.topAnchor.constraint(equalTo: facebookReferalButton.bottomAnchor).isActive = true
        mfrSiteReferalButton.leftAnchor.constraint(equalTo: optionsReferalContainer.leftAnchor).isActive = true
        mfrSiteReferalButton.widthAnchor.constraint(equalTo: optionsReferalContainer.widthAnchor).isActive = true
        mfrSiteReferalButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        mfrSiteReferalButton.titleLabel?.leftAnchor.constraint(equalTo: playStoreReferalButton.leftAnchor, constant: 10).isActive = true
        
        mfrMeetUpReferalButton.topAnchor.constraint(equalTo: mfrSiteReferalButton.bottomAnchor).isActive = true
        mfrMeetUpReferalButton.leftAnchor.constraint(equalTo: optionsReferalContainer.leftAnchor).isActive = true
        mfrMeetUpReferalButton.widthAnchor.constraint(equalTo: optionsReferalContainer.widthAnchor).isActive = true
        mfrMeetUpReferalButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        mfrMeetUpReferalButton.titleLabel?.leftAnchor.constraint(equalTo: playStoreReferalButton.leftAnchor, constant: 10).isActive = true
        
        googleReferalButton.topAnchor.constraint(equalTo: mfrMeetUpReferalButton.bottomAnchor).isActive = true
        googleReferalButton.leftAnchor.constraint(equalTo: optionsReferalContainer.leftAnchor).isActive = true
        googleReferalButton.widthAnchor.constraint(equalTo: optionsReferalContainer.widthAnchor).isActive = true
        googleReferalButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        googleReferalButton.titleLabel?.leftAnchor.constraint(equalTo: googleReferalButton.leftAnchor, constant: 10).isActive = true
        
        otherReferalButton.topAnchor.constraint(equalTo: googleReferalButton.bottomAnchor).isActive = true
        otherReferalButton.leftAnchor.constraint(equalTo: optionsReferalContainer.leftAnchor).isActive = true
        otherReferalButton.widthAnchor.constraint(equalTo: optionsReferalContainer.widthAnchor).isActive = true
        otherReferalButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        otherReferalButton.titleLabel?.leftAnchor.constraint(equalTo: otherReferalButton.leftAnchor, constant: 10).isActive = true
        
        
        refCodeTextField.leftAnchor.constraint(equalTo:  referalContainerView.leftAnchor, constant: 12).isActive = true
        refCodeTextField.topAnchor.constraint(equalTo: selectorReferalButton.bottomAnchor).isActive = true
        refCodeTextField.widthAnchor.constraint(equalTo: referalContainerView.widthAnchor).isActive = true
        refCodeTextHeightAnchor = refCodeTextField.heightAnchor.constraint(equalToConstant: 37)
        refCodeTextHeightAnchor?.isActive = true
        
        refCodeSeperatorView.leftAnchor.constraint(equalTo:  referalContainerView.leftAnchor, constant: 4).isActive = true
        refCodeSeperatorView.centerYAnchor.constraint(equalTo: refCodeTextField.centerYAnchor, constant: 1).isActive = true
        refCodeSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        refCodeSeperatorHeightAnchor = refCodeSeperatorView.heightAnchor.constraint(equalToConstant: 20)
        refCodeSeperatorHeightAnchor?.isActive = true
        
        refNameTextField.leftAnchor.constraint(equalTo:  referalContainerView.leftAnchor, constant: 12).isActive = true
        refNameTextField.topAnchor.constraint(equalTo: refCodeTextField.bottomAnchor).isActive = true
        refNameTextField.widthAnchor.constraint(equalTo: referalContainerView.widthAnchor).isActive = true
        refNameTextHeightAnchor = refNameTextField.heightAnchor.constraint(equalToConstant: 37)
        refNameTextHeightAnchor?.isActive = true
        
        refNameSeperatorView.leftAnchor.constraint(equalTo:  referalContainerView.leftAnchor, constant: 4).isActive = true
        refNameSeperatorView.centerYAnchor.constraint(equalTo: refNameTextField.centerYAnchor, constant: 1).isActive = true
        refNameSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        refNameSeperatorHeightAnchor = refNameSeperatorView.heightAnchor.constraint(equalToConstant: 20)
        refNameSeperatorHeightAnchor?.isActive = true
        
        refCompanyTextField.leftAnchor.constraint(equalTo:  referalContainerView.leftAnchor, constant: 12).isActive = true
        refCompanyTextField.topAnchor.constraint(equalTo: refNameTextField.bottomAnchor).isActive = true
        refCompanyTextField.widthAnchor.constraint(equalTo: referalContainerView.widthAnchor).isActive = true
        refCompanyTextHeightAnchor = refCompanyTextField.heightAnchor.constraint(equalToConstant: 37)
        refCompanyTextHeightAnchor?.isActive = true
        
        refCompanySeperatorView.leftAnchor.constraint(equalTo:  referalContainerView.leftAnchor, constant: 4).isActive = true
        refCompanySeperatorView.centerYAnchor.constraint(equalTo: refCompanyTextField.centerYAnchor, constant: 1).isActive = true
        refCompanySeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        refCompanySeperatorHeightAnchor = refCompanySeperatorView.heightAnchor.constraint(equalToConstant: 20)
        refCompanySeperatorHeightAnchor?.isActive = true
    }
    func setupProfileImageView() {
        profileImageView.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 5).isActive = true
        profileImageView.topAnchor.constraint(equalTo: avatarTitle.bottomAnchor, constant: 10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageViewHeightAnchor?.isActive = true
        profileImageViewWidthAnchor?.isActive = true
    }
    func avatarTitleView() {
        avatarTitle.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 5).isActive = true
        avatarTitle.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 10).isActive = true
        avatarTitle.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        avatarTitleHeightAnchor?.isActive = true
    }
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var ageTextFieldHeightAnchor: NSLayoutConstraint?
    var locTextFieldHeightAnchor: NSLayoutConstraint?
    var locTextTitleHeightAnchor: NSLayoutConstraint?
    var ageTextTitleHeightAnchor: NSLayoutConstraint?
    var nameTextTitleHeightAnchor: NSLayoutConstraint?
    var emailTextTitleHeightAnchor: NSLayoutConstraint?
    var ageSeparatorHeightAnchor: NSLayoutConstraint?
    var locSeparatorHeightAnchor: NSLayoutConstraint?
    var nameSeparatorHeightAnchor: NSLayoutConstraint?
    var emailSeparatorHeightAnchor: NSLayoutConstraint?
    var avatarTitleHeightAnchor: NSLayoutConstraint?
    var profileImageViewHeightAnchor: NSLayoutConstraint?
    var profileImageViewWidthAnchor: NSLayoutConstraint?
    var youeSexTitleheightAnchor: NSLayoutConstraint?
    var femaleCheckboxButtonheightAnchor: NSLayoutConstraint?
    var maleCheckboxButtonheightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        inputsContainerView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 430)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextTitle)
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeperatorView)
        inputsContainerView.addSubview(ageTextTitle)
        inputsContainerView.addSubview(ageTextField)
        inputsContainerView.addSubview(ageSeperatorView)
        inputsContainerView.addSubview(locTextTitle)
        inputsContainerView.addSubview(locTextField)
        inputsContainerView.addSubview(locSeperatorView)
        inputsContainerView.addSubview(emailTextTitle)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeperatorView)
        inputsContainerView.addSubview(youeSexTitle)
        inputsContainerView.addSubview(femaleCheckboxButton)
        inputsContainerView.addSubview(maleCheckboxButton)
        
        nameTextField.delegate = self
        ageTextField.delegate = self
        emailTextField.delegate = self
        
        nameTextTitle.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 3).isActive = true
        nameTextTitle.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: 50).isActive = true
        nameTextTitle.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextTitleHeightAnchor = nameTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/15)
        nameTextTitleHeightAnchor?.isActive = true
        
        nameTextField.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameTextTitle.bottomAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/15)
        nameTextFieldHeightAnchor?.isActive = true
        
        nameSeperatorView.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 4).isActive = true
        nameSeperatorView.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor, constant: 1).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameSeparatorHeightAnchor?.isActive = true
        
        ageTextTitle.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 3).isActive = true
        ageTextTitle.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10).isActive = true
        ageTextTitle.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        ageTextTitleHeightAnchor = ageTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/15)
        ageTextTitleHeightAnchor?.isActive = true
        
        ageTextField.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 12).isActive = true
        ageTextField.topAnchor.constraint(equalTo: ageTextTitle.bottomAnchor).isActive = true
        ageTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        ageTextFieldHeightAnchor = ageTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/15)
        ageTextFieldHeightAnchor?.isActive = true
        
        ageSeperatorView.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 4).isActive = true
        ageSeperatorView.centerYAnchor.constraint(equalTo: ageTextField.centerYAnchor, constant: 1).isActive = true
        ageSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        ageSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        ageSeparatorHeightAnchor?.isActive = true
        
        locTextTitle.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 3).isActive = true
        locTextTitle.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 10).isActive = true
        locTextTitle.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        locTextTitleHeightAnchor = locTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/15)
        locTextTitleHeightAnchor?.isActive = true
        
        locTextField.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 12).isActive = true
        locTextField.topAnchor.constraint(equalTo: locTextTitle.bottomAnchor).isActive = true
        locTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        locTextFieldHeightAnchor = locTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/15)
        locTextFieldHeightAnchor?.isActive = true
        
        locSeperatorView.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 4).isActive = true
        locSeperatorView.centerYAnchor.constraint(equalTo: locTextField.centerYAnchor, constant: 1).isActive = true
        locSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        locSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        locSeparatorHeightAnchor?.isActive = true
        
        emailTextTitle.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 3).isActive = true
        emailTextTitle.topAnchor.constraint(equalTo: locTextField.bottomAnchor, constant: 10).isActive = true
        emailTextTitle.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextTitleHeightAnchor = emailTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/15)
        emailTextTitleHeightAnchor?.isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: emailTextTitle.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/15)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailSeperatorView.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 4).isActive = true
        emailSeperatorView.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor, constant: 1).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        youeSexTitle.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 4).isActive = true
        youeSexTitle.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor, constant: 10).isActive = true
        youeSexTitle.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        youeSexTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        femaleCheckboxButton.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 4).isActive = true
        femaleCheckboxButton.topAnchor.constraint(equalTo: youeSexTitle.bottomAnchor).isActive = true
        femaleCheckboxButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1/2).isActive = true
        femaleCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        femaleCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: femaleCheckboxButton.leftAnchor).isActive = true
        
        
        maleCheckboxButton.leftAnchor.constraint(equalTo: femaleCheckboxButton.rightAnchor).isActive = true
        maleCheckboxButton.topAnchor.constraint(equalTo: youeSexTitle.bottomAnchor).isActive = true
        maleCheckboxButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1/2).isActive = true
        maleCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        maleCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: maleCheckboxButton.leftAnchor).isActive = true
    }
    func setupLoginRegisterButton() {
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: referalContainerView.bottomAnchor, constant: 12).isActive = true
        nextButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -190).isActive = true
    }
    @objc func handleFBlogin(){

        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email", "user_gender"], from: self) { (result, err) in
       
    
            if err != nil {
                let alert = UIAlertController(title: "Error", message: err?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("buttonFBlogin failed:", err!)
            }
            self.showFBGraphParameters()
        }
    }
    @objc func showFBGraphParameters(){
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, email, name, gender, picture.type(large)"]).start() {
            (connection, result, err)  in
            
            if err != nil {
                let alert = UIAlertController(title: "Error", message: err?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("Failed to start graph request: ", err!)
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                        self.goBack()
                    }))
                    self.present(alert, animated: true)
                    print("Failed to start graph request: ", error!)
                    return
                }
                var uid = user?.uid
                let ref = Database.database().reference().child("users").child(uid!)
                ref.observeSingleEvent(of: .value, with: { (snap) in
                    if snap.exists(){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newSignin"), object: nil)
                        self.messagesController?.refreshMessages()
                        self.dismiss(animated: true, completion: nil)
                        
                    } else {
                        self.loaderOverlayer.isHidden = true
                        do {
                            try Auth.auth().signOut()
                        }
                        catch let logoutError {
                            print (logoutError)
                        }
                        uid = Auth.auth().currentUser?.uid
                        guard let userInfo = result as? [String: Any] else {  return }
                        let fbUserEmail = userInfo["email"] as? String
                        let fbUserGender = userInfo["gender"] as? String
                        let fbUserId = userInfo["id"] as? String
                        let fbUserName = userInfo["name"] as? String
                        let fbUserPic = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String
                        self.nameTextField.text = fbUserName
                        fb_userId = fbUserId
                        if fbUserEmail != nil {
                            self.emailTextField.text = fbUserEmail
                        }
                        if fbUserPic != nil {
                            self.profileImageView.loadImageusingCacheWithUrlString(urlString: fbUserPic!)
                        }
                        if fbUserGender != nil {
                            if fbUserGender == "male" {
                                self.maleCheck()
                            } else if fbUserGender == "female" {
                                self.femalesCheck()
                            }
                        }
                    }
                })
            }
        }
    }
    @objc func goBack() {
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false) {
            let loginMethodController = LoginMethodController()
            pvc?.present(loginMethodController, animated: false, completion: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    func setupNavBarItems(){
        //        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.lightOrange1]
        let backImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        //        self.navigationItem.title = "My friends"
    }
}
extension FBLoginController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        locTextField.text = place.formattedAddress
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
