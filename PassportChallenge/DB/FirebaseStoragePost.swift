//
//  FirebaseStoragePost.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/18/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseStoragePost {
    
    public static let shared = FirebaseStoragePost()
    
    fileprivate init(){}
    
    func post(image: UIImage, completion: @escaping (String) -> ()) {
        let storageRef = Storage.storage().reference()
        let id = UUID().uuidString
        let newPhotoRef = storageRef.child("images/\(id)")
        if let data = UIImagePNGRepresentation(image) {
            let uploadTask = newPhotoRef.putData(data, metadata: nil) { (metadata, error) in
                newPhotoRef.downloadURL { (url, error) in
                    guard let downloadUrl = url else { print(error?.localizedDescription ?? String()); return }
                    let strUrl = String(describing: downloadUrl)
                    completion(strUrl)
                }
            }
            uploadTask.resume()
        }
    }
}
