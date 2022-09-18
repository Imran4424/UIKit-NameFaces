//
//  Person.swift
//  NameFaces
//
//  Created by Shah Md Imran Hossain on 18/9/22.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
