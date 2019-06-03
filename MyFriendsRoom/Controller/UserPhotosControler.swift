//
//  UserPhotosControler.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 04.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
class UserPhotosController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    var youAreBanned = false

    let photosContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let photosTitle: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.lightOrange1
        tt.text = "Photos"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 25)
        return tt
    }()
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("<", for: .normal)
        button.setFATitleColor(color: CustomColors.commonGrey1)
        button.titleLabel?.font = .systemFont(ofSize: 45)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
//    lazy var profileImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "emptyavatar")
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.masksToBounds = true
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
//        imageView.isUserInteractionEnabled = true
//        return imageView
//    }()
//    let uploadNewAvatarButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("UPLOAD", for: .normal)
//        button.setFATitleColor(color: CustomColors.commonGrey1)
//        button.titleLabel?.font = .systemFont(ofSize: 20)
//        button.addTarget(self, action: #selector(uploadNewAvatar), for: .touchUpInside)
//        return button
//    }()
    let galeryContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    let uploadNewPhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+ add new photo", for: .normal)
        button.setFATitleColor(color: CustomColors.commonBlue1)
        button.titleLabel?.font = .systemFont(ofSize: 19)
        button.addTarget(self, action: #selector(handleSelectNewImage), for: .touchUpInside)
        return button
    }()
    let popupOverLayer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return view
    }()
    let popup: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = CustomColors.commonBlue1.cgColor
        return view
    }()
    let popupTitle: UITextView = {
        let tt = UITextView()
        tt.textColor = CustomColors.lightOrange1
        tt.text = "Delete this photo?"
        tt.translatesAutoresizingMaskIntoConstraints = false
        tt.isUserInteractionEnabled = false
        tt.font = .systemFont(ofSize: 15)
        return tt
    }()
    let yesPopupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("YES", for: .normal)
        button.setFATitleColor(color: UIColor.red)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(yesDeleteThisPhoto), for: .touchUpInside)
        return button
    }()
    let noPopupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("NO", for: .normal)
        button.setFATitleColor(color: CustomColors.commonBlue1)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(notDeleteThisPhoto), for: .touchUpInside)
        return button
    }()
