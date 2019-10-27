//
//  AddListDetailsVC.swift
//  Listpie
//
//  Created by Ebru on 23/10/2017.
//  Copyright © 2017 Ebru Kaya. All rights reserved.
//

import UIKit

class AddListDetailsVC: UIViewController {
    
    var listTitle: String!
    var listDescription: String!
    var isPublic: Bool!
    var listImage = UIImage()
    var listCategory: ListCategoryType = .watch
    
    // Outlets
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pickImage: UIImageView!
    @IBOutlet weak var watchBtn: UIButton!
    @IBOutlet weak var listenBtn: UIButton!
    @IBOutlet weak var readBtn: UIButton!
    @IBOutlet weak var travelBtn: UIButton!
    @IBOutlet weak var foodBtn: UIButton!
    @IBOutlet weak var activityBtn: UIButton!
    
    // Actions
    @IBAction func nextBtnWasPressed(_ sender: Any) {
        self.performSegue(withIdentifier: TO_COMPLETE_LIST, sender: self)
    }
    @IBAction func pickImageBtnWasPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.navigationBar.tintColor = .black
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func watchBtnWasPressed(_ sender: Any) {
        watchBtn.setWatchSelectedColor()
        listenBtn.setDeselectedColor()
        readBtn.setDeselectedColor()
        travelBtn.setDeselectedColor()
        foodBtn.setDeselectedColor()
        activityBtn.setDeselectedColor()
        
        listCategory = .watch
    }
    @IBAction func listenBtnWasPressed(_ sender: Any) {
        listenBtn.setListenSelectedColor()
        watchBtn.setDeselectedColor()
        readBtn.setDeselectedColor()
        travelBtn.setDeselectedColor()
        foodBtn.setDeselectedColor()
        activityBtn.setDeselectedColor()
        
        listCategory = .listen
    }
    @IBAction func readBtnWasPressed(_ sender: Any) {
        readBtn.setReadSelectedColor()
        watchBtn.setDeselectedColor()
        listenBtn.setDeselectedColor()
        travelBtn.setDeselectedColor()
        foodBtn.setDeselectedColor()
        activityBtn.setDeselectedColor()
        
        listCategory = .read
    }
    @IBAction func travelBtnWasPressed(_ sender: Any) {
        travelBtn.setTravelSelectedColor()
        watchBtn.setDeselectedColor()
        listenBtn.setDeselectedColor()
        readBtn.setDeselectedColor()
        foodBtn.setDeselectedColor()
        activityBtn.setDeselectedColor()
        
        listCategory = .travel
    }
    @IBAction func foodBtnWasPressed(_ sender: Any) {
        foodBtn.setFoodSelectedColor()
        watchBtn.setDeselectedColor()
        listenBtn.setDeselectedColor()
        readBtn.setDeselectedColor()
        travelBtn.setDeselectedColor()
        activityBtn.setDeselectedColor()
        
        listCategory = .food
    }
    @IBAction func activityBtnWasPressed(_ sender: Any) {
        activityBtn.setActivitySelectedColor()
        watchBtn.setDeselectedColor()
        listenBtn.setDeselectedColor()
        readBtn.setDeselectedColor()
        travelBtn.setDeselectedColor()
        foodBtn.setDeselectedColor()
        
        listCategory = .activity
    }
    
    // System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List Details"
        
        watchBtn.setWatchSelectedColor()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == TO_COMPLETE_LIST) {
            if let completeListVC = segue.destination as? CompleteListVC {
                completeListVC.listTitle = listTitle
                completeListVC.listDescription = listDescription
                completeListVC.isPublic = isPublic
                completeListVC.listImage = listImage
                completeListVC.listCategory = listCategory
            }
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            navigationItem.backBarButtonItem = barBtn
        }
    }
}
// Extensions
extension AddListDetailsVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            pickImage.image = selectedImage
            listImage = selectedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
