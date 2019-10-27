//
//  SignUpVC.swift
//  Listpie
//
//  Created by Ebru on 12/09/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpVC: UIViewController {
    
    //Outlet
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    // Action
    @IBAction func signUp(_ sender: Any) {
        let name = nameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        let username = (usernameTextField.text)?.lowercased()
        
        if name == "" || email == "" || password == "" || username == "" {
            createAlert(title: "Error", message: "All fields must be completed.")
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
                    // If not, then create the user
                    self.createTheUser()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    // System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameTextField.becomeFirstResponder()
    }
    
    // Custom Functions
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func createTheUser() {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            SVProgressHUD.dismiss()
            UIApplication.shared.endIgnoringInteractionEvents()
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    self.createAlert(title: "Error", message: errorCode.errorMessage)
                }
            } else {
                let user = [
                    "name":  self.nameTextField.text,
                    "email": self.emailTextField.text,
                    "username": (self.usernameTextField.text)?.lowercased()
                ]
                DataService.instance.REF_USERS.child((Auth.auth().currentUser?.uid)!).setValue(user)
            }
        }
    }
}
// Extensions
extension SignUpVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