//    let addHomePicsHere: UITextField = {
//        let tt = UITextField()
//        tt.textColor = CustomColors.commonGrey1
//        tt.text = "Add additional profile pics"
//        tt.translatesAutoresizingMaskIntoConstraints = false
//        tt.isUserInteractionEnabled = false
//        tt.font = .systemFont(ofSize: 15)
//        return tt
//    }()
//    let goToHomepics: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("here", for: .normal)
//        button.setFATitleColor(color: CustomColors.commonBlue1)
//        button.titleLabel?.font = .systemFont(ofSize: 15)
//        button.addTarget(self, action: #selector(goToNeighborController), for: .touchUpInside)
//        return button
//    }()
//    let addHomePicsToContr: UITextField = {
//        let tt = UITextField()
//        tt.textColor = CustomColors.commonGrey1
//        tt.text = "Do not add pics of your home here, add them to Pics of my place"
//        tt.translatesAutoresizingMaskIntoConstraints = false
//        tt.isUserInteractionEnabled = false
//        tt.font = .systemFont(ofSize: 12)
//        return tt
//    }()
//    @objc func goToNeighborController(){
//        weak var pvc = self.presentingViewController
//        self.dismiss(animated: true) {
//            let userProfilePhotosController = UserProfilePhotosController()
//            let userProfilePhotosControllerNav = UINavigationController(rootViewController: userProfilePhotosController)
//            pvc?.present(userProfilePhotosControllerNav, animated: true, completion: nil)
//        }
//    }
    @objc func goBack() {
        userApartmentsImagesRef.removeAllObservers()
        self.dismiss(animated: true, completion: nil)
    }
    func setupNavBarItems(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.lightOrange1]
        let backImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "Pics of my place"
    }
    var photoActionById = String()
    @objc func yesDeleteThisPhoto(){
        checkIfYouAreBanned()
        popupOverLayer.isHidden = true
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("user-apartments-images").child(uid!).child(photoActionById)
        ref.removeValue()
        reloadGalery()
    }
    @objc func notDeleteThisPhoto(){
        checkIfYouAreBanned()
        popupOverLayer.isHidden = true
    }
    @objc func selectPhotoFromCollection(_ sender: UILongPressGestureRecognizer){
        if let image = sender.view as? UIImageView {
            checkIfYouAreBanned()
            popupOverLayer.isHidden = false
            let imageTag = image.tag
            photoActionById = photosIdsArray[imageTag]
        }
    }
    func checkIfYouAreBanned() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(uid!).child("wasDeleted")
        ref.observeSingleEvent(of: .value) { (snap) in
            if snap.value as? String == "byAdministration" {
                let alert = UIAlertController(title: "You got banned from MyFriendsRoom", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    weak var pvc = self.presentingViewController
                    self.dismiss(animated: false) {
                        pvc?.present(LoginMethodController(), animated: false, completion: {
                            do {
                                try Auth.auth().signOut()
                            }
                            catch let logoutError {
                                print (logoutError)
                            }
                        })
                    }
                }))
                self.present(alert, animated: true)
            }
        }
    }
    var avatarOrImage = ""
    var newImage: UIImage?
    func setupPhotosContainerView() {
        view.addSubview(photosContainerView)
        //        photosContainerView.addSubview(profileImageView)
        //        photosContainerView.addSubview(uploadNewAvatarButton) addHomePicsToContr
//        photosContainerView.addSubview(addHomePicsToContr)
        photosContainerView.addSubview(uploadNewPhotoButton)
        photosContainerView.addSubview(galeryContainerView)
//        photosContainerView.addSubview(addHomePicsHere)
//        photosContainerView.addSubview(goToHomepics)
        
        photosContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        photosContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        photosContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        photosContainerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        //        profileImageView.topAnchor.constraint(equalTo: photosContainerView.topAnchor, constant: 100).isActive = true
        //        profileImageView.leftAnchor.constraint(equalTo: photosContainerView.leftAnchor, constant: 20).isActive = true
        //        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        //        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        //
        //        uploadNewAvatarButton.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 20).isActive = true
        //        uploadNewAvatarButton.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        //        uploadNewAvatarButton.widthAnchor.constraint(equalToConstant: 78).isActive = true
        //        uploadNewAvatarButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
//        addHomePicsToContr.centerXAnchor.constraint(equalTo: photosContainerView.centerXAnchor, constant: 10).isActive = true
//        addHomePicsToContr.topAnchor.constraint(equalTo: photosContainerView.topAnchor).isActive = true
//        addHomePicsToContr.widthAnchor.constraint(equalTo: photosContainerView.widthAnchor).isActive = true
//        addHomePicsToContr.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        uploadNewPhotoButton.rightAnchor.constraint(equalTo: photosContainerView.rightAnchor).isActive = true
        uploadNewPhotoButton.topAnchor.constraint(equalTo: photosContainerView.topAnchor, constant: 25).isActive = true
        uploadNewPhotoButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        uploadNewPhotoButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
//        addHomePicsHere.leftAnchor.constraint(equalTo: photosContainerView.leftAnchor, constant: 10).isActive = true
//        addHomePicsHere.topAnchor.constraint(equalTo: uploadNewPhotoButton.bottomAnchor).isActive = true
//        addHomePicsHere.widthAnchor.constraint(equalToConstant: 180).isActive = true
//        addHomePicsHere.heightAnchor.constraint(equalToConstant: 24).isActive = true
//        
//        goToHomepics.leftAnchor.constraint(equalTo: addHomePicsHere.rightAnchor, constant: -11).isActive = true
//        goToHomepics.centerYAnchor.constraint(equalTo: addHomePicsHere.centerYAnchor).isActive = true
//        goToHomepics.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        goToHomepics.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        galeryContainerView.topAnchor.constraint(equalTo: photosContainerView.topAnchor, constant: 80).isActive = true
        galeryContainerView.leftAnchor.constraint(equalTo: photosContainerView.leftAnchor).isActive = true
        galeryContainerView.widthAnchor.constraint(equalTo: photosContainerView.widthAnchor).isActive = true
        galeryContainerView.bottomAnchor.constraint(equalTo: photosContainerView.bottomAnchor).isActive = true
    }
    let leftAndRightPaddings: CGFloat = 30.0
    let numberOfItemsPerRow: CGFloat = 4.0
    let screenSize: CGRect = UIScreen.main.bounds
    private let cellReuseIdentifier = "collectionCell"
    let flowLayout = UICollectionViewFlowLayout()
    var photosArray = [String]()
    var photosIdsArray = [String]()
    var deleteThisPhoto = String()
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        checkIfYouAreBanned()
        setupPhotosContainerView()
