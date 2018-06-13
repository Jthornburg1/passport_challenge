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
    
    func postProfileToFireBase() {
        let random = String(describing: Int(arc4random_uniform(999999999)))
        let profile = ["name":"Lynn Dylan","age":"43","gender":"female","image_url":"https://firebasestorage.googleapis.com/v0/b/passportchallenge-92c02.appspot.com/o/womannude.jpeg?alt=media&token=fa0f8998-4d48-4377-924b-2819e12b86c2","hobbies":"scrap-booking,surfing,house-flipping","id":"\(random)"]
        let childUpdates = ["/profiles/\(random)":profile]
        ref.updateChildValues(childUpdates)
    }
}
