//
//  CompleteListVC.swift
//  Listpie
//
//  Created by Ebru on 23/10/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CompleteListVC: UIViewController {
    
    var listCount = 1
    var itemNameArray: [String] = [""]
    var itemDescriptionArray: [String] = [""]
    var itemImageArray: [UIImage?] = [UIImage()]
    
    var rowBeingEdited: Int? = nil
    var rowAddingImage: Int? = nil
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var completeBtn: UIButton!
    
    var listTitle: String!
    var listDescription: String!
    var isPublic: Bool!
    var listImage: UIImage!
    var listCategory: ListCategoryType!
    
    // Actions
    @IBAction func addImageBtnWasPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.navigationBar.tintColor = .black
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        rowAddingImage = sender.tag
        print(rowAddingImage!)
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func createListBtnWasPressed(_ sender: Any) {
        if let row = rowBeingEdited {
            let indexPath = NSIndexPath(row: row, section: 0)
            let cell: AddItemCell? = tableView.cellForRow(at: indexPath as IndexPath) as! AddItemCell?
            cell?.itemNameTextField.resignFirstResponder()
            cell?.itemDescriptionTextView.resignFirstResponder()
        }
        let itemCount = itemNameArray.count
        
        var noEmptyNameFields = true
        
        if itemCount > 0 {
            for i in 0 ..< itemCount {
                if itemNameArray[i] == "" {
                    noEmptyNameFields = false
                }
            }
        }
        if noEmptyNameFields {
            SVProgressHUD.show(withStatus: "Creating...")
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            let creationDate = Date().toString(withFormat: "yyyy-MM-dd HH:mm:ss")
            
            DataService.instance.createList(withTitle: listTitle, withDescription: listDescription, withVisibility: isPublic, withImage: listImage, withCategory: listCategory.rawValue, withCreationDate: creationDate, forUID: (Auth.auth().currentUser?.uid)!, withItemNames: itemNameArray, withItemDescriptions: itemDescriptionArray, withItemImages: itemImageArray as! [UIImage], creationComplete: { (isCreated) in
                
                SVProgressHUD.dismiss()
                UIApplication.shared.endIgnoringInteractionEvents()
                if isCreated {
                    SVProgressHUD.showSuccess(withStatus: "The list has just been created.")
                    self.performSegue(withIdentifier: TO_USER_LISTS_FROM_CREATE_LIST, sender: self)
                } else {
                    SVProgressHUD.showError(withStatus: "The list could not be created.")
                }
            })
        }
    }
    @IBAction func addItemBtnWasPressed(_ sender: Any) {
        listCount += 1
        itemNameArray.append("")
        itemDescriptionArray.append("")
        itemImageArray.append(UIImage())
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        tableView.tableViewScrollToBottom(animated: true)
    }
    
    // System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Item"
        
        completeBtn.bindToKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CompleteListVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CompleteListVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        let indexPath = NSIndexPath(row: 0, section: 0)
        let cell: AddItemCell? = tableView.cellForRow(at: indexPath as IndexPath) as! AddItemCell?
        cell?.itemNameTextField.becomeFirstResponder()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_USER_LISTS_FROM_CREATE_LIST {
            let userLitsVC = segue.destination as! UserListsVC
            userLitsVC.selectedCreatedBtn = true
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            navigationItem.backBarButtonItem = barBtn
        }
    }

    // Custom Functions
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight + 265, 0)
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }
}
// Extensions
extension CompleteListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemCell") as? AddItemCell else { return UITableViewCell() }
        cell.configureCell(itemNo: indexPath.row + 1, itemName: itemNameArray[indexPath.row], itemImage: itemImageArray[indexPath.row]!, itemDescription: itemDescriptionArray[indexPath.row])
        cell.selectionStyle = .none;
        
        cell.itemNameTextField.tag = indexPath.row
        cell.itemNameTextField.delegate = self
        cell.itemImageView.tag = indexPath.row
        cell.addImageBtn.tag = indexPath.row
        cell.itemDescriptionTextView.tag = indexPath.row
        cell.itemDescriptionTextView.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if listCount > 1 {
            if editingStyle == .delete {
                listCount -= 1
                itemNameArray.remove(at: indexPath.row)
                itemDescriptionArray.remove(at: indexPath.row)
                itemImageArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
}
extension CompleteListVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        rowBeingEdited = textField.tag
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let row = textField.tag
        guard let itemName = textField.text else { return }
        itemNameArray[row] = itemName
        rowBeingEdited = nil
    }
}
extension CompleteListVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        rowBeingEdited = textView.tag
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        let row = textView.tag
        guard let itemDescription = textView.text else { return }
        itemDescriptionArray[row] = itemDescription
        rowBeingEdited = nil
    }
}
extension CompleteListVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            if let row = rowAddingImage {
                let indexPath = NSIndexPath(row: row, section: 0)
                let cell: AddItemCell? = tableView.cellForRow(at: indexPath as IndexPath) as! AddItemCell?
                cell?.itemImageView.image = selectedImage
                itemImageArray[row] = selectedImage
                rowAddingImage = nil
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
