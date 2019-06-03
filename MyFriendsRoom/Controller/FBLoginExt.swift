//
//  FBLoginExt.swift
//  MyFriendsRoom
//
//  Created by Сын Бездны on 14.10.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

extension FBLoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleRegister() {
        print("in register func")
        guard let email = emailTextField.text, let name = nameTextField.text, let age = ageTextField.text, let loc = locTextField.text, let occupation = fb_whatDYDTextField, let aboutMe = fb_aboutMeTextField, let acceptingGuests = fb_acceptingGuests, let meetChecked = fb_meetChecked, let dateChecked = fb_dateChecked, let travelChecked = fb_travelChecked, let yourSex = yourSex, let fbUserId = fb_userId else { return }
        fb_acceptingGuests = nil
        fb_whatDYDTextField = nil
        fb_aboutMeTextField = nil
        fb_meetChecked = nil
        fb_dateChecked = nil
        fb_travelChecked = nil
        fb_userId = nil
        
        let referalMethod = selectedReferalMethod
        let referalCode = refCodeTextField.text
        let referalName = refNameTextField.text
        let referalCompany = refCompanyTextField.text
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                print(error as Any)
                return
            }
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newSignin"), object: nil)
            guard let uid = user?.uid else { return }
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            let imgData: NSData = NSData(data: UIImageJPEGRepresentation(self.profileImageView.image!, 1)!)
            let imageSize: Int = Int(Double(imgData.length) / 1024.0)
            var multiplier = Double()
            if imageSize > 400 {
                multiplier = 0.1
            } else if 399 > imageSize && imageSize > 200 {
                multiplier = 0.2
            } else if 199 > imageSize && imageSize > 100 {
                multiplier = 0.5
            } else {
                multiplier = 1
            }
            if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, CGFloat(multiplier)){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        return
                        
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        
                        if error != nil {
                            let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                            print(error!.localizedDescription)
                            return
                        }
                        if let profileImageUrl = url?.absoluteString {//InstanceID.instanceID().token()
                            let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl, "age": age, "loc": loc, "occupation": occupation, "acceptingGuests": acceptingGuests, "aboutMe": aboutMe, "meetChecked": meetChecked, "dateChecked": dateChecked, "travelChecked": travelChecked, "yourSex": yourSex, "fromDevice":InstanceID.instanceID().token(), "referalMethod": referalMethod, "referalCode": (referalCode == "" ? nil : referalCode), "referalName": (referalName == "" ? nil : referalName?.uppercased()), "referalCompany": (referalCompany == "" ? nil : referalCompany?.uppercased()), "platform": "iOS"] as [String : Any]
//                            let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl, "age": age, "loc": loc, "occupation": occupation, "acceptingGuests": acceptingGuests, "meetChecked": meetChecked, "dateChecked": dateChecked, "travelChecked": travelChecked, "yourSex": yourSex, "fromDevice":AppDelegate.DEVICEID] as [String : Any]
                            self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                        }
                    })
                    WelcomeController().dismissingWelcomeController()
                })
            }
        }
    }
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        let ref = Database.database().reference(fromURL: "https://myfriendsroomtest.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                let alert = UIAlertController(title: "Error", message: err?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                print(err as Any)
                return
            }
            itWasRegistration = true
            weak var pvc = self.presentingViewController
            self.dismiss(animated: false) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newSignin"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                let inviteFriendsController = InviteFriendsController()
                pvc?.present(inviteFriendsController, animated: false, completion: nil)
            }
            
        })
    }
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info ["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info ["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
