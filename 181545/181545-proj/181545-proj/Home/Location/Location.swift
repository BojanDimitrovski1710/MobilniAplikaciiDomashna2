//
//  Location.swift
//  181545-proj
//
//  Created by SOCD on 11/28/22.
//  Copyright © 2022 BD. All rights reserved.
//

import Foundation
import CoreLocation
struct Location: Codable{
    let name :String
    let coordinates :Coords
    let image_url :String
    
}

struct Coords: Codable{
    let lat: Double
    let lon: Double
}

struct LocationList: Codable{
    var locations: [Location]
}
