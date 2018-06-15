//
//  FirebasePatch.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/15/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebasePatch {
    
    public static let shared = FirebasePatch()
    var ref: DatabaseReference?
    
    fileprivate init(){ ref = Database.database().reference() }
    
    func update(hobbies: String, userId: Int) {
        let childUpdate = ["/profiles/\(userId)/hobbies":hobbies]
        print(childUpdate)
        ref!.updateChildValues(childUpdate)
    }
}
