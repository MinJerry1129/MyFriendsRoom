//
//  UserPhotosExt.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 04.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase

//extension UserPhotosController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    @objc func handleSelectProfileImageView() {
//        avatarOrImage = "avatar"
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.allowsEditing = true
//        present(picker, animated: true, completion: nil)
//    }
//    @objc func handleSelectNewImage() {
//        avatarOrImage = "image"
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.allowsEditing = true
//        present(picker, animated: true, completion: nil)
//    }
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
//    @objc func uploadNewImage(){
//        let uid = Auth.auth().currentUser!.uid
//        let imageName = NSUUID().uuidString
//        let storageRef = Storage.storage().reference().child("users_images").child("\(imageName).jpg")
//        if let uploadData = UIImageJPEGRepresentation(newImage!, 0.1){
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
//                        let timestamp = String(Int(NSDate().timeIntervalSince1970))
//                        let values = [timestamp: profileImageUrl] as [String : Any]
//                        let ref = Database.database().reference(fromURL: "https://myfriendsroomtest.firebaseio.com/")
//                        let usersReference = ref.child("user-images").child(uid)
//                        print("usersReference: ", usersReference, "\nvalues: ", values)
//                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
//                            if err != nil {
//                                print(err!)
//                                return
//                            }
//                        })
//                    }
//                })
//                print("image uploadet")
//                self.reloadGalery()
//            })
//        }
//    }
//    func setupCurrentAvatar(){
//        let uid = Auth.auth().currentUser!.uid
//        let ref = Database.database().reference().child("users").child(uid)
//        ref.observe(.value, with: { (snapshot) in
//            guard let value = snapshot.value as? [String: Any] else { return }
//            let profileImageUrl = value["profileImageUrl"] as? String
//            self.profileImageView.loadImageusingCacheWithUrlString(urlString: profileImageUrl!)
//        })
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        var selectedImageFromPicker: UIImage?
//        if let editedImage = info ["UIImagePickerControllerEditedImage"] as? UIImage {
//            selectedImageFromPicker = editedImage
//        } else if let originalImage = info ["UIImagePickerControllerOriginalImage"] as? UIImage {
//            selectedImageFromPicker = originalImage
//        }
//        if let selectedImage = selectedImageFromPicker {
//            if avatarOrImage == "avatar"{
//                profileImageView.image = selectedImage
//            } else if avatarOrImage == "image" {
//                newImage = selectedImage
//                uploadNewImage()
//                print("tipa zagruzka v bazu")
//            }
//        }
//        dismiss(animated: true, completion: nil)
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//}
