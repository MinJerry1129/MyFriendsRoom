//
//  LoginMethodController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 14.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

class LoginMethodController: UIViewController {
    let loginMethodTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Sign up or sign in with"
        tt.font = UIFont.systemFont(ofSize: 20)
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        return tt
    }()
    var facebookButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = CustomColors.facebookColor
        button.setTitle("Facebook", for: [])
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textColor = UIColor.white
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(goToFBLoginController), for: .touchUpInside)
        return button
    }()
    let emailButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = CustomColors.commonGrey1
        button.setTitle("Email", for: [])
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textColor = UIColor.white
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(goToLoginController), for: .touchUpInside)
        return button
    }()
    let termsButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(termsCheck), for: .touchUpInside)
        cb.layer.cornerRadius = 2
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.backgroundColor = UIColor.white
        cb.layer.borderWidth = 1
        cb.layer.borderColor = CustomColors.commonGrey1.cgColor
        return cb
    }()
    let ageButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(ageCheck), for: .touchUpInside)
        cb.layer.cornerRadius = 2
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.backgroundColor = UIColor.white
        cb.layer.borderWidth = 1
        cb.layer.borderColor = CustomColors.commonGrey1.cgColor
        return cb
    }()
    let termsText: UITextView = {
        let tt = UITextView()
        let str = "I agree to the terms set out in the Terms and Conditions and Privacy Policy of My Friends Room Limited. I understand that there is no tolerance for the uploading of objectionable content or abusive users. For more information please refer to Members’ Obligations and Warranties in our Terms and Conditions."
        let attributedStr = NSMutableAttributedString.init(string: str)
        let termUrl = URL(string: "https://www.myfriendsroom.com/vacationrentals/terms-privacy-app/")!
        let privacyUrl = URL(string: "https://www.myfriendsroom.com/vacationrentals/privacy-policy/")!
        attributedStr.setAttributes([.link: termUrl], range: NSRange(location: 36, length: 20))
        attributedStr.setAttributes([.link: privacyUrl], range: NSRange(location: 61, length: 14))
        attributedStr.addAttribute(.foregroundColor, value: CustomColors.commonGrey1, range: NSRange(location: 0, length: str.count))
        tt.attributedText = attributedStr
        tt.isUserInteractionEnabled = true
        tt.isEditable = false
        tt.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: CustomColors.commonBlue1]
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.font = .systemFont(ofSize: 14)
        return tt
    }()
    let ageText: UITextView = {
        let tt = UITextView()
        tt.text  = "I confirm that I am over 18 years of age"
        tt.textColor = CustomColors.commonGrey1
        tt.isUserInteractionEnabled = false
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.font = .systemFont(ofSize: 14)
        return tt
    }()
    var termsChecked = false
    var ageChecked = false
    @objc func termsCheck() {
        var backgroundcolor = UIColor()
        if termsChecked == true {
            backgroundcolor = UIColor.white
            termsButton.layer.borderColor = CustomColors.commonGrey1.cgColor
            termsChecked = false
        } else {
            backgroundcolor = CustomColors.lightOrange1
            termsButton.layer.borderColor = CustomColors.lightOrange1.cgColor
            termsChecked = true
        }
        termsButton.backgroundColor = backgroundcolor
    }
    @objc func ageCheck() {
        var backgroundcolor = UIColor()
        if ageChecked == true {
            backgroundcolor = UIColor.white
            ageButton.layer.borderColor = CustomColors.commonGrey1.cgColor
            ageChecked = false
        } else {
            backgroundcolor = CustomColors.lightOrange1
            ageButton.layer.borderColor = CustomColors.lightOrange1.cgColor
            ageChecked = true
        }
        ageButton.backgroundColor = backgroundcolor
    }
    var allChecked = false
    func checkTermsAgeisChecked() {
        if termsChecked == true && ageChecked == true {
            allChecked = true
        }else {
            allChecked = false
        }
    }
    
    @objc func goToLoginController(){
        checkTermsAgeisChecked()
        if allChecked == true {
            weak var pvc = self.presentingViewController
            self.dismiss(animated: false) {
                let loginController = LoginController()
                let loginControllerNav = UINavigationController(rootViewController: loginController)
                pvc?.present(loginControllerNav, animated: false, completion: nil)
            }
        } else {
            userDidNotAcceptAlert()
        }
    }
    @objc func goToFBLoginController(){
        checkTermsAgeisChecked()
        if allChecked == true {
            weak var pvc = self.presentingViewController
            self.dismiss(animated: false) {
                let fbLoginController = FBLoginController()
                let fbLoginControllerNav = UINavigationController(rootViewController: fbLoginController)
                pvc?.present(fbLoginControllerNav, animated: false, completion: nil)
            }
        } else {
            userDidNotAcceptAlert()
        }
    }
    func userDidNotAcceptAlert(){
        let alert = UIAlertController(title: "Notice", message: "Please accept our terms and privacy condition and make sure you are over 18 years old", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func setupLoginMethod(){
        view.addSubview(loginMethodTitle)
        view.addSubview(facebookButton)
        view.addSubview(emailButton)
        view.addSubview(ageText)
        view.addSubview(ageButton)
        view.addSubview(termsText)
        view.addSubview(termsButton)
        
        loginMethodTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        loginMethodTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20).isActive = true
        loginMethodTitle.widthAnchor.constraint(equalToConstant: 290).isActive = true
        loginMethodTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        facebookButton.topAnchor.constraint(equalTo: loginMethodTitle.bottomAnchor, constant: 100).isActive = true
        facebookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookButton.widthAnchor.constraint(equalTo: loginMethodTitle.widthAnchor).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        emailButton.topAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: 20).isActive = true
        emailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailButton.widthAnchor.constraint(equalTo: loginMethodTitle.widthAnchor).isActive = true
        emailButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        ageText.topAnchor.constraint(equalTo: emailButton.bottomAnchor, constant: 23).isActive = true
        ageText.rightAnchor.constraint(equalTo: emailButton.rightAnchor).isActive = true
        ageText.leftAnchor.constraint(equalTo: ageButton.rightAnchor, constant: 20).isActive = true
        ageText.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        ageButton.topAnchor.constraint(equalTo: emailButton.bottomAnchor, constant: 30).isActive = true
        ageButton.leftAnchor.constraint(equalTo: emailButton.leftAnchor).isActive = true
        ageButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        ageButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        termsText.topAnchor.constraint(equalTo: ageText.bottomAnchor).isActive = true
        termsText.rightAnchor.constraint(equalTo: ageText.rightAnchor).isActive = true
        termsText.leftAnchor.constraint(equalTo: ageText.leftAnchor).isActive = true
        termsText.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        termsButton.topAnchor.constraint(equalTo: ageText.bottomAnchor, constant: 19).isActive = true
        termsButton.leftAnchor.constraint(equalTo: ageButton.leftAnchor).isActive = true
        termsButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        termsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupLoginMethod()
    }
}
