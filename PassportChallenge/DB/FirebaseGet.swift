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
        ref!.child("profiles").observe(.value, with: {(snapshot) in
            // Must be emptied otherwise when an event in the database occurs (removal) the profiles count doubles.
            profiles.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
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
