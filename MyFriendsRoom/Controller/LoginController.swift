//
//  LoginController.swift
//  MyFriendsRoom
//
//  Created by Ал on 28.08.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import GoogleMaps
import GooglePlaces

var global_acceptingGuests: String?
var global_whatDYDTextField: String?
var global_aboutMeTextField: String?
var global_meetChecked: Bool?
var global_dateChecked: Bool?
var global_travelChecked: Bool?

class LoginController: UIViewController, UITextFieldDelegate {
    
    var defaultAvatarWasChanged = false
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
    lazy var restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Restore password", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(CustomColors.commonBlue1, for: [])
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(restorePassword), for: .touchUpInside)
        return button
    }()
    @objc func restorePassword(){
        let alert = UIAlertController(title: "Please enter an Email from your account", message:  "Password reset email will be send to your email adress", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { email in
            email.placeholder = "Input your email here..."
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let email = alert.textFields?.first?.text {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    var title: String?
                    var message: String?
                    if error == nil {
                        title = "Check your email"
                        message = nil
                    } else {
                        title = "Error"
                        message = error?.localizedDescription
                    }
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }))
        alert.textFields?.first?.keyboardType = UIKeyboardType.emailAddress
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
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
        loaderOverlayer.isHidden = true
    }//nameTextField ageTextField emailTextField passwordTextField repeatPpasswordTextField
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
            if ageTextField.text == "" {
                attention = "Age is required"
                isOk = false
            } else if Int(ageTextField.text!) == nil {
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
        } else if textField == passwordTextField {
            if (passwordTextField.text?.count)! < 6 {
                attention = "Age can not be less than 6 characters"
                isOk = false
            } else {
                isOk = true
            }
        } else if textField == repeatPpasswordTextField {
            if passwordTextField.text != repeatPpasswordTextField.text {
                attention = "Passwords do not match"
                repeatPasswordTextTitle.textColor = CustomColors.lightOrange1
            } else {
                repeatPasswordTextTitle.textColor = CustomColors.commonGrey1
            }
            isOk = true
        }
        if isOk == false {
            let alert = UIAlertController(title: "Notice", message: attention, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        return isOk
    }
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            var nameIsOk = false
            var ageIsOk = false
            var emailIsOk = false
            var locIsOk = false
            var genderIsOk = false
            var passIsOk = false
            var passMatchIsOk = false
            var picIsOc = false
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
            if profileImageView.image != UIImage(named: "emptyavatar") {
                avatarTitle.textColor = CustomColors.commonGrey1
                picIsOc = true
            } else {
                avatarTitle.textColor = CustomColors.lightOrange1
                picIsOc = false
            }
            if nameTextField.text == "" || nameTextField.text == "DELETED" {
                nameTextTitle.textColor = CustomColors.lightOrange1
                nameIsOk = false
            } else {
                nameTextTitle.textColor = CustomColors.commonGrey1
                nameIsOk = true
            }
            
            if ageTextField.text == "" || Int(ageTextField.text!)! < 18 || Int(ageTextField.text!)! > 100 {
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
            if (passwordTextField.text?.count)! < 6 {
                passwordTextTitle.textColor = CustomColors.lightOrange1
                passIsOk = false
            } else {
                passwordTextTitle.textColor = CustomColors.commonGrey1
                passIsOk = true
            }
            if passwordTextField.text == repeatPpasswordTextField.text {
                passMatchIsOk = true
                repeatPasswordTextTitle.textColor = CustomColors.commonGrey1
            } else {
                passMatchIsOk = false
                repeatPasswordTextTitle.textColor = CustomColors.lightOrange1
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
            if nameIsOk == true && ageIsOk == true && emailIsOk == true && passIsOk == true && passMatchIsOk == true && genderIsOk == true && locIsOk == true && picIsOc == true && referalSelectedIsOk == true && referalFromPersonIsOk == true{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissWish"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                self.messagesController?.refreshMessages()
                let welcomeC = WelcomeController()
                welcomeC.loginController = self
                let welcomeCNav = UINavigationController(rootViewController: welcomeC)
                self.present(welcomeCNav, animated: true, completion: nil)
            } else if nameIsOk == true && ageIsOk == true && emailIsOk == true && passIsOk == true && passMatchIsOk == false && genderIsOk == true && locIsOk == true && picIsOc == true {
                message = "Passwords do not match"
//                let alert = UIAlertController(title: "Notice", message: "Passwords do not match", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true)
            } else if nameIsOk == true && ageIsOk == true && emailIsOk == true && passIsOk == true && passMatchIsOk == true && genderIsOk == true && locIsOk == true && picIsOc == false {
                message = "The profile picture is mandatory"
//                let alert = UIAlertController(title: "Notice", message: "The profile picture is mandatory", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true)
            } else if referalSelectedIsOk == false {
                message = "Select one option"
            } else if referalFromPersonIsOk == false {
                message = "Fill one of the fields or select another option"
            } else {
                message = "Please check and make sure all the fields are filled correctly"
//                let alert = UIAlertController(title: "Notice", message: "Please check and make sure all the fields are filled correctly", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true)
            }
            if message != nil {
                let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
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
        let backImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
    }
    @objc func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            let alert = UIAlertController(title: "Error", message: "Form is not valid", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
                print("Form is not valid")
                return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                print(error!)
                return
            }
//            print(Auth.auth().currentUser?.uid)
//            self.TabBarController().takeAllContactsList()
            print("go to mes controller and reload")
            self.messagesController?.refreshMessages()
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissWish"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newSignin"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            self.dismiss(animated: true, completion: nil)
            
        })
    }
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
    let passwordTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Password"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "enter your password...", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    let passwordSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let repeatPasswordTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Repeat password"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    let repeatPpasswordTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "repeat password...", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.textColor = CustomColors.commonBlue1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    let repeatPpasswordSeperatorView: UIView = {
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
        tt.font = .systemFont(ofSize: 17)
        return tt
    }()
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

    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = CustomColors.commonBlue1
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
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
    var fromPerson = false//portoDiscountReferalSelect portoDiscountButton
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
    var yourSex: String?
    @objc func femalesCheck(){
        femaleCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        maleCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        yourSex = "female"
    }
    @objc func maleCheck(){
        femaleCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        maleCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        yourSex = "male"
    }
    @objc func handleLoginRegisterChange() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            nextButton.setTitle("Login", for: [])
        } else {
            nextButton.setTitle("Next", for: [])
        }
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 180 : 450
        let referalContainerHeight: CGFloat
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            optionsReferalContainer.isHidden = true
            referalContainerHeight = 0
        } else {
            if fromPerson == false {
                referalContainerHeight = 70
            } else {
                referalContainerHeight = 181
            }
        }
        referalContainerViewHeightAnchor?.isActive = false
        referalContainerViewHeightAnchor = referalContainerView.heightAnchor.constraint(equalToConstant: referalContainerHeight)
        referalContainerViewHeightAnchor?.isActive = true
        
        nameTextFieldHeightAnchor?.isActive = false
