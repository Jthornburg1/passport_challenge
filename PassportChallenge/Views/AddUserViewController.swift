//
//  AddUserViewController.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/15/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {

    @IBOutlet weak var addProfileButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func didTapCancel(_ sender: Any) {
        
    }
    
    @IBAction func didTapAddProfile(_ sender: Any) {
        print("Add Profile")
    }
}
