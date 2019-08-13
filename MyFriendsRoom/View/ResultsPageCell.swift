//
//  ResultsPageCell.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 26.09.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit

protocol ResultsPageCellDelegate {
    func didSelectLikeAction(_ cell: ResultsPageCell, profile: searchResult )
    func didSelectViewAction(_ cell: ResultsPageCell, profile: searchResult )
}

class ResultsPageCell: UICollectionViewCell {

    var theItem: searchResult?{
        didSet {
            setData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewButton.layer.cornerRadius = viewButton.bounds.width / 2
        viewButton.titleLabel?.numberOfLines = 2
    }
    
    var delegate: ResultsPageCellDelegate?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var viewButton: UIButton!
    
    @IBAction func likeAction(_ sender: Any?) {
        
        // Action invoked on theItem
        guard let profile = theItem else { return }
        
        delegate?.didSelectLikeAction(self, profile: profile)
    }
    
    @IBAction func viewAction(_ sender: Any?) {
        
        // Action invoked on theItem
        
        guard let profile = theItem else { return }
        
        delegate?.didSelectViewAction(self, profile: profile)
    }
    
    
    
    // MARK: Data
    
    func setData(){
      
        let profileImageUrl = theItem?.profileImageUrl
        
        nameLabel.text = theItem?.name
        ageLabel.text = theItem?.age
        occupationLabel.text = theItem?.occupation
        
      
        if profileImageUrl == "empty" {
            profileImageView.image = UIImage(named: "emptyavatar")
        } else if profileImageUrl == "deleted" {
            profileImageView.image = UIImage(named: "deletedprofile")
        } else {
            profileImageView.image = UIImage(named: "emptyavatar")
            profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
        }
       
    }
    
    
}
    
