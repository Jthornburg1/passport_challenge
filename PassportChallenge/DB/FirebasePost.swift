//
//  FirebasePost.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/12/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebasePost {
    
    public static let shared = FirebasePost()
    var ref: DatabaseReference!
    fileprivate init(){ ref = Database.database().reference() }
    
    func postProfileToFireBase(dictionary: [String:AnyObject]) {
        let random = String(describing: Int(arc4random_uniform(999999999)))
        var profile = dictionary
        profile["id"] = random as AnyObject
        let childUpdates = ["/profiles/\(random)":profile]
        ref.updateChildValues(childUpdates)
    }
}
