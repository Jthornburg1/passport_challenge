//
//  AddUserViewController.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/15/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextfields()
        var cameraImage = UIImage(named: "add_photo")
        cameraImage = cameraImage?.withRenderingMode(.alwaysTemplate)
        photoButton.tintColor = UIColor.darkGray
        photoButton.setBackgroundImage(cameraImage, for: .normal)
        photoButton.setTitle("", for: .normal)
        photoButton.contentMode = .scaleAspectFit
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
        
    }
}
