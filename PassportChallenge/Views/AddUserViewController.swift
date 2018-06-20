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

    @IBOutlet weak var userImage: UIImageView!
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
    var newProfileDict = [String:AnyObject]()
    var downloadUrlString: String?
    var activityIndicator: UIActivityIndicatorView?
    var deletionString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextfields()
        photoButton.layer.cornerRadius = 3
        displayContainerView.layer.cornerRadius = 3
    }
    
    func configureTextfields() {
        for tf in textfields {
            let attr = [NSAttributedStringKey.foregroundColor:UIColor.white]
            let attrPlcHldrString = NSAttributedString(string: tf.placeholder!, attributes: attr)
            tf.attributedPlaceholder = attrPlcHldrString
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        delegate?.remove(overlay: self)
    }
    
    @IBAction func didTapAddProfile(_ sender: Any) {
        newProfileDict["name"] = self.nameTextfield.text! as AnyObject
        newProfileDict["age"] = self.ageTextfield.text! as AnyObject
        newProfileDict["hobbies"] = self.hobbyTextfield.text!.replacingOccurrences(of: ", ", with: ",") as AnyObject
        if let gender = self.selectedGender {
            newProfileDict["gender"] = gender.rawValue as AnyObject
        }
        if let urlString = downloadUrlString {
            newProfileDict["image_url"] = urlString as AnyObject
        }
        if let deletionString = deletionString {
            newProfileDict["deletion_string"] = deletionString as AnyObject
        }
        FirebasePost.shared.postProfileToFireBase(dictionary: newProfileDict)
        delegate?.updateProfiles()
        delegate?.remove(overlay: self)
    }
    
    @IBAction func segValueChanged(_ sender: Any) {
        if genderSegControl.selectedSegmentIndex == 0 {
            selectedGender = .female
        } else {
            selectedGender = .male
        }
    }
    
    @IBAction func didTapAddPhoto(_ sender: Any) {
        useCamera()
    }
}

extension AddUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func useCamera() {
        // For a fully fleshed-out app, I would check if permission was granted and, if not, present some type of alert.
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            imagePickerController.allowsEditing = false
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func addSpinner() {
        let rect = CGRect(x: (view.frame.width / 2) - 20, y: (view.frame.height / 2) - 20, width: 40, height: 40)
        activityIndicator = UIActivityIndicatorView(frame: rect)
        activityIndicator?.startAnimating()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        view.isUserInteractionEnabled = false
        addSpinner()
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userImage.image = image
            FirebaseStoragePost.shared.post(image: image) { (stringTuple) in
                self.activityIndicator?.stopAnimating()
                self.activityIndicator = nil
                self.view.isUserInteractionEnabled = true
                self.downloadUrlString = stringTuple.0
                self.deletionString = stringTuple.1
            }
        }
    }
}
