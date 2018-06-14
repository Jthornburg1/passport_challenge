//
//  ProfileOverlayViewController.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/13/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import UIKit

class ProfileOverlayViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.black
        profile.getImage { (success, image) in
            if let img = image {
                self.profileImage.image = img
            }
        }
        configureFor(profile: profile)
    }
    
    func configureFor(profile: Profile) {
        if let name = profile.name {
            nameLabel.text = name
        }
        if let genderTxt = profile.gender {
            genderLabel.text = genderTxt
        }
        if let idTxt = profile.id {
            idLabel.text = String(describing: idTxt)
        }
        if let ageText = profile.age {
            ageLabel.text = String(describing: ageText)
        }
        if let hobbies = profile.hobbies {
            let spaced = hobbies.replacingOccurrences(of: ",", with: ", ")
            hobbiesLabel.text = spaced
        }
    }
    
    @IBAction func didTapDelete(_ sender: Any) {
        
    }
    @IBAction func didTapDismiss(_ sender: Any) {
        delegate?.removeOverlay()
    }
}
