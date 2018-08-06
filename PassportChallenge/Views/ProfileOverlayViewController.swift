//
//  ProfileOverlayViewController.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/13/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import UIKit

protocol UpdateDelegate {
    func update(profile: Profile)
}

class ProfileOverlayViewController: UIViewController, UITextFieldDelegate, UpdateDelegate {

    @IBOutlet weak var removeHobbyButton: UIButton!
    @IBOutlet weak var addHobbyButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var hobbiesLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var profile: Profile!
    var delegate: OverlayDelegate?
    var updatedHobbies: String?
    var hobbyTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatedHobbies = profile.hobbies
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.black
        configureFor(profile: profile)
        dismissButton.backgroundColor = UIColor.white
        dismissButton.setTitleColor(UIColor.darkGray, for: .normal)
        deleteButton.backgroundColor = UIColor.red
        deleteButton.setTitleColor(UIColor.white, for: .normal)
        addHobbyButton.layer.cornerRadius = 3
        removeHobbyButton.layer.cornerRadius = 3
    }
    
    func update(profile: Profile) {
        configureFor(profile: profile)
    }
    
    func configureFor(profile: Profile) {
        nameLabel.text = profile.name
        genderLabel.text = profile.gender
        idLabel.text = String(describing: profile.id)
        ageLabel.text = String(describing: profile.age)
        let spaced = profile.hobbies.replacingOccurrences(of: ",", with: ", ")
        hobbiesLabel.text = spaced
        profile.getImage { (success, image) in
            if let img = image {
                self.profileImage.image = img
            }
        }
    }
    
    @IBAction func didTapDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Delete?", message: "Are you sure", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            let id = self.profile.id
            FirebaseStorageDelete.shared.DeleteFileAt(location: self.profile.deletion_string)
            FirebaseDelete.shared.deleteProfile(id: id)
            self.delegate?.remove(overlay: self)
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func didTapDismiss(_ sender: Any) {
        delegate?.remove(overlay: self)
    }
    
    @IBAction func didTapRemoveHobby(_ sender: Any) {
        var hobbyArray = [String.SubSequence]()
        hobbyArray = profile.hobbies.split(separator: ",")
        let actionSheet = UIAlertController(title: "Remove?", message: "Select the hobby to remove", preferredStyle: .actionSheet)
        for hobby in hobbyArray {
            let action = UIAlertAction(title: String(describing: hobby), style: .default) { (action) in
                let newHobbies = hobbyArray.joined(separator: ",")
                self.updatedHobbies! = newHobbies.replacingOccurrences(of: hobby + ",", with: "")
                self.updatedHobbies! = self.updatedHobbies!.replacingOccurrences(of: hobby, with: "")
                self.updatedHobbies! = self.updatedHobbies!.replacingOccurrences(of: ",,", with: ",")
                if self.updatedHobbies!.hasPrefix(",") {
                    self.updatedHobbies! = String(describing: self.updatedHobbies!.dropFirst())
                }
                self.addHobbies()
            }
            actionSheet.addAction(action)
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func didTapAddHobby(_ sender: Any) {
        let alert = UIAlertController(title: "+", message: "Type the name of your new hobby:", preferredStyle: .alert)
        alert.addTextField { (tf) in
            self.hobbyTextField = tf
            self.hobbyTextField?.placeholder = "Hobby Name"
            self.hobbyTextField?.delegate = self
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Add This Hobby", style: .default) { (action) in
            if self.updatedHobbies == nil || self.updatedHobbies == "" {
                self.updatedHobbies = self.hobbyTextField!.text!
            } else if let hbbs = self.updatedHobbies {
                self.updatedHobbies = hbbs.appending("," + self.hobbyTextField!.text!)
            }
            self.addHobbies()
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    func addHobbies() {
        let id = profile.id 
        FirebasePatch.shared.update(hobbies: updatedHobbies!, userId: id)
        delegate?.updateProfiles()
    }
    
    //TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
