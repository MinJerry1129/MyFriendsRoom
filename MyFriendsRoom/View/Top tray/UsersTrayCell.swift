//
//  UsersTrayCell.swift
//
//  Created by Mario Josifovski on 26/09/2017.
//  Copyright © 2017 Mario Josifovski. All rights reserved.
//

import UIKit


class UsersTrayCell: UICollectionViewCell {

    
    public var datasource: Any? {
        didSet {
            populate()
        }
    }
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.bounds.width / 2
        profilePictureImageView.backgroundColor = .darkGray
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.contentMode = .scaleAspectFill
        
        
        
        
        reset()
        
    }
    
    
    
    // MARK: - Data implementation
    private func reset() {
        userNameLabel.text = nil
        profilePictureImageView.image = nil
        profilePictureImageView.backgroundColor = .darkGray
        alpha = 1.0
    }

    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    
    func populate() {
        
        
        if let item = datasource as? searchResult,
            let profileUrl = item.profileImageUrl {
            profilePictureImageView.loadImageusingCacheWithUrlString(urlString: profileUrl)
            
        }
        
        /*
        if let url = datasource?.profileImageUrl {
            
            if (url.scheme == nil) {
                RushKit.getImageUrl(url.absoluteString) { [weak self] (url, error) in
                    self?.profilePictureImageView.kf.setImage(with: url)
                }
            }
            else {
                profilePictureImageView.kf.setImage(with: url)
            }
        }
        
        if let name = datasource?.username {
            userNameLabel.text = name
        }
        */
        
        
        //profilePictureImageView.layer.borderWidth = RushUIConstants.ContentListProfileImageBorder
    
    }
    
    

}
