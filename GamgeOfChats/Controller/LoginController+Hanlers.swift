//
//  LoginController+Hanlers.swift
//  GamgeOfChats
//
//  Created by Veaceslav Chirita on 10/10/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            print(editedImage.size)
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            print(originalImage.size)
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        self.messagesController?.fetchUserAndSetupNavBarTitle()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func handleRegister() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text
            else {
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }
            
            if error != nil {
                print(error)
                return
            }
            
            let user = result?.user
            guard let userUID = user?.uid else {
                return
            }
            
            let storageRef = Storage.storage().reference().child("myImage_\(name).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = self.profileImageView.image?.jpegData(compressionQuality: 0.1) {
                storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                    if error != nil {
                        return
                    }
                    print(metaData)
                    
                    storageRef.downloadURL { (url, error) in
                        if error == nil {
                            let values = [
                                "name": name,
                                "email": email,
                                "profileImageUrl": url?.absoluteString
                                ] as [String : Any]
                            self.registerUserIntoDatabaseWithUID(uid: userUID, values: values)
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        let ref = Database.database().reference(fromURL: "https://gameofchats-7f64f.firebaseio.com/")
        
        let userReference = ref.child("users").child(uid)
        
        
        userReference.updateChildValues(values) { [weak self] (err, ref) in
            guard let self = self else { return }
            
            if err != nil {
                print(err?.localizedDescription)
                return
            }
            
            
//            self.messagesController?.navigationItem.title = values["name"] as? String
            
            let user = User(name: values["name"] as! String,
                            email: values["email"] as! String,
                            profileImageUrl: values["profileImageUrl"] as? String)
            self.messagesController?.setupNavbarWithUser(user: user)
            self.dismiss(animated: true, completion: nil)
            
            print("Saved user successfully")
        }
    }
    
}
