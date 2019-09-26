//
//  UsersTrayView.swift
//
//  Created by Mario Josifovski on 26/09/2017.
//  Copyright © 2017 Mario Josifovski. All rights reserved.
//

import UIKit

protocol UserTrayViewDelegate {
    func userTraySelectedProfileWithId(_ id: String)
    func userTrayCustomAction(_ id: Int)
}

class UsersTrayView: UICollectionView {

    var trayDelegate: UserTrayViewDelegate?
    
    // Users
    var datasource:[Any]? = [] {
        didSet {
            refreshDatasource()
        }
    }
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        
        setup()
    }
    
}


// MARK: - Setup
extension UsersTrayView {
    
    
    func setup() {
        
        register(UsersTrayCell.self, forCellWithReuseIdentifier: "UsersTrayCell")
        register(UINib.init(nibName: "UsersTrayCell", bundle: nil), forCellWithReuseIdentifier: "UsersTrayCell")
        
        (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: 70, height: 70)
        (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        
        contentInset.top = 10
        contentInset.bottom = 10
        contentInset.left = 10
        
        self.dataSource = self
        self.delegate = self
        
        
    }
    
    
    func refreshDatasource() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}




extension UsersTrayView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.row < 3 {
            trayDelegate?.userTrayCustomAction(indexPath.row)
            return
        }
        
        
        guard let datasource = datasource,
            let item = datasource[indexPath.row - 3] as? searchResult,
            let pid = item.userId else { return }
        
        trayDelegate?.userTraySelectedProfileWithId(pid)
    }
    
}


// MARK: - Datasource
extension UsersTrayView: UICollectionViewDataSource {
 
    
    // Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (datasource?.count)! + 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = dequeueReusableCell(withReuseIdentifier: "UsersTrayCell", for: indexPath) as! UsersTrayCell
    
        if (indexPath.row == 0) {
            cell.datasource = nil
            cell.prepareForReuse()
            cell.userNameLabel.textColor = UIColor(r: 106, g: 120, b: 131)
            cell.profilePictureImageView.backgroundColor = UIColor(r: 239, g: 239, b: 245)
            cell.userNameLabel.text = "stay"
        }
        else if (indexPath.row == 1) {
            cell.datasource = nil
            cell.prepareForReuse()
            cell.userNameLabel.textColor = UIColor.white
            cell.profilePictureImageView.backgroundColor = UIColor(r: 255, g: 165, b: 0)
            cell.userNameLabel.text = "discover"
        }
        else if (indexPath.row == 2) {
            cell.datasource = nil
            cell.prepareForReuse()
            cell.userNameLabel.textColor = UIColor.white
            cell.profilePictureImageView.backgroundColor = UIColor(r: 33, g: 187, b: 215)
            cell.userNameLabel.text = "events"
        }
        else {
            if let post = datasource?[indexPath.row - 3] {
                cell.datasource = post
            }
        }
        
        return cell
    }
    
    
}