    /*
    //    var curLoc: String? = "..."
//    var theItem = Int()
    let mfrContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    var number = Int()
    var theItem: searchResult?{
        didSet {
            setData()
        }
    }
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
    @IBOutlet let profileAvatarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let profileAvatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyavatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SwipingSRControllet.avGoToProfile(_:))))
//        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor.white
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.layer.masksToBounds = true
        return sv
    }()

    let swipingSRControllet = SwipingSRControllet()
    let addToWishlistButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(SwipingSRControllet.addToWishlist), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("WISH LIST", for: .normal)
        cb.backgroundColor = CustomColors.commonBlue1
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return cb
    }()
    let contactButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(SwipingSRControllet.contactMember), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("CONTACT", for: .normal)
        cb.backgroundColor = CustomColors.commonGrey1
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return cb
    }()
    let goToProfileButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(SwipingSRControllet.goToProfile), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("PROFILE", for: .normal)
        cb.backgroundColor = CustomColors.lightOrange1
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return cb
    }()
    let memberNameButton: UIButton = {
        let cb = UIButton()
        cb.addTarget(self, action: #selector(SwipingSRControllet.goToProfile), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle("%Username% 00", for: .normal)
        cb.backgroundColor = UIColor.white
        cb.setTitleColor(CustomColors.commonGrey1, for: .normal)
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        return cb
    }()
    let occupationText: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.commonBlue1
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 16)
        return tt
    }()
    let currentLocationView: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.commonGrey1
        tt.text = "Current:"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 16)
        return tt
    }()
    let homeLocationView: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.commonGrey1
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 16)
        return tt
    }()
    let accepingGuestsTextView: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.lightOrange1
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 16)
        return tt
    }()
    let meetingUpTextView: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.lightOrange1
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 16)
        return tt
    }()
    let datingTextView: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.lightOrange1
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 16)
        return tt
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        mfrContainerViewSetup()
        profileAvatarContainerViewSetup()
        memberPropsContainerSetup()
    }
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setData()
//    }
    func mfrContainerViewSetup(){
        addSubview(mfrContainerView)
        mfrContainerView.addSubview(mfrImageView)
//        mfrContainerView.addSubview(mfrMyTitle)
        
        mfrContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        mfrContainerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mfrContainerView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        mfrContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mfrImageView.centerXAnchor.constraint(equalTo: mfrContainerView.centerXAnchor).isActive = true
        mfrImageView.topAnchor.constraint(equalTo: mfrContainerView.topAnchor).isActive = true
        mfrImageView.widthAnchor.constraint(equalToConstant: 175).isActive = true
        mfrImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
//
//        mfrMyTitle.leftAnchor.constraint(equalTo: mfrImageView.rightAnchor).isActive = true
//        mfrMyTitle.centerYAnchor.constraint(equalTo: mfrImageView.centerYAnchor).isActive = true
//        mfrMyTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        mfrMyTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    func profileAvatarContainerViewSetup(){
        addSubview(profileAvatarContainerView)
        profileAvatarContainerView.addSubview(profileAvatarView)
        profileAvatarContainerView.addSubview(addToWishlistButton)
        profileAvatarContainerView.addSubview(contactButton)
        profileAvatarContainerView.addSubview(goToProfileButton)
        
        profileAvatarContainerView.topAnchor.constraint(equalTo: mfrContainerView.bottomAnchor, constant: 10).isActive = true
        profileAvatarContainerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileAvatarContainerView.widthAnchor.constraint(equalTo: widthAnchor, constant: -40).isActive = true
        profileAvatarContainerView.heightAnchor.constraint(equalTo: profileAvatarContainerView.widthAnchor).isActive = true
        
        profileAvatarView.centerXAnchor.constraint(equalTo: profileAvatarContainerView.centerXAnchor).isActive = true
        profileAvatarView.centerYAnchor.constraint(equalTo: profileAvatarContainerView.centerYAnchor).isActive = true
        profileAvatarView.widthAnchor.constraint(equalTo: profileAvatarContainerView.widthAnchor).isActive = true
        profileAvatarView.heightAnchor.constraint(equalTo: profileAvatarContainerView.heightAnchor).isActive = true
        
        addToWishlistButton.rightAnchor.constraint(equalTo: profileAvatarContainerView.rightAnchor).isActive = true
        addToWishlistButton.bottomAnchor.constraint(equalTo: profileAvatarContainerView.bottomAnchor, constant: -25).isActive = true
        addToWishlistButton.widthAnchor.constraint(equalToConstant: 85).isActive = true
        addToWishlistButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contactButton.rightAnchor.constraint(equalTo: profileAvatarContainerView.rightAnchor).isActive = true
        contactButton.bottomAnchor.constraint(equalTo: addToWishlistButton.topAnchor, constant: -15).isActive = true
        contactButton.widthAnchor.constraint(equalToConstant: 85).isActive = true
        contactButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        goToProfileButton.rightAnchor.constraint(equalTo: profileAvatarContainerView.rightAnchor).isActive = true
        goToProfileButton.bottomAnchor.constraint(equalTo: contactButton.topAnchor, constant: -15).isActive = true
        goToProfileButton.widthAnchor.constraint(equalToConstant: 85).isActive = true
        goToProfileButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        NSLayoutConstraint.activate([
            
            // Avatar Container view
            profileAvatarContainerView.topAnchor.constraint(equalTo: topAnchor),
            profileAvatarContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileAvatarContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileAvatarContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Avatar image view
            profileAvatarContainerView.topAnchor.constraint(equalTo: profileAvatarView.topAnchor),
            profileAvatarContainerView.leadingAnchor.constraint(equalTo: profileAvatarView.leadingAnchor),
            profileAvatarContainerView.trailingAnchor.constraint(equalTo: profileAvatarView.trailingAnchor),
            profileAvatarContainerView.bottomAnchor.constraint(equalTo: profileAvatarView.bottomAnchor),
            
            
            ])
        
        
        
    }
    func setData(){
//        print("theItem: ", theItem)
//        let arrayIndexPathItem = theItem
//        let input_meetChecked = theItem?.meetChecked
//        let input_dateChecked = theItem?.dateChecked
        let input_occupation = theItem?.occupation
//        let input_acceptingGuests = theItem?.acceptingGuests
        let input_home = theItem?.loc
        let input_name = theItem?.name
        let profileImageUrl = theItem?.profileImageUrl
        let input_age = theItem?.age
        let input_nameAndAge = input_name! + " " + input_age!
        let nameLen = input_name?.count
        let ageLen = input_age?.count
        let nameAgeLen = input_nameAndAge.count
        let range = NSRange(location: 0, length: nameAgeLen)
        let attributedStr = NSMutableAttributedString.init(string: input_nameAndAge)
        attributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 22), range: range)
        attributedStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 22), range: NSRange(location: nameLen! + 1, length: ageLen!))
        attributedStr.addAttribute(.foregroundColor, value: CustomColors.commonGrey1, range: range)
        addToWishlistButton.isHidden = true
        if input_occupation?.count == 0 {
            occupationText.text = ""
            occupationTextHeightAnchor?.isActive = false
            occupationTextHeightAnchor = occupationText.heightAnchor.constraint(equalToConstant: 0)
            occupationTextHeightAnchor?.isActive = true
        } else {
            occupationText.text = input_occupation
            occupationTextHeightAnchor?.isActive = false
            occupationTextHeightAnchor = occupationText.heightAnchor.constraint(equalToConstant: 28)
            occupationTextHeightAnchor?.isActive = true
        }
//        if input_meetChecked == true {
//            meetingUpTextView.text = "Meeting up"
//            meetingUpTextViewHeightAnchor?.isActive = false
//            meetingUpTextViewHeightAnchor = meetingUpTextView.heightAnchor.constraint(equalToConstant: 32)
//            meetingUpTextViewHeightAnchor?.isActive = true
//        } else {
//            meetingUpTextView.text = ""
//            meetingUpTextViewHeightAnchor?.isActive = false
//            meetingUpTextViewHeightAnchor = meetingUpTextView.heightAnchor.constraint(equalToConstant: 0)
//            meetingUpTextViewHeightAnchor?.isActive = true
//        }
//        if input_dateChecked == true {
//            datingTextView.text = "Dating"
//            datingTextViewHeightAnchor?.isActive = false
//            datingTextViewHeightAnchor = datingTextView.heightAnchor.constraint(equalToConstant: 28)
//            datingTextViewHeightAnchor?.isActive = true
//        } else {
//            datingTextView.text = ""
//            datingTextViewHeightAnchor?.isActive = false
//            datingTextViewHeightAnchor = datingTextView.heightAnchor.constraint(equalToConstant: 0)
//            datingTextViewHeightAnchor?.isActive = true
//        }
//        if input_acceptingGuests == "maybe"{
//            accepingGuestsTextView.text = "Maybe accepting guests"
//            accepingGuestsTextViewHeightAnchor?.isActive = false
//            accepingGuestsTextViewHeightAnchor = accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 32)
//            accepingGuestsTextViewHeightAnchor?.isActive = true
//        } else if input_acceptingGuests == "yes"{
//            accepingGuestsTextView.text = "Accepting guests"
//            accepingGuestsTextViewHeightAnchor?.isActive = false
//            accepingGuestsTextViewHeightAnchor = accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 32)
//            accepingGuestsTextViewHeightAnchor?.isActive = true
//        } else {
//            accepingGuestsTextView.text = ""
//            accepingGuestsTextViewHeightAnchor?.isActive = false
//            accepingGuestsTextViewHeightAnchor = accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 0)
//            accepingGuestsTextViewHeightAnchor?.isActive = true
//        }
        if profileImageUrl == "empty" {
            profileAvatarView.image = UIImage(named: "emptyavatar")
        } else if profileImageUrl == "deleted" {
            profileAvatarView.image = UIImage(named: "deletedprofile")
        } else {
            profileAvatarView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
        }
//        if let input_CurrentLoc = theItem?.currentLoc {
//            if (input_CurrentLoc as! String).count > 0 {
//                currentLocationView.text = "Current location: " + (input_CurrentLoc as! String)
//                currentLocationViewHeightAnchor?.isActive = false
//                currentLocationViewHeightAnchor = currentLocationView.heightAnchor.constraint(equalToConstant: 32)
//                currentLocationViewHeightAnchor?.isActive = true
//            } else {
//                currentLocationView.text = ""
//                currentLocationViewHeightAnchor?.isActive = false
//                currentLocationViewHeightAnchor = currentLocationView.heightAnchor.constraint(equalToConstant: 0)
//                currentLocationViewHeightAnchor?.isActive = true
//            }
//        } else {
//            currentLocationView.text = ""
//            currentLocationViewHeightAnchor?.isActive = false
//            currentLocationViewHeightAnchor = currentLocationView.heightAnchor.constraint(equalToConstant: 0)
//            currentLocationViewHeightAnchor?.isActive = true
//        }
        memberNameButton.setAttributedTitle(attributedStr, for: .normal)
        memberNameButton.tag = number
        homeLocationView.text = /*"City, Country: " + */input_home!
        contactButton.tag = number
        goToProfileButton.tag = number
        addToWishlistButton.tag = number
        profileAvatarView.tag = number
        profileAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SwipingSRControllet.avGoToProfile)))
        
        
    }//occupationText meetingUpTextView datingTextView accepingGuestsTextView currentLocationView
    var occupationTextHeightAnchor: NSLayoutConstraint?
