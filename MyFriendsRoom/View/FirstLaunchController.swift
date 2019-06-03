//
//  FirstLaunchController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 17.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit

class FirstLaunchController: UIViewController {
    let image: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "firstLaunch")
        i.translatesAutoresizingMaskIntoConstraints = false
        i.layer.masksToBounds = true
        i.contentMode = .scaleAspectFit
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextStep(tapGestureRecognizer : )))
//        i.addGestureRecognizer(tapGestureRecognizer)
        i.isUserInteractionEnabled = true
        return i
    }()
    let firstLaunchTitle: UITextField = {
        let tt = UITextField()
        tt.textColor = UIColor.white
        tt.text = "Find a friend in every city..."
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = UIFont.boldSystemFont(ofSize: 20)
        return tt
    }()
    let firstLaunchText: UITextView = {
        let tt = UITextView()
        tt.backgroundColor = UIColor.clear
        tt.textColor = UIColor.white
        tt.text = "to stay with, meet up with or date.\nConnect with with friends\nand friends of friends when you travel."
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = UIFont.systemFont(ofSize: 20)
        return tt
    }()
    let button: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = UIColor.clear
        return b
    }()
    @objc func nextStep() {
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false) {
            let loginMethodController = LoginMethodController()
            pvc?.present(loginMethodController, animated: false, completion: nil)
        }
    }
    func setupFirstLaunchComponents() {
        view.addSubview(image)
        image.addSubview(firstLaunchTitle)
        image.addSubview(firstLaunchText)
        image.addSubview(button)
        
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        image.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        firstLaunchTitle.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        firstLaunchTitle.topAnchor.constraint(equalTo: image.topAnchor, constant: 60).isActive = true
        firstLaunchTitle.widthAnchor.constraint(equalToConstant: 300).isActive = true
        firstLaunchTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        firstLaunchText.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        firstLaunchText.topAnchor.constraint(equalTo: firstLaunchTitle.bottomAnchor).isActive = true
        firstLaunchText.widthAnchor.constraint(equalToConstant: 310).isActive = true
        firstLaunchText.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        button.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: image.topAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: image.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalTo: image.heightAnchor).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupFirstLaunchComponents()
    }
}

