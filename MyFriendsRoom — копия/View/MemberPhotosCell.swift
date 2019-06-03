//
//  MemberPhotosCell.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 10.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit

class MemberPhotosCell: UICollectionViewCell, UIScrollViewDelegate {
    
    let memberImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    var scrollView:UIScrollView = {
        let scroll = UIScrollView()
        scroll.maximumZoomScale = 4.0
        scroll.minimumZoomScale = 1
        scroll.clipsToBounds = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.isUserInteractionEnabled = true
        return scroll
    }()
    func imageSetup(){
        
        addSubview(scrollView)
        scrollView.addSubview(memberImageView)

        scrollView.delegate = self

        scrollView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        memberImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        memberImageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        memberImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        memberImageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return memberImageView
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        imageSetup()
    }
    override func prepareForReuse() {
        scrollView.zoomScale = 1
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
