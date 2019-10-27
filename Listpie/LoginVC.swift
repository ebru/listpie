//
//  LoginVC.swift
//  Listpie
//
//  Created by Ebru on 12/09/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Actions
    @IBAction func login(_ sender: Any) {
        let input = (emailTextField.text)?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text
        
        if input == "" || password == "" {
            createAlert(title: "Error", message: "Username and password are required.")
        } else {
            SVProgressHUD.show()
            UIApplication.shared.beginIgnoringInteractionEvents()
            DataService.instance.getLoginCredential(forInput: input!) { (output) in
                
                if output != "noUser" {
                    self.logInTheUser(email: output)
                } else {
                    SVProgressHUD.dismiss()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.createAlert(title: "Error", message: "User is not found.")
                }
            }
        }
    }
    @IBAction func forgotPassword(_ sender: Any) {
        self.performSegue(withIdentifier: TO_FORGOT_PASSWORD, sender: self)
    }
    
    // System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_FORGOT_PASSWORD {
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            navigationItem.backBarButtonItem = barBtn
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailTextField.becomeFirstResponder()
    }
    
    // Custom Functions
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func logInTheUser(email: String) {
        Auth.auth().signIn(withEmail: email, password: passwordTextField.text!) {
            (user, error) in
            SVProgressHUD.dismiss()
            UIApplication.shared.endIgnoringInteractionEvents()
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    self.createAlert(title: "Error", message: errorCode.errorMessage)
                }
            }
        }
    }
}
// Extensions
extension LoginVC: UITextFieldDelegate {}

