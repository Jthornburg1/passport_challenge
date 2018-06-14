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
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        interestsContainerView.layer.cornerRadius = 3
    }
    
    func configureFor(profile: Profile) {
        if let name = profile.name {
            nameLabel.text = name
        }
        if let gender = profile.gender {
            genderLabel.text = gender
        }
        if let id = profile.id {
            idLabel.text = String(describing: id)
        }
        if let hobbies = profile.hobbies {
            let separatedHobbies = hobbies.replacingOccurrences(of: ",", with: ", ")
            interestListLabel.text = separatedHobbies
        }
        if let gender = profile.gender {
            switch gender {
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
}