//    var meetingUpTextViewHeightAnchor: NSLayoutConstraint?
//    var datingTextViewHeightAnchor: NSLayoutConstraint?
//    var accepingGuestsTextViewHeightAnchor: NSLayoutConstraint?
//    var currentLocationViewHeightAnchor: NSLayoutConstraint?
    func memberPropsContainerSetup(){
        addSubview(scrollView)
        scrollView.addSubview(memberNameButton)
        scrollView.addSubview(occupationText)
//        scrollView.addSubview(currentLocationView)
        scrollView.addSubview(homeLocationView)
//        scrollView.addSubview(accepingGuestsTextView)
//        scrollView.addSubview(meetingUpTextView)
//        scrollView.addSubview(datingTextView)

        scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: profileAvatarContainerView.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -49).isActive = true
        
        memberNameButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        memberNameButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        memberNameButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        memberNameButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        memberNameButton.titleLabel?.leftAnchor.constraint(equalTo: memberNameButton.leftAnchor, constant: 5).isActive = true
        
        occupationText.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        occupationText.topAnchor.constraint(equalTo: memberNameButton.bottomAnchor).isActive = true
        occupationText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        occupationTextHeightAnchor = occupationText.heightAnchor.constraint(equalToConstant: 28)
        occupationTextHeightAnchor?.isActive = true