//        setupCurrentAvatar()
        setupImagesArray()
        setPopup()
        setupNavBarItems()
    }
    
    var userApartmentsImagesRef: DatabaseReference!
    func setupImagesArray() {
        let uid = Auth.auth().currentUser!.uid
        userApartmentsImagesRef = Database.database().reference().child("user-apartments-images").child(uid)
        userApartmentsImagesRef.observe(.value, with: { (snap) in
            print(snap)
            for child in snap.children {
                let childValue = (child as! DataSnapshot).value!
                self.photosArray.insert(childValue as! String, at: 0)
                let childKey = (child as! DataSnapshot).key
                self.photosIdsArray.insert(childKey, at: 0)
            }
            self.setupCollectionView()
        })
    }
    func reloadGalery(){
        self.photosArray = [String]()
        self.photosIdsArray = [String]()
    }
    func setupCollectionView() {
        let colViewFr = self.view.bounds
        let colViewFrameWidth = colViewFr.width
        let colViewFrameHeight = colViewFr.height - 190
        let colViewFrame = CGRect(x: 0.0, y: 0.0, width: colViewFrameWidth, height: colViewFrameHeight)
        let collectionView = UICollectionView(frame: colViewFrame, collectionViewLayout: flowLayout)
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        galeryContainerView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        cell.backgroundColor = UIColor.white
        let arrayIndexPathItem = photosArray[indexPath.item] as AnyObject
        cell.cellImageView.loadImageusingCacheWithUrlString(urlString: arrayIndexPathItem as! String)
        cell.cellImageView.tag = indexPath.item
        cell.cellImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(UserPhotosController.selectPhotoFromCollection)))
        cell.cellImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToMemberPhotosController)))
        return cell
    }
    @objc func goToMemberPhotosController(_ sender: UITapGestureRecognizer){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let memberPhotos = MemberPhotosController(collectionViewLayout: layout)
        memberPhotos.picsArray = photosArray
        memberPhotos.selectedItem = sender.view!.tag
        print(sender.view!.tag)
        let memberPhotosNav = UINavigationController(rootViewController: memberPhotos)
        self.present(memberPhotosNav, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenSize.width-leftAndRightPaddings)/numberOfItemsPerRow
        return CGSize(width: width, height: width)
    }
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 8, bottom: 5, right: 8)
    }
    func setPopup(){
        view.addSubview(popupOverLayer)
        popupOverLayer.addSubview(popup)
        popup.addSubview(popupTitle)
        popup.addSubview(yesPopupButton)
        popup.addSubview(noPopupButton)
        
        popupOverLayer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        popupOverLayer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        popupOverLayer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        popupOverLayer.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        popup.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popup.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popup.heightAnchor.constraint(equalToConstant: 130).isActive = true
        popup.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        popupTitle.centerXAnchor.constraint(equalTo:  popup.centerXAnchor).isActive = true
        popupTitle.topAnchor.constraint(equalTo: popup.topAnchor, constant: 20).isActive = true
        popupTitle.widthAnchor.constraint(equalToConstant: 140).isActive = true
        popupTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        yesPopupButton.rightAnchor.constraint(equalTo: popup.centerXAnchor, constant: -25).isActive = true
        yesPopupButton.topAnchor.constraint(equalTo: popupTitle.bottomAnchor, constant: 25).isActive = true
        yesPopupButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        yesPopupButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        noPopupButton.leftAnchor.constraint(equalTo: popup.centerXAnchor, constant: 25).isActive = true
        noPopupButton.topAnchor.constraint(equalTo: popupTitle.bottomAnchor, constant: 25).isActive = true
        noPopupButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        noPopupButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        popupOverLayer.isHidden = true
    }
}
class MyCollectionViewCell: UICollectionViewCell {
    
    let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyavatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cellImageView)
        
        cellImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cellImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cellImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cellImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserPhotosController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleSelectProfileImageView() {
        avatarOrImage = "avatar"
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    @objc func handleSelectNewImage() {
        checkIfYouAreBanned()
        avatarOrImage = "image"
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
//    @objc func uploadNewAvatar(){
//        let uid = Auth.auth().currentUser!.uid
//        let imageName = NSUUID().uuidString
//        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
//        if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1){
//            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//                if error != nil {
//                    return
//                }
//                storageRef.downloadURL(completion: { (url, error) in
//                    if error != nil {
//                        print(error!.localizedDescription)
//                        return
//                    }
//                    if let profileImageUrl = url?.absoluteString {
//                        let values = ["profileImageUrl": profileImageUrl] as [String : Any]
//                        let ref = Database.database().reference(fromURL: "https://myfriendsroomtest.firebaseio.com/")
//                        let usersReference = ref.child("users").child(uid)
//                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
//                            if err != nil {
//                                print(err!)
//                                return
//                            }
//                        })
//                    }
//                })
//            })
//        }
//    }
    @objc func uploadNewImage(){
        let uid = Auth.auth().currentUser!.uid
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("users_images").child("\(imageName).jpg")
        if let uploadData = UIImageJPEGRepresentation(newImage!, 0.1){
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    if let profileImageUrl = url?.absoluteString {
                        let timestamp = String(Int(NSDate().timeIntervalSince1970))
                        let values = [timestamp: profileImageUrl] as [String : Any]
                        let ref = Database.database().reference(fromURL: "https://myfriendsroomtest.firebaseio.com/")
                        let usersReference = ref.child("user-apartments-images").child(uid)
                        print("usersReference: ", usersReference, "\nvalues: ", values)
                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                print(err!)
                                return
                            }
                        })
                    }
                })
                print("image uploadet")
                self.reloadGalery()
            })
        }
    }
//    func setupCurrentAvatar(){
//        let uid = Auth.auth().currentUser!.uid
//        let ref = Database.database().reference().child("users").child(uid)
//        ref.observe(.value, with: { (snapshot) in
//            guard let value = snapshot.value as? [String: Any] else { return }
//            let profileImageUrl = value["profileImageUrl"] as? String
//            self.profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
//        })
//    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info ["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info ["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
//            if avatarOrImage == "avatar"{
//                profileImageView.image = selectedImage
//            } else if avatarOrImage == "image" {
                newImage = selectedImage
                uploadNewImage()
//            }
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}



