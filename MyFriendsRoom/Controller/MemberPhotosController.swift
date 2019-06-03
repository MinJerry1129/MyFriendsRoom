//
//  MemberPhotosController.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 10.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase

class MemberPhotosController: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    var youAreBanned = false
    var selectedItem = Int() //{
//        didSet {
//            let indexPath = IndexPath(item: 1, section: 0)
//            self.collectionView?.scrollToItem(at: indexPath, at: .left, animated: true)
//        }
//    }
    var picsArray = [String]() {
        didSet {
            self.collectionView?.reloadData()
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(scroll), userInfo: nil, repeats: false)
        }
    }
    @objc func scroll(){
        if self.collectionView?.dataSource?.collectionView(self.collectionView!, cellForItemAt: IndexPath(row: selectedItem, section: 0)) != nil {
            let rect = self.collectionView?.layoutAttributesForItem(at: IndexPath(item: selectedItem, section: 0))?.frame
            self.collectionView?.scrollRectToVisible(rect!, animated: false)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(MemberPhotosCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.isPagingEnabled = true
        setupNavBarItems()
        checkIfYouAreBanned()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var galeryCount = Int()
        galeryCount = picsArray.count
        return galeryCount
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MemberPhotosCell
        var memeberImageUrl: String?
        memeberImageUrl = picsArray[indexPath.item]
        cell.memberImageView.loadImageusingCacheWithUrlString(urlString: memeberImageUrl!)
        let singletap = UITapGestureRecognizer(target: self, action: #selector(hideNavBar))
        cell.scrollView.addGestureRecognizer(singletap)
        return cell
    }
    
    var isHidden = false
    @objc func hideNavBar(){
        isHidden == false ? (isHidden = true) : (isHidden = false)
        self.navigationController?.setNavigationBarHidden(isHidden, animated: true)
    }
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    func setupNavBarItems(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : CustomColors.commonGrey1]
        let backImage = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "Photos"
        self.edgesForExtendedLayout = UIRectEdge.bottom
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
