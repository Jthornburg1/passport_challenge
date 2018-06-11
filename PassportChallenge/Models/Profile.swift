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
    var name: String?
    var age: Int?
    var hobbies: String?
    var id: Int?
    var gender: String?
    var image_url: String?
    
    func from(dictionary: [String:AnyObject], id: Int) {
        let fields = ["gender","hobbies","image_url","name"]
        for field in fields {
            if let value = dictionary[field] as? String {
                setValue(value, forKey: field)
            }
        }
        if let age = dictionary["age"] {
            if let intAge = Int(String(describing: age)) {
                self.age = intAge
            }
        }
        self.id = id
    }
    
    func hobbiesToArray() -> [String] {
        var hobbiesArray = [String]()
        if let hobbies = self.hobbies {
            hobbiesArray = hobbies.components(separatedBy: ",")
        }
        return hobbiesArray
    }
    
    func getImage(completion: @escaping (Bool, UIImage?) -> ()) {
        if let urlString = image_url {
            guard let url = URL(string: urlString) else { completion(false,nil); return }
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
        } else { completion(false,nil); return }
    }
}


