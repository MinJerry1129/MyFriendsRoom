//
//  ChatMessageCell.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 06.09.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    var chatLogController: ChatLogController?
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        //tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        tv.layer.cornerRadius = 13
        tv.isEditable = false
        return tv
    }()
    //static let blueColor = UIColor(r: 0, g: 137, b: 249), grayColor = UIColor(r: 240, g: 240, b: 240)
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 13
        return view
    }()
    let date: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = CustomColors.commonGrey1
        label.text = "date"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let time: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        label.text = "time"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let like: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "like")
        return imageView
    }()
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = CustomColors.lightBlue1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hanldeZoomTap)))
        imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(selectImageFromChat)))
        return imageView
    }()
    let viewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(ChatLogController.viewProfile), for: .touchUpInside)
        return button
    }()
    @objc func hanldeZoomTap(tapGesture: UITapGestureRecognizer){
        if let imageView = tapGesture.view as? UIImageView{
            self.chatLogController?.performZoomInForStartingImageView(startingImageView: imageView)
        }
    }
    @objc func selectImageFromChat(_ sender: UILongPressGestureRecognizer){
        self.chatLogController?.callReportMessageByTag(tag: messageImageView.tag)
    }
    var bubbleHeightAnchor: NSLayoutConstraint?
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var likeRightAnchor: NSLayoutConstraint?
    var likeLeftAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var dateWidthAnchor: NSLayoutConstraint?
    var dateHeightAnchor: NSLayoutConstraint?
    var width: CGFloat?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(date)
        addSubview(bubbleView)
        addSubview(textView)
        bubbleView.addSubview(time)
        addSubview(like)
        addSubview(profileImageView)
        addSubview(viewButton)
        bubbleView.addSubview(messageImageView)
        
        date.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        date.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dateWidthAnchor = date.widthAnchor.constraint(equalToConstant: 70)
        dateWidthAnchor?.isActive = true
        dateHeightAnchor = date.heightAnchor.constraint(equalToConstant: 30)
        dateHeightAnchor?.isActive = true
        
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        //bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.rightAnchor, constant: 8)
        //bubbleViewLeftAnchor?.isActive = false
        
        bubbleViewLeftAnchor?.isActive = true
        bubbleView.topAnchor.constraint(equalTo: date.bottomAnchor).isActive = true
//        func bublwidth(){
//            guard (self.bubbleText != nil) else {return}
//            let width = estimateFrameForText(text: self.bubbleText!).width + 32
//            bubbleWidthAnchor?.isActive = true
//        }
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 250)
        bubbleWidthAnchor?.isActive = true
//        bublwidth()
//        let width = estimateFrameForText(text: bubbleText!).width + 32
//        bubbleView.widthAnchor.constraint(equalToConstant: width).isActive = true
        bubbleHeightAnchor = bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -25)
        bubbleHeightAnchor?.isActive = true
        
        like.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        like.heightAnchor.constraint(equalToConstant: 20).isActive = true
        like.widthAnchor.constraint(equalToConstant: 20).isActive = true
        likeRightAnchor = like.rightAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: -10)
        likeRightAnchor?.isActive = true
        likeLeftAnchor = like.leftAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 10)
        likeLeftAnchor?.isActive = true
        like.isHidden = true
        
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
//        textView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        textView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor, constant: -20).isActive = true
        
        time.topAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        time.leftAnchor.constraint(equalTo: textView.leftAnchor, constant: 5).isActive = true
        time.widthAnchor.constraint(equalToConstant: 70).isActive = true
        time.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        viewButton.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        viewButton.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        viewButton.widthAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        viewButton.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        viewButton.titleLabel?.bottomAnchor.constraint(equalTo: viewButton.bottomAnchor).isActive = true
    }
    
//    private func estimateFrameForText(text: String) -> CGRect {
//        let size = CGSize(width: 200, height: 1000)
//        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
//        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
//    }
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        guard (self.bubbleText != nil) else {return}
//
//        let size = CGSize(width: 200, height: 1000)
//        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
//        let frme =  NSString(string: self.bubbleText!).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil) as CGRect
////        let frmewid = CGRect(frme.width)
//        let width = estimateFrameForText(text: self.bubbleText!).width + 55
////        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
////        bubbleViewRightAnchor?.isActive = true
////        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
////        bubbleViewLeftAnchor?.isActive = false
//        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: frme.width + 55)
//        bubbleWidthAnchor?.isActive = true
//
//        print("`FRAME`: ", bubbleView.frame, ", `experimental`: ", frme.width + 55, ", `frme`: ", width)
//        print("`TEXT`: ", self.bubbleText!, "\n====================")
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if width != nil {
            bubbleWidthAnchor?.isActive = false
            bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: width!)
            bubbleWidthAnchor?.isActive = true
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
