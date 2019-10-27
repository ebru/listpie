//
//  MainVC.swift
//  Listpie
//
//  Created by Ebru on 12/09/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController {
    
    // Actions
    @IBAction func unwindToLogout(segue: UIStoryboardSegue) { }
    
    @IBAction func toSignUp(_ sender: Any) {
        performSegue(withIdentifier: TO_SIGNUP, sender: self)
    }
    
    @IBAction func toLogin(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN, sender: self)
    }
    
    // System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: TO_DASHBOARD, sender: self)
            } else {
                // No user is signed in.
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_SIGNUP || segue.identifier == TO_LOGIN {
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            navigationItem.backBarButtonItem = barBtn
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
// Extensions
extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "This e-mail is already in use."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid e-mail."
        case .networkError:
            return "Network error. Please try again later."
        case .weakPassword:
            return "Password must be at least 6 characters."
        case .wrongPassword:
            return "Invalid username or password."
        case .userNotFound:
            return "User is not found."
        default:
            return "Invalid username or password."
        }
    }
}