//        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)  (equalToConstant: 27)
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
//        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 27 : 27)
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalToConstant: 27)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
//        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 27 : 27)
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalToConstant: 27)
        passwordTextFieldHeightAnchor?.isActive = true
        
        ageTextFieldHeightAnchor?.isActive = false
//        ageTextFieldHeightAnchor = ageTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        ageTextFieldHeightAnchor = ageTextField.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        ageTextFieldHeightAnchor?.isActive = true
        
        locTextFieldHeightAnchor?.isActive = false
//        locTextFieldHeightAnchor = locTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        locTextFieldHeightAnchor = locTextField.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        locTextFieldHeightAnchor?.isActive = true
        
        locTextTitleHeightAnchor?.isActive = false
//        locTextTitleHeightAnchor = locTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        locTextTitleHeightAnchor = locTextTitle.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        locTextTitleHeightAnchor?.isActive = true
        
        ageTextTitleHeightAnchor?.isActive = false
//        ageTextTitleHeightAnchor = ageTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        ageTextTitleHeightAnchor = ageTextTitle.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        ageTextTitleHeightAnchor?.isActive = true
        
        nameTextTitleHeightAnchor?.isActive = false
//        nameTextTitleHeightAnchor = nameTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        nameTextTitleHeightAnchor = nameTextTitle.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        nameTextTitleHeightAnchor?.isActive = true
        
        passwordTextTitleHeightAnchor?.isActive = false
//        passwordTextTitleHeightAnchor = passwordTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 27 : 27)
        passwordTextTitleHeightAnchor = passwordTextTitle.heightAnchor.constraint(equalToConstant: 27)
        passwordTextTitleHeightAnchor?.isActive = true
        
        emailTextTitleHeightAnchor?.isActive = false
