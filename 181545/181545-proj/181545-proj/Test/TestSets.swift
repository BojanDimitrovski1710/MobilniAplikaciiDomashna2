//
//  TestSets.swift
//  181545-proj
//
//  Created by SOCD on 11/28/22.
//  Copyright © 2022 BD. All rights reserved.
//

class TestSets{
    var locationSet: [Location]?
    
    func TestSets(){
        
    }
    
    func getLocations() -> [Location]?{
        self.locationSet = []
        self.locationSetInit()
        return self.locationSet
    }
    
    func locationSetInit(){
        let imageUrl = "idk"
        for i in 0...10{
            var name = "Location "
            name.append(contentsOf: String(i))
            var description = "Description "
            description.append(contentsOf: String(i))
            let loc = Location(name: name, description: description, image_url: imageUrl)
            self.locationSet?.append(loc)
        }
    }
}
