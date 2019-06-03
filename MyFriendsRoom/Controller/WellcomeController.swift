//
//  WellcomeController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 18.09.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
import Font_Awesome_Swift

class WelcomeController: UIViewController, UITextViewDelegate{
    var fbLoginController: FBLoginController?
    var loginController: LoginController?
    var wellcomeControler: WelcomeController?
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor.white
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.layer.masksToBounds = true
        return sv
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
    let lookingForContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let acceptingGuestsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let agYesCheckboxButton: UIButton = {
        let tcb = UIButton()
        tcb.addTarget(self, action: #selector(agYesCheck), for: .touchUpInside)
        tcb.translatesAutoresizingMaskIntoConstraints = false
        tcb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  yes", size: 20, forState: .normal)
        tcb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return tcb
    }()
    let agNoCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(agNoCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  no", size: 20, forState: .normal)
        cb.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        return cb
    }()
    let agMaybeCheckboxButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(agMaybeCheck), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setFAText(prefixText: "", icon: .FASquare, postfixText: "  maybe", size: 20, forState: .normal)
        cb.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        return cb
    }()
    
    let welcomeTextsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let welcomeTitle: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.lightOrange1
        tt.text = "Welcome to"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 25)
        return tt
    }()
    let mfrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "my_friends_room_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
