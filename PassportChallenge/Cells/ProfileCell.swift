//
//  ProfileCell.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/12/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var interestsContainerView: UIView!
    @IBOutlet weak var interestListLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.image = UIImage(named: "placeholder")
        interestsContainerView.layer.cornerRadius = 3
    }
    
    override func prepareForReuse() {
        profileImageView.image = UIImage(named: "placeholder")
    }
    
    func configureFor(profile: Profile) {
        ageLabel.text = String(describing: profile.age)
        nameLabel.text = profile.name
        genderLabel.text = profile.gender
        idLabel.text = String(describing: profile.id)
        let separatedHobbies = profile.hobbies.replacingOccurrences(of: ",", with: ", ")
        interestListLabel.text = separatedHobbies
        switch profile.gender {
        case "male":
            contentView.backgroundColor = UIColor.lightBlue()
            interestListLabel.textColor = UIColor.blue
        case "female":
            contentView.backgroundColor = UIColor.pink()
            interestListLabel.textColor = UIColor.red
        default:
            contentView.backgroundColor = UIColor.lightGray
        }
    }
}
