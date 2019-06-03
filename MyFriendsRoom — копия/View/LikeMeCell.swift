//
//  LikeMeCell.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 18.12.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase

class LikeMeCell: UITableViewCell {
    let likeMeController = LikeMeController()
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
        return imageView
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let viewButton: UIButton = {
        let button = UIButton()
        button.setTitle("view", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(CustomColors.commonBlue1, for: .normal)
        button.addTarget(self, action: #selector(LikeMeController.viewProfile), for: .touchUpInside)
        return button
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        addSubview(viewButton)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        viewButton.leftAnchor.constraint(equalTo: profileImageView.rightAnchor).isActive = true
        viewButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        viewButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        viewButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        viewButton.titleLabel?.bottomAnchor.constraint(equalTo: viewButton.bottomAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

