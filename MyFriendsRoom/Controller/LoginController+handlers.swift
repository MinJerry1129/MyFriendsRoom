//
//  LoginController+handlers.swift
//  MyFriendsRoom
//
//  Created by Ал on 02.09.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text, let age = ageTextField.text, let loc = locTextField.text, let occupation = global_whatDYDTextField, let aboutMe = global_aboutMeTextField, let acceptingGuests = global_acceptingGuests, let meetChecked = global_meetChecked, let dateChecked = global_dateChecked, let travelChecked = global_travelChecked, let yourSex = yourSex
            else {
                let alert = UIAlertController(title: "Error", message: "Form is not valid", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("Form is not valid")
                return
        }
        let referalMethod = selectedReferalMethod
        let referalCode = refCodeTextField.text
        let referalName = refNameTextField.text
        let referalCompany = refCompanyTextField.text
        
        global_acceptingGuests = nil
        global_whatDYDTextField = nil
        global_aboutMeTextField = nil
        global_meetChecked = nil
        global_dateChecked = nil
        global_travelChecked = nil
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error ) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                print(error)
                return
            }
            guard let uid = user?.user.uid else {
                return
            }
            if self.defaultAvatarWasChanged == true {
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
                            let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                            return
                        }
                        storageRef.downloadURL(completion: { (url, error) in
                            if error != nil {
                                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert, animated: true)
                                print(error!.localizedDescription)
                                return
                            }
                            if let profileImageUrl = url?.absoluteString {//InstanceID.instanceID().token()
                                let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl, "age": age, "loc": loc, "occupation": occupation, "acceptingGuests": acceptingGuests, "meetChecked": meetChecked, "dateChecked": dateChecked, "travelChecked": travelChecked, "yourSex": yourSex, "aboutMe": aboutMe, "fromDevice":InstanceID.instanceID().token(), "referalMethod": referalMethod, "referalCode": (referalCode == "" ? nil : referalCode), "referalName": (referalName == "" ? nil : referalName), "referalCompany": (referalCompany == "" ? nil : referalCompany)] as [String : Any]
//                                let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl, "age": age, "loc": loc, "occupation": occupation, "acceptingGuests": acceptingGuests, "meetChecked": meetChecked, "dateChecked": dateChecked, "travelChecked": travelChecked, "yourSex": yourSex, "fromDevice":AppDelegate.DEVICEID] as [String : Any]
                                self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                            }
                        })
                        WelcomeController().dismissingWelcomeController()
                    })
                }
            } else {
                let values = ["name": name, "email": email, "profileImageUrl": "empty", "age": age, "loc": loc, "occupation": occupation, "aboutMe": aboutMe, "acceptingGuests": acceptingGuests, "meetChecked": meetChecked, "dateChecked": dateChecked, "travelChecked": travelChecked, "yourSex": yourSex, "fromDevice":AppDelegate.DEVICEID, "referalMethod": referalMethod, "referalCode": (referalCode == "" ? nil : referalCode), "referalName": (referalName == "" ? nil : referalName), "referalCompany": (referalCompany == "" ? nil : referalCompany)] as [String : Any]
                self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                WelcomeController().dismissingWelcomeController()
            }
            
        })
    }
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        let ref = Database.database().reference(fromURL: "https://myfriendsroomtest.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                let alert = UIAlertController(title: "Error", message: err!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                print(err)
                return
            }
            itWasRegistration = true
            
            print("reg after \(itWasRegistration)")
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
            defaultAvatarWasChanged = true
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
