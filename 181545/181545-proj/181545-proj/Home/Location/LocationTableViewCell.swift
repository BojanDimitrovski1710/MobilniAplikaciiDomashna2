//
//  LocationTableViewCell.swift
//  181545-proj
//
//  Created by SOCD on 11/28/22.
//  Copyright © 2022 BD. All rights reserved.
//

import UIKit
import MBProgressHUD
class LocationTableViewCell: UITableViewCell{
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var viewDetails: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    @IBAction func viewDetailsClicked(_ sender: Any) {
        var search = "currentUser"
        let decoder = PropertyListDecoder()
        let data = UserDefaults.standard.data(forKey: search)
        if data != nil{
            let user = try! decoder.decode(User.self, from: data!)
            search = user.email + "Locations"
            let userList = UserDefaults.standard.data(forKey: search)
            var list: LocationList
            if userList != nil{
                list = try! decoder.decode(LocationList.self, from: userList!)
                for loc in list.locations{
                    if loc.name == self.title.text{
                        let userInfo = ["item": loc as Location]
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "viewLocation"), object: nil, userInfo: userInfo)
                        break;
                    }
                }
            }
        }
    }
    
    @IBAction func deleteSelected(_ sender: Any) {
        var search = "currentUser"
        let decoder = PropertyListDecoder()
        let data = UserDefaults.standard.data(forKey: search)
        if data != nil{
            let user = try! decoder.decode(User.self, from: data!)
            search = user.email + "Locations"
            let userList = UserDefaults.standard.data(forKey: search)
            var list: LocationList
            if userList != nil{
                list = try! decoder.decode(LocationList.self, from: userList!)
                var i=0
                for loc in list.locations{
                    if loc.name == self.title.text{
                        list.locations.remove(at: i)
                        let encoder = PropertyListEncoder()
                        if let encoded = try? encoder.encode(list){
                            UserDefaults.standard.set(encoded, forKey: search)
                        }
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadData"), object: nil)
                        break;
                    }
                    i = i + 1
                }
            }
        }
    }
}
