//
//  FirebaseDelete.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/20/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseDelete {
    
    public static let shared = FirebaseDelete()
    var ref: DatabaseReference!
    
    fileprivate init(){}
    
    func deleteProfile(id: Int) {
        ref = Database.database().reference().child("profiles/\(id)")
        ref.removeValue()
    }
}
