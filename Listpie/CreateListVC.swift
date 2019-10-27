//
//  CreateListVC.swift
//  Listpie
//
//  Created by Ebru on 04/10/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

class CreateListVC: UIViewController {
    
    var isPublic = true

    // Outlets
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var listTitleTextField: UITextField!
    @IBOutlet weak var listDescriptionTextView: UITextView!
    @IBOutlet weak var publicBtn: UIButton!
    @IBOutlet weak var privateBtn: UIButton!
    
    // Actions
    @IBAction func nextBtnWasPressed(_ sender: Any) {
        if listTitleTextField.text != "" {
            self.performSegue(withIdentifier: TO_ADD_LIST_DETAILS, sender: self)
        }
    }
    @IBAction func publicBtnWasPressed(_ sender: Any) {
        publicBtn.setSelectedColor()
        privateBtn.setDeselectedColor()
        isPublic = true
    }
    @IBAction func privateBtnWasPressed(_ sender: Any) {
        privateBtn.setSelectedColor()
        publicBtn.setDeselectedColor()
        isPublic = false
    }
    
    // System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New List"
        
        nextBtn.bindToKeyboard()
        self.navigationController?.navigationBar.isTranslucent = false;
    }
    override func viewDidAppear(_ animated: Bool) {
        listTitleTextField.becomeFirstResponder()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == TO_ADD_LIST_DETAILS) {
            if let addListDetailsVC = segue.destination as? AddListDetailsVC {
                addListDetailsVC.listTitle = listTitleTextField.text!
                addListDetailsVC.listDescription = listDescriptionTextView.text!
                addListDetailsVC.isPublic = isPublic
            }
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            navigationItem.backBarButtonItem = barBtn
        }
    }
}
// Extensions
extension CreateListVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

