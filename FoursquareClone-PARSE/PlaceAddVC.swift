//
//  PlaceDetailsVC.swift
//  FoursquareClone-PARSE
//
//  Created by Hakan Baran on 1.10.2022.
//

import UIKit

class PlaceAddVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var placeNameText: UITextField!
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var placeCommentText: UITextField!
    @IBOutlet weak var placeImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.done, target: self, action: #selector(nextButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "BACK", style: UIBarButtonItem.Style.done, target: self, action: #selector(backButtonClicked))
        
        let gestureHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureHideKeyboard)
        
        
        placeImage.isUserInteractionEnabled = true
        
        let selectedImage = UITapGestureRecognizer(target: self, action: #selector(chosenImage))
        
        placeImage.addGestureRecognizer(selectedImage)
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc func chosenImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.originalImage] as? UIImage
        
        self.dismiss(animated: true)
        
        
    }
    
    
    @objc func nextButtonClicked() {
        
        if placeNameText.text != "" && placeTypeText.text != "" && placeCommentText.text != "" {
            
            if let chosenImage = placeImage.image {
                
                let placeModel = PlaceModel.sharedInstance
                
                placeModel.placeName = placeNameText.text!
                placeModel.placeType = placeTypeText.text!
                placeModel.placeComment = placeCommentText.text!
                placeModel.placeImage = chosenImage
                
            }
            performSegue(withIdentifier: "toMapVC", sender: nil)
        } else {
            
            let alert = UIAlertController(title: "Error!", message: "Name/Type/Comment????", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alert.addAction(okButton)
            present(alert, animated: true)
        }
        
        
        
        
        
    }
    
    @objc func backButtonClicked() {
        
        self.dismiss(animated: true)
        
    }
    
    
    

    

}
