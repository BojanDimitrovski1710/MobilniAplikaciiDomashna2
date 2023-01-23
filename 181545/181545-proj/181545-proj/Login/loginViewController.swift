//
//  loginViewController.swift
//  181545-proj
//
//  Created by socd on 11/14/22.
//  Copyright © 2022 BD. All rights reserved.
//

import UIKit
import MBProgressHUD
import AudioToolbox
class loginViewController: UIViewController {
    
    // MARK: - Variables
    private var rememberMe = false
    
    // MARK: - Outlets
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupUI()
    }
    
    private func setupUI(){
        registerButton.layer.cornerRadius = 15
        loginButton.layer.cornerRadius = 15
        let decoder = PropertyListDecoder()
        let data = UserDefaults.standard.data(forKey: "LoginInfo")
        if data != nil{
            let info = try? decoder.decode(LoginInfo.self, from: data!)
            usernameField.text = info?.email
            passwordField.text = info?.password
        }
    }
    
    func shakeField(field: UITextField){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let animation =  CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: field.center.x - 5, y: field.center.y - 5 ))
        animation.toValue = NSValue(cgPoint: CGPoint(x: field.center.x + 5, y: field.center.y + 5 ))
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor(red: 100, green: 0, blue: 0, alpha: 1).cgColor
        field.layer.add(animation, forKey: "position")
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    private func checkFields(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if usernameField.text!.isEmpty{
            self.shakeField(field: usernameField)
        }
        if passwordField.text!.isEmpty{
            self.shakeField(field: passwordField)
        }
        MBProgressHUD.hide(for: self.view, animated: true)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        let alert = UIAlertController(title: "Invalid Login", message: "All fields must be filled in", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func revertEmailToNormal(_ sender: Any) {
        usernameField.layer.borderWidth = 0
    }
    
    @IBAction func revertPasswordToNormal(_ sender: Any){
        passwordField.layer.borderWidth = 0
    }
    
    
    @IBAction func toggleRemember(_ sender: Any) {
        if !rememberMe {
            rememberMe = true
        }else{
            rememberMe = false
        }
    }
    
    //MARK: Login Functions
    
    func remember(LoginInfo: LoginInfo){
        let encoder = PropertyListEncoder()
        if let encoded = try? encoder.encode(LoginInfo){
            UserDefaults.standard.set(encoded, forKey: "LoginInfo")
        }
        
    }
    
    @IBAction func login(_ sender: Any) {
        if passwordField.text!.isEmpty || usernameField.text!.isEmpty{
            checkFields()
        }else{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let parameters = LoginInfo(email: usernameField.text!, password: passwordField.text!)
            let decoder = PropertyListDecoder()
            let data = UserDefaults.standard.data(forKey: usernameField.text!)
            if data != nil{
                let info = try? decoder.decode(User.self, from: data!)
                if passwordField.text != info?.password{
                    let alert = UIAlertController(title: "Invalid Login", message: "Incorrect Password", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel))
                    shakeField(field: passwordField)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    if rememberMe{
                        self.remember(LoginInfo: parameters)
                    }
                    handleSuccesfullLogin(user: info!)
                }
            }else{
                let alert = UIAlertController(title: "Invalid Login", message: "No account has been registered under that email", preferredStyle: UIAlertControllerStyle.alert)
                shakeField(field: usernameField)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel))
                MBProgressHUD.hide(for: self.view, animated: true)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func register(_ sender: Any) {
        if passwordField.text!.isEmpty || usernameField.text!.isEmpty{
            checkFields()
        }else{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let parameters = LoginInfo(email: usernameField.text!, password: passwordField.text!)
            let data = UserDefaults.standard.data(forKey: usernameField.text!)
            if data != nil{
                let alert = UIAlertController(title: "Invalid Login", message: "An account with that email is already registered", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel))
                MBProgressHUD.hide(for: self.view, animated: true)
                self.present(alert, animated: true, completion: nil)
            }else{
                let user = User(email: usernameField.text!,password: passwordField.text!, imageData: nil)
                let encoder = PropertyListEncoder()
                if let encoded = try? encoder.encode(user){
                    UserDefaults.standard.set(encoded, forKey: usernameField.text!)
                }
                if rememberMe{
                    self.remember(LoginInfo: parameters)
                }
                handleSuccesfullLogin(user: user)
            }
        }
    }
    
    func handleSuccesfullLogin(user: User){
        let encoder = PropertyListEncoder()
        if let encoded = try? encoder.encode(user){
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
        let NewStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let HomeViewController = NewStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        HomeViewController.user = user
        MBProgressHUD.hide(for: self.view, animated: true)
        self.navigationController?.setViewControllers([HomeViewController], animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