//        emailTextTitleHeightAnchor = emailTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 27 : 27)
        emailTextTitleHeightAnchor = emailTextTitle.heightAnchor.constraint(equalToConstant: 27)
        emailTextTitleHeightAnchor?.isActive = true
        
        nameSeparatorHeightAnchor?.isActive = false
        nameSeparatorHeightAnchor = nameSeperatorView.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 20)
        nameSeparatorHeightAnchor?.isActive = true
        
        locSeparatorHeightAnchor?.isActive = false
        locSeparatorHeightAnchor = locSeperatorView.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 20)
        locSeparatorHeightAnchor?.isActive = true
        
        ageSeparatorHeightAnchor?.isActive = false
        ageSeparatorHeightAnchor = ageSeperatorView.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 20)
        ageSeparatorHeightAnchor?.isActive = true
        
        avatarTitleHeightAnchor?.isActive = false
//        avatarTitleHeightAnchor = avatarTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        avatarTitleHeightAnchor = avatarTitle.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        avatarTitleHeightAnchor?.isActive = true
        
        profileImageViewHeightAnchor?.isActive = false
        profileImageViewHeightAnchor = profileImageView.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 50)
        profileImageViewHeightAnchor?.isActive = true
        
        profileImageViewWidthAnchor?.isActive = false
        profileImageViewWidthAnchor = profileImageView.widthAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 50)
        profileImageViewWidthAnchor?.isActive = true
        
        youeSexTitleheightAnchor?.isActive = false
        youeSexTitleheightAnchor = youeSexTitle.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 30)
        youeSexTitleheightAnchor?.isActive = true
        
        femaleCheckboxButtonheightAnchor?.isActive = false
        femaleCheckboxButtonheightAnchor = femaleCheckboxButton.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 30)
        femaleCheckboxButtonheightAnchor?.isActive = true
        
        maleCheckboxButtonheightAnchor?.isActive = false
        maleCheckboxButtonheightAnchor = maleCheckboxButton.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 30)
        maleCheckboxButtonheightAnchor?.isActive = true

        repeatPasswordTextFieldHeightAnchor?.isActive = false
//        repeatPasswordTextFieldHeightAnchor = repeatPpasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        repeatPasswordTextFieldHeightAnchor = repeatPpasswordTextField.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        repeatPasswordTextFieldHeightAnchor?.isActive = true

        repeatPasswordTextTitleHeightAnchor?.isActive = false
