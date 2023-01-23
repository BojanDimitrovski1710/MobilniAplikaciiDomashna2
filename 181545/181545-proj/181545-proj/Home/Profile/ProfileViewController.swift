//
//  ProfileViewController.swift
//  181545-proj
//
//  Created by SOCD on 11/29/22.
//  Copyright © 2022 BD. All rights reserved.
//
import Foundation
import UIKit
import MBProgressHUD
import Kingfisher
class ProfileViewController: UIViewController{
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    var user: User!
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        setupNav()
        setupNotifications()
    }
    
    @objc func dismissProfile(){
        dismiss(animated: true)
    }
    
    func setupUI(){
        logOutButton.layer.cornerRadius = 15
        usernameLabel.text = user.email
        updateImage()
    }
    @objc func updateUser(_ notification: Notification){
        guard let userData = notification.userInfo?["item"] as? User else { return }
        self.user = userData
        let encoder = PropertyListEncoder()
        if let encoded = try? encoder.encode(user){
            UserDefaults.standard.set(encoded, forKey: user.email)
        }
        updateImage()
    }
    func updateImage(){
        if user.imageData != nil{
            let newImage = UIImage(data:user.imageData!, scale: 1.0)
            self.profileImage.image = newImage
        }
    }
    
    func setupNav(){
        self.navigationItem.title = "My Account"
        let leftButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.dismissProfile))
        self.navigationItem.leftBarButtonItem = leftButton
    }
    func setupNotifications(){
        let updateImage = Notification.Name("userPhotoChanged")
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(ProfileViewController.updateUser), name: updateImage, object: nil)
        NotificationCenter
        .default
        .addObserver(self, selector: #selector(HomeViewController.updateUser), name: updateImage, object: nil)

    }
    
    @IBAction func changeUserImage(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let newStoryboard = UIStoryboard(name: "AddProfilePhoto", bundle: nil)
        let AddProfilePhotoViewController = newStoryboard.instantiateViewController(withIdentifier: "AddProfilePhoto") as! AddProfileViewController
        let navController = UINavigationController(rootViewController: AddProfilePhotoViewController)
        AddProfilePhotoViewController.user = self.user
        MBProgressHUD.hide(for: self.view, animated: true)
        present(navController, animated: true)
    }
        
        @IBAction func logOut(_ sender: Any) {
            dismiss(animated: true) {
                _ = PropertyListDecoder()
                let data = UserDefaults.standard.data(forKey: "LoginInfo")
                if data != nil{
                    UserDefaults.standard.removeObject(forKey: "LoginInfo")
                }
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "didLogout"), object: nil)
            }
    }
}
