//
//  User.swift
//  181545-proj
//
//  Created by socd on 11/14/22.
//  Copyright © 2022 BD. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let password: String
    var imageData: Data?
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case imageData
    }
}

struct LoginInfo: Codable{
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey{
        case email
        case password
    }
}

