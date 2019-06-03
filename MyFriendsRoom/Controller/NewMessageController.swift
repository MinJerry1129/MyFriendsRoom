//
//  NewMessageController.swift
//  MyFriendsRoom
//
//  Created by Ал on 01.09.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.title = NSLocalizedString("Chats", comment: "")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()

    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
           
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = User()
                user.id = snapshot.key
                
                user.name = dictionary["name"] as! String
                user.email = dictionary["email"] as! String
                user.profileImageUrl = dictionary["profileImageUrl"] as! String
                //user.setValuesForKeys(dictionary)
                
                
                //user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        })
        
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
//        cell.imageView?.image = UIImage(named: "emptyavatar")
//        cell.imageView?.contentMode = .scaleAspectFill
        //print(user.profileImageUrl)
        if let profileImageUrl = user.profileImageUrl{
            
            cell.profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl)
            
//            let url = URL(string: profileImageUrl)!
//            print(url)
//            URLSession.shared.dataTask(with: url) { data, response, error
//            //URLSession.shared.dataTaskWithURL(url!, completionHandler: {(data, response, error)
//                in
//                    if error != nil{
//                        print(error)
//                        return
//                    }
//                DispatchQueue.main.async{
//                    cell.profileImageView.image = UIImage(data: data!)
//                }
//
//            }.resume()
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: MessagesController?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true){
            print("Dismiss compleeted")
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerForUser(user: user)
        }
    }
}

//class UserCell: UITableViewCell {
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
//        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
//    }
//
//    let profileImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "emptyavatar")
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 24
//        imageView.layer.masksToBounds = true
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
//
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//        addSubview(profileImageView)
//        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
//        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
