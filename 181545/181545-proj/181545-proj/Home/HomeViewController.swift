//
//  HomeViewController.swift
//  181545-proj
//
//  Created by socd on 11/14/22.
//  Copyright © 2022 BD. All rights reserved.
//

import UIKit
import MBProgressHUD
class HomeViewController: UIViewController {
    
    // MARK: Properties
    var data: LocationList = LocationList(locations: [])
    var user: User!
    
    @IBOutlet weak var addNewLocationButton: UIButton!
    @IBOutlet weak var locationTableView: UITableView!
    
    // MARK: Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        setupNotifications()
        let profileDetailsItem = UIBarButtonItem(
            image: UIImage(named: "user"),
                  style: .plain,
                  target: self,
                  action: #selector(profileDetailsActionHandler)
                )
        profileDetailsItem.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = profileDetailsItem
        self.navigationItem.title = "Locations"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupUI(){
        updateImage()
    }
    
    func setupData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let search = self.user.email + "Locations"
        let decoder = PropertyListDecoder()
        let userList = UserDefaults.standard.data(forKey: search)
        var list: LocationList
        if userList != nil{
            list = try! decoder.decode(LocationList.self, from: userList!)
        }else{
            list = LocationList(locations: [])
        }
        data = list
        locationTableView.dataSource = self
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    // MARK: Notifications
    
    func setupNotifications(){
        NotificationCenter
            .default
            .addObserver(forName: Notification.Name(rawValue: "didLogout"), object: nil, queue: nil) { notification in
                MBProgressHUD.showAdded(to: self.view, animated: true)
                let newStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = newStoryboard.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
                MBProgressHUD.hide(for: self.view, animated: true)
                self.navigationController?.setViewControllers(
                    [loginViewController], animated: true)
            }
        NotificationCenter
                   .default
            .addObserver(self, selector: #selector(HomeViewController.viewLocation), name: NSNotification.Name(rawValue: "viewLocation"), object: nil)
        NotificationCenter
        .default
        .addObserver(self, selector: #selector(HomeViewController.updateUser), name: Notification.Name("userPhotoChanged"), object: nil)
        NotificationCenter
        .default
            .addObserver(forName: Notification.Name(rawValue: "reloadData"), object: nil, queue: nil) {_ in 
                self.setupData()
                self.locationTableView.reloadData()
        }
    }
    
    // MARK: Functions
    
    @objc func viewLocation(_ notification: Notification){
        guard let location = notification.userInfo?["item"] as? Location else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let NewStoryboard = UIStoryboard(name: "ViewLocation", bundle: nil)
        let ViewLocationViewController = NewStoryboard.instantiateViewController(withIdentifier: "ViewLocation") as! ViewLocationViewController
        ViewLocationViewController.location = location
        let navigationController = UINavigationController(rootViewController: ViewLocationViewController)
        MBProgressHUD.hide(for: self.view, animated: true)
        present(navigationController, animated: true)
    }
    
    @objc func profileDetailsActionHandler(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let NewStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let ProfileViewController = NewStoryboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        ProfileViewController.user = user
        let navigationController = UINavigationController(rootViewController: ProfileViewController)
        MBProgressHUD.hide(for: self.view, animated: true)
        present(navigationController, animated: true)
    }
    
    @objc func reload(){
        self.locationTableView.reloadData()
    }
    
    func updateImage(){
        if user.imageData != nil{
            //let newImage = UIImage(data:user.imageData!, scale: 1.0)
            //navigationItem.rightBarButtonItem?.image = newImage
        }
        
    }
    @objc func updateUser(_ notification: Notification){
        guard let userData = notification.userInfo?["item"] as? User else { return }
        self.user = userData
        updateImage()
    }
    
    
    @IBAction func presentAddNewLocation(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let NewStoryboard = UIStoryboard(name: "AddLocation", bundle: nil)
        let AddLocationViewController = NewStoryboard.instantiateViewController(withIdentifier: "AddLocation") as! AddLocationViewController
        let navigationController = UINavigationController(rootViewController: AddLocationViewController)
        AddLocationViewController.user = self.user
        AddLocationViewController.locationTableView = self.locationTableView
        MBProgressHUD.hide(for: self.view, animated: true)
        present(navigationController, animated: true)
    }
    
}

//MARK: Extensions

extension HomeViewController: UITableViewDelegate{
    
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.locations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let loc = data.locations[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "proto1", for: indexPath) as? LocationTableViewCell
            else{
                print("Something went wrong")
                return UITableViewCell()
            }
        cell.title.text = loc.name
        return cell
        }
}