//    let mfrMyTitle: UITextView = {
//        let tt = UITextView()
//        let attributedStr = NSMutableAttributedString.init(string: "MyFriendsRoom")
//        attributedStr.addAttribute(.foregroundColor, value: CustomColors.commonGrey1, range: NSRange(location: 0, length: 13))
//        attributedStr.addAttribute(.foregroundColor, value: CustomColors.commonBlue1, range: NSRange(location: 2, length: 7))
//        tt.attributedText = attributedStr
//        tt.font = .systemFont(ofSize: 25)
//        tt.translatesAutoresizingMaskIntoConstraints = false
//        tt.isUserInteractionEnabled = false
//        return tt
//    }()
    let welcomeText: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "We would like to know more about you\nso we can connect you with the right people. You can change these options later."
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 15)
        return tt
    }()
    let whatDYDTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "What do you do?"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 22)
        return tt
    }()
    let whatDYDTextField: UITextView = {
        let tf = UITextView()
//        tf.attributedPlaceholder = NSAttributedString(string: "...", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.text = "..."
        tf.textColor = CustomColors.commonGrey1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 20)
        return tf
    }()
    let whatDYDSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let aboutMeTextTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Write a few words about you"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 22)
        return tt
    }()
    let aboutMeTextField: UITextView = {
        let tf = UITextView()
//        tf.attributedPlaceholder = NSAttributedString(string: "...", attributes: [NSAttributedStringKey.foregroundColor: CustomColors.commonBlue1])
        tf.text = "..."
        tf.textColor = CustomColors.commonGrey1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 20)
        return tf
    }()
    let aboutMeSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.commonGrey1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let lookingForTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "What are you looking for?"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 22)
        return tt
    }()
    let agTitle: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Are you accepting guests\nat home?"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 22)
        return tt
    }()
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Register", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(CustomColors.commonBlue1, for: [])
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    func estimateFrameForText(text: String) -> CGRect {
        let width = 280
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20)], context: nil)
    }
    func textViewDidChange(_ textView: UITextView){
        print("asd")
        if textView == whatDYDTextField {//whatDYDSeperatorViewHeightAnchor aboutMeSeperatorViewHeightAnchor
            print("asd")
            self.whatDYDSeperatorViewHeightAnchor?.isActive  = false
            self.whatDYDTextFieldHeightAnchor?.isActive  = false
            if self.whatDYDTextField.text != "" {
                let height1 = self.estimateFrameForText(text: self.whatDYDTextField.text!).height + 18
                whatDYDTextFieldHeightAnchor = whatDYDTextField.heightAnchor.constraint(equalToConstant: height1)
                whatDYDSeperatorViewHeightAnchor = whatDYDSeperatorView.heightAnchor.constraint(equalToConstant: height1 - 5)
                print(height1)
            }
            self.whatDYDSeperatorViewHeightAnchor?.isActive  = true
            self.whatDYDTextFieldHeightAnchor?.isActive  = true
        } else if textView == aboutMeTextField{
            self.aboutMeSeperatorViewHeightAnchor?.isActive  = false
            self.aboutMeTextFieldHeightAnchor?.isActive  = false
            if self.aboutMeTextField.text != "" {
                let height2 = self.estimateFrameForText(text: self.aboutMeTextField.text!).height + 18
                aboutMeTextFieldHeightAnchor = aboutMeTextField.heightAnchor.constraint(equalToConstant: height2)
                aboutMeSeperatorViewHeightAnchor = aboutMeSeperatorView.heightAnchor.constraint(equalToConstant: height2 - 5)
            }
            self.aboutMeSeperatorViewHeightAnchor?.isActive  = true
            self.aboutMeTextFieldHeightAnchor?.isActive  = true
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        let placeholder = "..."
        if textView.textColor == CustomColors.commonGrey1 {
            if textView.text == placeholder{
                textView.text = nil
            }
            textView.textColor = CustomColors.commonBlue1
        }
    }
    internal func textViewShouldEndEditing(_ textField: UITextField) -> Bool {
        var itIsOk: Bool
        let len = textField.text?.count
        let limit = 100
        if len! > limit {
            itIsOk = false
            let alert = UIAlertController(title: "Notice", message: "Text can not be longer then \(limit) letters\nNow is \(len)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            itIsOk = true
        }
        return itIsOk
    }
//    internal func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        var itIsOk: Bool
//        let len = textField.text?.count
//        let limit = 100
//        if len! > limit {
//            itIsOk = false
//            let alert = UIAlertController(title: "Notice", message: "Text can not be longer then \(limit) letters\nNow is \(len)", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true)
//        } else {
//            itIsOk = true
//        }
//        return itIsOk
//    }
    
    @objc func handleLoginRegister() {
        if travelChecked == false && meetChecked == false && dateChecked == false {
            lookingForTitle.textColor = CustomColors.lightOrange1
            let alert = UIAlertController(title: "Notice", message: "Please check and make sure all the fields are filled correctly", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            
        } else {
            lookingForTitle.textColor = CustomColors.commonGrey1
            if selcectedLoginMethod == "email" {
                global_acceptingGuests = acceptingGuests
                global_whatDYDTextField = whatDYDTextField.text
                global_aboutMeTextField = aboutMeTextField.text
                global_meetChecked = meetChecked
                global_dateChecked = dateChecked
                global_travelChecked = travelChecked
                loginController?.handleRegister()
                loginController?.loaderOverlayer.isHidden = false
                dismiss(animated: true, completion: nil)
            } else if selcectedLoginMethod == "facebook" {
                fb_acceptingGuests = acceptingGuests
                fb_whatDYDTextField = whatDYDTextField.text
                fb_aboutMeTextField = aboutMeTextField.text
                fb_meetChecked = meetChecked
                fb_dateChecked = dateChecked
                fb_travelChecked = travelChecked
                fbLoginController?.handleRegister()
                fbLoginController?.loaderOverlayer.isHidden = false
                dismiss(animated: true, completion: nil)
            }
        }
    }
    func dismissingWelcomeController(){
        dismiss(animated: true, completion: nil)
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
        print("travelChecked: ", travelChecked)
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
        print("meetChecked: ", meetChecked)
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
        print("dateChecked: ", dateChecked)
    }
    
    var acceptingGuests = "maybe"
    @objc func agYesCheck(){
        agYesCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        agNoCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        agMaybeCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        acceptingGuests = "yes"
        print("acceptingGuests: ", acceptingGuests)
    }
    @objc func agNoCheck(){
        agYesCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        agNoCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        agMaybeCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        acceptingGuests = "no"
        print("acceptingGuests: ", acceptingGuests)
    }
    @objc func agMaybeCheck(){
        agYesCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        agNoCheckboxButton.setFATitleColor(color: CustomColors.commonBlue1, forState: .normal)
        agMaybeCheckboxButton.setFATitleColor(color: CustomColors.lightOrange1, forState: .normal)
        acceptingGuests = "maybe"
        print("acceptingGuests: ", acceptingGuests)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        view.backgroundColor = UIColor.white
        setupNavBarItems()
        view.addSubview(scrollView)
        scrollView.addSubview(welcomeTextsContainerView)
        textsContainerSetup()
        scrollView.addSubview(lookingForContainerView)
        lookingForSetupContainerView()
        scrollView.addSubview(acceptingGuestsContainerView)
        acceptingGuestsSetuoContainerView()
    }
    var whatDYDTextFieldHeightAnchor: NSLayoutConstraint?
    var aboutMeTextFieldHeightAnchor: NSLayoutConstraint?
    var whatDYDSeperatorViewHeightAnchor: NSLayoutConstraint?
    var aboutMeSeperatorViewHeightAnchor: NSLayoutConstraint?
    func textsContainerSetup(){
        welcomeTextsContainerView.addSubview(welcomeTitle)
        welcomeTextsContainerView.addSubview(mfrImageView)
//        welcomeTextsContainerView.addSubview(mfrMyTitle)//aboutMeTextTitle aboutMeTextField aboutMeSeperatorView
        welcomeTextsContainerView.addSubview(welcomeText)
        welcomeTextsContainerView.addSubview(whatDYDTextTitle)
        welcomeTextsContainerView.addSubview(whatDYDTextField)
        welcomeTextsContainerView.addSubview(whatDYDSeperatorView)
        welcomeTextsContainerView.addSubview(aboutMeTextTitle)
        welcomeTextsContainerView.addSubview(aboutMeTextField)
        welcomeTextsContainerView.addSubview(aboutMeSeperatorView)
        
        whatDYDTextField.delegate = self
        aboutMeTextField.delegate = self
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        welcomeTextsContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        welcomeTextsContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        welcomeTextsContainerView.widthAnchor.constraint(equalToConstant: 280).isActive = true
//        welcomeTextsContainerView.heightAnchor.constraint(equalToConstant: 410).isActive = true
//        welcomeTextsContainerView.bottomAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        welcomeTitle.leftAnchor.constraint(equalTo: welcomeTextsContainerView.leftAnchor).isActive = true
        welcomeTitle.topAnchor.constraint(equalTo: welcomeTextsContainerView.topAnchor).isActive = true
        welcomeTitle.widthAnchor.constraint(equalTo: welcomeTextsContainerView.widthAnchor).isActive = true
        welcomeTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        mfrImageView.leftAnchor.constraint(equalTo: welcomeTextsContainerView.leftAnchor).isActive = true
        mfrImageView.topAnchor.constraint(equalTo: welcomeTitle.bottomAnchor, constant: 20).isActive = true
        mfrImageView.widthAnchor.constraint(equalToConstant: 275).isActive = true
        mfrImageView.heightAnchor.constraint(equalToConstant: 78).isActive = true
        
        
//        mfrMyTitle.leftAnchor.constraint(equalTo: mfrImageView.rightAnchor).isActive = true
//        mfrMyTitle.centerYAnchor.constraint(equalTo: mfrImageView.centerYAnchor).isActive = true
//        mfrMyTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        mfrMyTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        welcomeText.leftAnchor.constraint(equalTo: welcomeTextsContainerView.leftAnchor).isActive = true
        welcomeText.topAnchor.constraint(equalTo: mfrImageView.bottomAnchor).isActive = true
        welcomeText.widthAnchor.constraint(equalTo: welcomeTextsContainerView.widthAnchor).isActive = true
        welcomeText.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        whatDYDTextTitle.leftAnchor.constraint(equalTo:  welcomeTextsContainerView.leftAnchor, constant: 7).isActive = true
        whatDYDTextTitle.topAnchor.constraint(equalTo: welcomeText.bottomAnchor, constant: 15).isActive = true
        whatDYDTextTitle.widthAnchor.constraint(equalTo: welcomeTextsContainerView.widthAnchor).isActive = true
        whatDYDTextTitle.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        whatDYDTextField.leftAnchor.constraint(equalTo:  welcomeTextsContainerView.leftAnchor, constant: 8).isActive = true
        whatDYDTextField.topAnchor.constraint(equalTo: whatDYDTextTitle.bottomAnchor, constant: 10).isActive = true
        whatDYDTextField.widthAnchor.constraint(equalTo: welcomeTextsContainerView.widthAnchor).isActive = true
        whatDYDTextFieldHeightAnchor = whatDYDTextField.heightAnchor.constraint(equalToConstant: 30)
        whatDYDTextFieldHeightAnchor?.isActive = true
        
        whatDYDSeperatorView.leftAnchor.constraint(equalTo:  welcomeTextsContainerView.leftAnchor, constant: 8).isActive = true
        whatDYDSeperatorView.topAnchor.constraint(equalTo: whatDYDTextField.topAnchor, constant: 1).isActive = true
        whatDYDSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        whatDYDSeperatorViewHeightAnchor = whatDYDSeperatorView.heightAnchor.constraint(equalToConstant: 25)
        whatDYDSeperatorViewHeightAnchor?.isActive = true
        
        aboutMeTextTitle.leftAnchor.constraint(equalTo:  welcomeTextsContainerView.leftAnchor, constant: 7).isActive = true
        aboutMeTextTitle.topAnchor.constraint(equalTo: whatDYDTextField.bottomAnchor, constant: 15).isActive = true
        aboutMeTextTitle.widthAnchor.constraint(equalTo: welcomeTextsContainerView.widthAnchor).isActive = true
        aboutMeTextTitle.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        aboutMeTextField.leftAnchor.constraint(equalTo:  welcomeTextsContainerView.leftAnchor, constant: 8).isActive = true
        aboutMeTextField.topAnchor.constraint(equalTo: aboutMeTextTitle.bottomAnchor, constant: 10).isActive = true
        aboutMeTextField.widthAnchor.constraint(equalTo: welcomeTextsContainerView.widthAnchor).isActive = true
        aboutMeTextFieldHeightAnchor = aboutMeTextField.heightAnchor.constraint(equalToConstant: 30)
        aboutMeTextFieldHeightAnchor?.isActive = true
        aboutMeTextField.bottomAnchor.constraint(equalTo: welcomeTextsContainerView.bottomAnchor, constant: 1).isActive = true
        
        aboutMeSeperatorView.leftAnchor.constraint(equalTo:  welcomeTextsContainerView.leftAnchor, constant: 8).isActive = true
        aboutMeSeperatorView.topAnchor.constraint(equalTo: aboutMeTextField.topAnchor, constant: 1).isActive = true
        aboutMeSeperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        aboutMeSeperatorViewHeightAnchor = aboutMeSeperatorView.heightAnchor.constraint(equalToConstant: 25)
        aboutMeSeperatorViewHeightAnchor?.isActive = true
        
    }
    
    func lookingForSetupContainerView(){
        
        lookingForContainerView.addSubview(lookingForTitle)
        lookingForContainerView.addSubview(travelCheckboxButton)
        lookingForContainerView.addSubview(meetCheckboxButton)
        lookingForContainerView.addSubview(dateCheckboxButton)


        lookingForContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        lookingForContainerView.topAnchor.constraint(equalTo: welcomeTextsContainerView.bottomAnchor, constant: 30).isActive = true
        lookingForContainerView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        lookingForContainerView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        lookingForTitle.leftAnchor.constraint(equalTo:  lookingForContainerView.leftAnchor, constant: 5).isActive = true
        lookingForTitle.topAnchor.constraint(equalTo: lookingForContainerView.topAnchor).isActive = true
        lookingForTitle.widthAnchor.constraint(equalTo: lookingForContainerView.widthAnchor, constant: -5).isActive = true
        lookingForTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        travelCheckboxButton.leftAnchor.constraint(equalTo: lookingForContainerView.leftAnchor, constant: 5).isActive = true
        travelCheckboxButton.topAnchor.constraint(equalTo: lookingForTitle.bottomAnchor, constant: 15).isActive = true
        travelCheckboxButton.widthAnchor.constraint(equalTo: lookingForContainerView.widthAnchor, constant: -5).isActive = true
        travelCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        travelCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: travelCheckboxButton.leftAnchor).isActive = true
        
        meetCheckboxButton.leftAnchor.constraint(equalTo: lookingForContainerView.leftAnchor, constant: 5).isActive = true
        meetCheckboxButton.topAnchor.constraint(equalTo: travelCheckboxButton.bottomAnchor, constant: 15).isActive = true
        meetCheckboxButton.widthAnchor.constraint(equalTo: lookingForContainerView.widthAnchor, constant: -5).isActive = true
        meetCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        meetCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: meetCheckboxButton.leftAnchor).isActive = true
        
        dateCheckboxButton.leftAnchor.constraint(equalTo: lookingForContainerView.leftAnchor, constant: 5).isActive = true
        dateCheckboxButton.topAnchor.constraint(equalTo: meetCheckboxButton.bottomAnchor, constant: 15).isActive = true
        dateCheckboxButton.widthAnchor.constraint(equalTo: lookingForContainerView.widthAnchor, constant: -5).isActive = true
        dateCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: dateCheckboxButton.leftAnchor).isActive = true
    }
    
    func acceptingGuestsSetuoContainerView(){
        
        acceptingGuestsContainerView.addSubview(agTitle)
        acceptingGuestsContainerView.addSubview(agYesCheckboxButton)
        acceptingGuestsContainerView.addSubview(agNoCheckboxButton)
        acceptingGuestsContainerView.addSubview(agMaybeCheckboxButton)
        acceptingGuestsContainerView.addSubview(registerButton)
        
        acceptingGuestsContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        acceptingGuestsContainerView.topAnchor.constraint(equalTo: lookingForContainerView.bottomAnchor, constant: 30).isActive = true
        acceptingGuestsContainerView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        acceptingGuestsContainerView.heightAnchor.constraint(equalToConstant: 190).isActive = true
        acceptingGuestsContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        agTitle.leftAnchor.constraint(equalTo:  acceptingGuestsContainerView.leftAnchor).isActive = true
        agTitle.topAnchor.constraint(equalTo: acceptingGuestsContainerView.topAnchor).isActive = true
        agTitle.widthAnchor.constraint(equalTo: acceptingGuestsContainerView.widthAnchor).isActive = true
        agTitle.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        agYesCheckboxButton.leftAnchor.constraint(equalTo: acceptingGuestsContainerView.leftAnchor, constant: 5).isActive = true
        agYesCheckboxButton.topAnchor.constraint(equalTo: agTitle.bottomAnchor, constant: 15).isActive = true
        agYesCheckboxButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        agYesCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        agYesCheckboxButton.titleLabel?.leftAnchor.constraint(equalTo: agYesCheckboxButton.leftAnchor).isActive = true
        
        
        agNoCheckboxButton.leftAnchor.constraint(equalTo: agYesCheckboxButton.rightAnchor).isActive = true
        agNoCheckboxButton.topAnchor.constraint(equalTo: agTitle.bottomAnchor, constant: 15).isActive = true
        agNoCheckboxButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        agNoCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        agMaybeCheckboxButton.rightAnchor.constraint(equalTo: acceptingGuestsContainerView.rightAnchor).isActive = true
        agMaybeCheckboxButton.topAnchor.constraint(equalTo: agTitle.bottomAnchor, constant: 15).isActive = true
        agMaybeCheckboxButton.widthAnchor.constraint(equalToConstant: 135).isActive = true
        agMaybeCheckboxButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        registerButton.leftAnchor.constraint(equalTo: acceptingGuestsContainerView.leftAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: agMaybeCheckboxButton.bottomAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalTo: acceptingGuestsContainerView.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    func setupNavBarItems(){
        let backImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
    }
}
