//
//  FirebaseStorageDelete.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/20/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseStorageDelete {
    
    public static let shared = FirebaseStorageDelete()
    
    fileprivate init(){}
    
    func DeleteFileAt(location: String) {
        let locationRef = Storage.storage().reference().child(location)
        locationRef.delete { (error) in
            if let er = error {
                print(er.localizedDescription)
            }
        }
    }
}
