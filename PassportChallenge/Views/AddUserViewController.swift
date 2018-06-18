//
//  AddUserViewController.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/15/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import UIKit

enum Gender: String {
    case male = "male"
    case female = "female"
}

class AddUserViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textfields: [UITextField]!
    @IBOutlet weak var hobbyTextfield: UITextField!
    @IBOutlet weak var displayContainerView: UIView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var genderSegControl: UISegmentedControl!
    @IBOutlet weak var ageTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var addProfileButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate: OverlayDelegate?
    var selectedGender: Gender?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextfields()
        photoButton.layer.cornerRadius = 3
    }
    
    func configureTextfields() {
        for tf in textfields {
            let attr = [NSAttributedStringKey.foregroundColor:UIColor.white]
            let attrPlcHldrString = NSAttributedString(string: tf.placeholder!, attributes: attr)
            tf.attributedPlaceholder = attrPlcHldrString
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        
    }
    
    @IBAction func didTapAddProfile(_ sender: Any) {
        print("Add Profile")
    }
    
    @IBAction func segValueChanged(_ sender: Any) {
        
    }
    
    @IBAction func didTapAddPhoto(_ sender: Any) {
        useCamera()
    }
}

extension AddUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func useCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            imagePickerController.allowsEditing = false
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    }
}