//        currentLocationView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        currentLocationView.topAnchor.constraint(equalTo: occupationText.bottomAnchor).isActive = true
//        currentLocationView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
//        currentLocationViewHeightAnchor = currentLocationView.heightAnchor.constraint(equalToConstant: 28)
//        currentLocationViewHeightAnchor?.isActive = true


        homeLocationView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        homeLocationView.topAnchor.constraint(equalTo: currentLocationView.bottomAnchor).isActive = true
        homeLocationView.topAnchor.constraint(equalTo: occupationText.bottomAnchor).isActive = true
        homeLocationView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
        homeLocationView.heightAnchor.constraint(equalToConstant: 28).isActive = true

//        accepingGuestsTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        accepingGuestsTextView.topAnchor.constraint(equalTo: homeLocationView.bottomAnchor).isActive = true
//        accepingGuestsTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
//        accepingGuestsTextViewHeightAnchor = accepingGuestsTextView.heightAnchor.constraint(equalToConstant: 28)
//        accepingGuestsTextViewHeightAnchor?.isActive = true
//
//        meetingUpTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        meetingUpTextView.topAnchor.constraint(equalTo: accepingGuestsTextView.bottomAnchor).isActive = true
//        meetingUpTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
//        meetingUpTextViewHeightAnchor = meetingUpTextView.heightAnchor.constraint(equalToConstant: 32)
//        meetingUpTextViewHeightAnchor?.isActive = true
//
//        datingTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        datingTextView.topAnchor.constraint(equalTo: meetingUpTextView.bottomAnchor).isActive = true
//        datingTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -70).isActive = true
//        datingTextViewHeightAnchor = datingTextView.heightAnchor.constraint(equalToConstant: 28)
//        datingTextViewHeightAnchor?.isActive = true
//        datingTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
*/
