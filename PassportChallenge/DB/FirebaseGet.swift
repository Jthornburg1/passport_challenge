//
//  FirebaseGet.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/11/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseGet {
    fileprivate init(){}
    public static let shared = FirebaseGet()
    
    var ref: DatabaseReference?
    
    func getProfiles(completion: @escaping ([Profile]) -> ()) {
        var profiles = [Profile]()
        ref = Database.database().reference()
        ref!.child("profiles").observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                // beginning to think there was no way to convert DataSnapshot to a data structure that was useable; hence the variable name 'unicorn'
                let unicorn = child.value as! [String:AnyObject]
                let profile = Profile()
                profile.from(dictionary: unicorn)
                profiles.append(profile)
            }
            DispatchQueue.main.async(execute: {
                completion(profiles)
            })
        })
    }
}