//        repeatPasswordTextTitleHeightAnchor = repeatPasswordTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        repeatPasswordTextTitleHeightAnchor = repeatPasswordTextTitle.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 27)
        repeatPasswordTextTitleHeightAnchor?.isActive = true

        repeatPasswordSeparatorHeightAnchor?.isActive = false
        repeatPasswordSeparatorHeightAnchor = repeatPpasswordSeperatorView.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 20)
        repeatPasswordSeparatorHeightAnchor?.isActive = true
        
        
        restoreButtonHeightAnchor?.isActive = false
        restoreButtonHeightAnchor = restoreButton.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 30 : 0)
        restoreButtonHeightAnchor?.isActive = true
        
        
        restoreButtonTopAnchor?.isActive = false
        restoreButtonTopAnchor = restoreButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 15 : 0)
        restoreButtonTopAnchor?.isActive = true
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
        selcectedLoginMethod = "email"
        
        view.addSubview(scrollView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(inputsContainerView)
        scrollView.addSubview(nextButton)
        scrollView.addSubview(loginRegisterSegmentedControl)
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
        setupLoginRegisterSegmentedControl()
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
        
        scrollView.addSubview(optionsReferalContainer)
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
    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
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
        avatarTitleHeightAnchor = passwordTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/17)
        avatarTitleHeightAnchor?.isActive = true
    }
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var ageTextFieldHeightAnchor: NSLayoutConstraint?
    var locTextFieldHeightAnchor: NSLayoutConstraint?
    var locTextTitleHeightAnchor: NSLayoutConstraint?
    var ageTextTitleHeightAnchor: NSLayoutConstraint?
    var nameTextTitleHeightAnchor: NSLayoutConstraint?
    var passwordTextTitleHeightAnchor: NSLayoutConstraint?
    var emailTextTitleHeightAnchor: NSLayoutConstraint?
    var ageSeparatorHeightAnchor: NSLayoutConstraint?
    var locSeparatorHeightAnchor: NSLayoutConstraint?
    var nameSeparatorHeightAnchor: NSLayoutConstraint?
    var passwordSeparatorHeightAnchor: NSLayoutConstraint?
    var emailSeparatorHeightAnchor: NSLayoutConstraint?
    var avatarTitleHeightAnchor: NSLayoutConstraint?
    var profileImageViewHeightAnchor: NSLayoutConstraint?
    var profileImageViewWidthAnchor: NSLayoutConstraint?
    var youeSexTitleheightAnchor: NSLayoutConstraint?
    var femaleCheckboxButtonheightAnchor: NSLayoutConstraint?
    var maleCheckboxButtonheightAnchor: NSLayoutConstraint?
    var repeatPasswordTextFieldHeightAnchor: NSLayoutConstraint?
    var repeatPasswordTextTitleHeightAnchor: NSLayoutConstraint?
    var repeatPasswordSeparatorHeightAnchor: NSLayoutConstraint?
    var restoreButtonHeightAnchor: NSLayoutConstraint?
    var restoreButtonTopAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.topAnchor.constraint(equalTo: loginRegisterSegmentedControl.bottomAnchor, constant: 10).isActive = true
        inputsContainerView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 450)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextTitle)
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeperatorView)
        inputsContainerView.addSubview(ageTextTitle)
        inputsContainerView.addSubview(ageTextField)
        inputsContainerView.addSubview(ageSeperatorView)
        inputsContainerView.addSubview(locTextTitle)
        inputsContainerView.addSubview(locTextField)//
        inputsContainerView.addSubview(locSeperatorView)
        inputsContainerView.addSubview(emailTextTitle)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeperatorView)
        inputsContainerView.addSubview(passwordTextTitle)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(passwordSeperatorView)
        inputsContainerView.addSubview(repeatPasswordTextTitle)
        inputsContainerView.addSubview(repeatPpasswordTextField)
        inputsContainerView.addSubview(repeatPpasswordSeperatorView)
        inputsContainerView.addSubview(youeSexTitle)
        inputsContainerView.addSubview(femaleCheckboxButton)
        inputsContainerView.addSubview(maleCheckboxButton)
        view.addSubview(restoreButton)
        
        nameTextField.delegate = self
        ageTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPpasswordTextField.delegate = self
        
        nameTextTitle.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 3).isActive = true
        nameTextTitle.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextTitle.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        nameTextTitleHeightAnchor = nameTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/17)
        nameTextTitleHeightAnchor = nameTextTitle.heightAnchor.constraint(equalToConstant: 27)
        nameTextTitleHeightAnchor?.isActive = true
        
        nameTextField.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameTextTitle.bottomAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/17)
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: 27)
        nameTextFieldHeightAnchor?.isActive = true
        
        nameSeperatorView.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 4).isActive = true
        nameSeperatorView.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor, constant: 1).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameSeparatorHeightAnchor?.isActive = true
        
        ageTextTitle.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 3).isActive = true
        ageTextTitle.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10).isActive = true
        ageTextTitle.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        ageTextTitleHeightAnchor = ageTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/17)
        ageTextTitleHeightAnchor = ageTextTitle.heightAnchor.constraint(equalToConstant: 27)
        ageTextTitleHeightAnchor?.isActive = true
        
        ageTextField.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 12).isActive = true
        ageTextField.topAnchor.constraint(equalTo: ageTextTitle.bottomAnchor).isActive = true
        ageTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        ageTextFieldHeightAnchor = ageTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/17)
        ageTextFieldHeightAnchor = ageTextField.heightAnchor.constraint(equalToConstant: 27)
        ageTextFieldHeightAnchor?.isActive = true
        
        ageSeperatorView.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 4).isActive = true
        ageSeperatorView.centerYAnchor.constraint(equalTo: ageTextField.centerYAnchor, constant: 1).isActive = true
        ageSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        ageSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        ageSeparatorHeightAnchor?.isActive = true
        
        locTextTitle.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 3).isActive = true
        locTextTitle.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 10).isActive = true
        locTextTitle.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        locTextTitleHeightAnchor = locTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/17)
        locTextTitleHeightAnchor = locTextTitle.heightAnchor.constraint(equalToConstant: 27)
        locTextTitleHeightAnchor?.isActive = true
        
        locTextField.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 12).isActive = true
        locTextField.topAnchor.constraint(equalTo: locTextTitle.bottomAnchor).isActive = true
        locTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        locTextFieldHeightAnchor = locTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/17)
        locTextFieldHeightAnchor = locTextField.heightAnchor.constraint(equalToConstant: 27)
        locTextFieldHeightAnchor?.isActive = true
        
        locSeperatorView.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 4).isActive = true
        locSeperatorView.centerYAnchor.constraint(equalTo: locTextField.centerYAnchor, constant: 1).isActive = true
        locSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        locSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        locSeparatorHeightAnchor?.isActive = true
        
        emailTextTitle.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 3).isActive = true
        emailTextTitle.topAnchor.constraint(equalTo: locTextField.bottomAnchor, constant: 10).isActive = true
        emailTextTitle.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        emailTextTitleHeightAnchor = emailTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/17)
        emailTextTitleHeightAnchor = emailTextTitle.heightAnchor.constraint(equalToConstant: 27)
        emailTextTitleHeightAnchor?.isActive = true

        emailTextField.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: emailTextTitle.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/17)
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalToConstant: 27)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailSeperatorView.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 4).isActive = true
        emailSeperatorView.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor, constant: 1).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        passwordTextTitle.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 3).isActive = true
        passwordTextTitle.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextTitle.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        passwordTextTitleHeightAnchor = passwordTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/17)
        passwordTextTitleHeightAnchor = passwordTextTitle.heightAnchor.constraint(equalToConstant: 27)
        passwordTextTitleHeightAnchor?.isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: passwordTextTitle.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/17)
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalToConstant: 27)
        passwordTextFieldHeightAnchor?.isActive = true
        
        passwordSeperatorView.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 4).isActive = true
        passwordSeperatorView.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor, constant: 1).isActive = true
        passwordSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        passwordSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        repeatPasswordTextTitle.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 3).isActive = true
        repeatPasswordTextTitle.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        repeatPasswordTextTitle.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        repeatPasswordTextTitleHeightAnchor = repeatPasswordTextTitle.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/17)
        repeatPasswordTextTitleHeightAnchor = repeatPasswordTextTitle.heightAnchor.constraint(equalToConstant: 27)
        repeatPasswordTextTitleHeightAnchor?.isActive = true

        repeatPpasswordTextField.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 12).isActive = true
        repeatPpasswordTextField.topAnchor.constraint(equalTo: repeatPasswordTextTitle.bottomAnchor).isActive = true
        repeatPpasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        repeatPasswordTextFieldHeightAnchor = repeatPpasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/17)
        repeatPasswordTextFieldHeightAnchor = repeatPpasswordTextField.heightAnchor.constraint(equalToConstant: 27)
        repeatPasswordTextFieldHeightAnchor?.isActive = true

        repeatPpasswordSeperatorView.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 4).isActive = true
        repeatPpasswordSeperatorView.centerYAnchor.constraint(equalTo: repeatPpasswordTextField.centerYAnchor, constant: 1).isActive = true
        repeatPpasswordSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        repeatPpasswordSeperatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        youeSexTitle.leftAnchor.constraint(equalTo:  inputsContainerView.leftAnchor, constant: 4).isActive = true
        youeSexTitle.topAnchor.constraint(equalTo: repeatPpasswordTextField.bottomAnchor, constant: 10).isActive = true
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
        
        restoreButtonTopAnchor = restoreButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor)
        restoreButtonTopAnchor?.isActive = true
        restoreButton.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor).isActive = true
        restoreButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        restoreButtonHeightAnchor = restoreButton.heightAnchor.constraint(equalToConstant: 0)
        restoreButtonHeightAnchor?.isActive = true
        restoreButton.titleLabel?.leftAnchor.constraint(equalTo: restoreButton.leftAnchor).isActive = true
//        restoreButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -190).isActive = true
    }
    func setupLoginRegisterButton() {
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: referalContainerView.bottomAnchor, constant: 12).isActive = true
        nextButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -190).isActive = true
    }
}
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
    self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
extension LoginController: GMSAutocompleteViewControllerDelegate {
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

//extension UITextField {
//
//    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        return false
//    }
//}
