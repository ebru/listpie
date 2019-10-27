//
//  ForgotPasswordVC.swift
//  Listpie
//
//  Created by Ebru on 26/09/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ForgotPasswordVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    
    // Actions
    @IBAction func sendEmail(_ sender: Any) {
        if emailTextField.text == "" {
            createAlert(title: "Error", message: "E-mail is required.")
        } else {
            SVProgressHUD.show()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) {
                error in
                
                SVProgressHUD.dismiss()
                UIApplication.shared.endIgnoringInteractionEvents()
                if error != nil {
                    if let errorCode = AuthErrorCode(rawValue: error!._code) {
                        self.createAlert(title: "Error", message: errorCode.errorMessage)
                    }
                }
                else {
                    SVProgressHUD.showSuccess(withStatus: "E-mail is sent!")
                    self.navigationController?.popViewController(animated: false)
                }
            }
        }
    }
    
    // System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
// Extensions
extension ForgotPasswordVC: UITextFieldDelegate { }
