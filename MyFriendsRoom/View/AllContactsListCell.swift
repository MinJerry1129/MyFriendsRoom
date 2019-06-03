//
//  AllContactsListCell.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 08.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit



class AllContactsListCell: UITableViewCell {
    let allContactsController = AllContactsController()
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyavatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        //let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AllContactsController.viewProfile))
        //imageView.addGestureRecognizer(tapRecognizer)
        return imageView
    }()
//    let addButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("+ add friend", for: .normal)//
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitleColor(CustomColors.commonBlue1, for: .normal)
//        button.addTarget(self, action: #selector(ProposalsReceivedController.addFriend), for: .touchUpInside)
//        return button
//    }()
    let viewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(AllContactsController.viewProfile), for: .touchUpInside)
        return button
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(viewButton)
//        addSubview(addButton)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        viewButton.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        viewButton.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        viewButton.widthAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        viewButton.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        viewButton.titleLabel?.bottomAnchor.constraint(equalTo: viewButton.bottomAnchor).isActive = true
        
//        addButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
//        addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
//        //addButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
//        addButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
