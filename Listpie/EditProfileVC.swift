//
//  EditProfileVC.swift
//  Listpie
//
//  Created by Ebru Kaya on 13.08.2018.
//  Copyright © 2018 Ebru Kaya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class EditProfileVC: UIViewController {
    
    var user = User()
    let currentUserID = (Auth.auth().currentUser?.uid)!
    var changedProfilePicture = UIImage()
    
    // Outlets
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var profilePicture: RoundImageView!
    
    // Actions
    @IBAction func pickPictureImageBtnWasPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.navigationBar.tintColor = .black
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickPictureTextBtnWasPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.navigationBar.tintColor = .black
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveBtnWasPressed(_ sender: Any) {
        let name = self.fullnameTextField.text
        let username = (self.usernameTextField.text)?.lowercased()
        let bioDescription = self.bioTextField.text
        
        if user.username == username {
            SVProgressHUD.show()
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.updateTheUser(name: name!, username: username!, bioDescription: bioDescription!, profilePicture: changedProfilePicture)
        } else if (username?.isEmpty)! {
            createAlert(title: "Error", message: "Please choose a username.")
        } else if !isValidUsername(username: username!) {
            createAlert(title: "Error", message: "Username should not contain any special character or space except '_'")
        } else {
            
            SVProgressHUD.show()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            // Check if username already exists
            DataService.instance.REF_USERS.queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists() {
                    SVProgressHUD.dismiss()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.createAlert(title: "Error", message: "This username is already taken.")
                } else {
                    // If not, then update the user
                    self.updateTheUser(name: name!, username: username!, bioDescription: bioDescription!, profilePicture: self.changedProfilePicture)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    // Custom Functions
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func updateTheUser(name: String, username: String, bioDescription: String, profilePicture: UIImage) {
        DataService.instance.updateUser(forUID: currentUserID, withFullName: name, withUsername: username, withBio: bioDescription, withProfilePicture: profilePicture) { (updated) in
            
            if updated {
                SVProgressHUD.dismiss()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    // System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var userProfilePicture: String
        
        if user.profilePictureDownloadURL.isEmpty {
            userProfilePicture = NO_PROFILE_PICTURE_URL
        } else {
            userProfilePicture = user.profilePictureDownloadURL
        }
        
        profilePicture.loadImageUsingCacheWithURLString(userProfilePicture)
        
        if !user.fullname.isEmpty {
            fullnameTextField.text = user.fullname
        }
        
        if !user.username.isEmpty {
            usernameTextField.text = user.username
        }
        
        if !user.bioDescription.isEmpty {
            bioTextField.text = user.bioDescription
        }
        
        self.navigationItem.title = "Edit Profile"
    }
}
// Extensions
extension EditProfileVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profilePicture.image = selectedImage
            changedProfilePicture = selectedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
