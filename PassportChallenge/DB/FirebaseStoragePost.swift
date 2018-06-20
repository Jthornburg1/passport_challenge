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
    
    func post(image: UIImage, completion: @escaping ((String,String)) -> ()) {
        let storageRef = Storage.storage().reference()
        let id = UUID().uuidString
        let childString = "images/\(id)"
        let newPhotoRef = storageRef.child(childString)
        if let data = UIImageJPEGRepresentation(image, 0.25) {
            let uploadTask = newPhotoRef.putData(data, metadata: nil) { (metadata, error) in
                newPhotoRef.downloadURL { (url, error) in
                    guard let downloadUrl = url else { print(error?.localizedDescription ?? String()); return }
                    let strUrl = String(describing: downloadUrl)
                    completion((strUrl,childString))
                }
            }
            uploadTask.resume()
        }
    }
}
