//
//  Profile.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/11/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import Foundation
import UIKit

class Profile: NSObject {
    var name = ""
    var age = 0
    var hobbies = ""
    var id = 0
    var gender = ""
    var image_url = ""
    var deletion_string = ""
    
    func from(dictionary: [String:AnyObject]) {
        if let gender = dictionary["gender"] as? String {
            self.gender = gender
        }
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        if let image_url = dictionary["image_url"] as? String {
            self.image_url = image_url
        }
        if let hobbies = dictionary["hobbies"] as? String {
            self.hobbies = hobbies
        }
        if let deletionString = dictionary["deletion_string"] as? String {
            self.deletion_string = deletionString
        }
        if let age = dictionary["age"] {
            if let intAge = Int(String(describing: age)) {
                self.age = intAge
            }
        }
        if let id = dictionary["id"] {
            if let intId = Int(String(describing: id)) {
                self.id = intId
            }
        }
    }
    
    func hobbiesToArray() -> [String] {
        var hobbiesArray = [String]()
        hobbiesArray = hobbies.components(separatedBy: ",")
        return hobbiesArray
    }
    
    func getImage(completion: @escaping (Bool, UIImage?) -> ()) {
        guard let url = URL(string: image_url) else { completion(false,nil); return }
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let dta = data {
                if let image = UIImage(data: dta) {
                    DispatchQueue.main.async(execute: {
                        completion(true,image)
                    })
                }
            } else { completion(false,nil); return }
        }
        task.resume()
    }
}


