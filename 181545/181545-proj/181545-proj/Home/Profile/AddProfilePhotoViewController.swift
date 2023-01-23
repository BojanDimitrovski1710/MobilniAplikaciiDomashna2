import Foundation
import UIKit
import MBProgressHUD
import AudioToolbox
final class AddProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    //MARK: Properties
    let imagePicker = UIImagePickerController()
    var user: User!
    
    //MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var submitImageButton: UIButton!
    @IBOutlet weak var pickImageGalleryButton: UIButton!
    @IBOutlet weak var pickImageCameraButton: UIButton!
    
    //MARK: Lifecycle Functions
    override func viewDidLoad() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        setupNav()
        setupUI()
    }
    
    func setupNav(){
        self.navigationItem.title = "Change Profile Photo"
        let leftButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.dismissProfileImagePicker))
        self.navigationItem.leftBarButtonItem = leftButton
        
    }
    
    func setupUI(){
        let cornerRadius = 15
        submitImageButton.layer.cornerRadius = CGFloat(cornerRadius)
        pickImageGalleryButton.layer.cornerRadius = CGFloat(cornerRadius)
        pickImageCameraButton.layer.cornerRadius = CGFloat(cornerRadius)
    }	
    
    override func viewWillAppear(_ animated: Bool) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        //self.pickImageButtonClicked(self)
        //pickImage()
    }
    
    //MARK: Functions
    
    func pickImage(){
        present(imagePicker, animated: true, completion: nil)
    }
    
    func shakeButton(button: UIButton){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        let animation =  CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: button.center.x - 5, y: button.center.y - 5 ))
        animation.toValue = NSValue(cgPoint: CGPoint(x: button.center.x + 5, y: button.center.y + 5 ))
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 0
        button.layer.borderColor = UIColor(red: 100, green: 0, blue: 0, alpha: 1).cgColor
        button.layer.add(animation, forKey: "position")
        
    }
    
    @objc func dismissProfileImagePicker(){
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        MBProgressHUD.hide(for: self.view, animated: true)

            dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitImage(_ sender: Any) {
        
        if self.imageView.image == nil {
            self.shakeButton(button: self.pickImageGalleryButton)
            self.shakeButton(button: self.pickImageCameraButton)
            let alert = UIAlertController(title: "Invalid Submisson", message: "Please choose a picture before submitting", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let imageData: Data = UIImagePNGRepresentation(self.imageView.image!)! as Data
            self.user.imageData = imageData
            let data = UserDefaults.standard.data(forKey: "LoginInfo")
            if data != nil{
               let encoder = PropertyListEncoder()
                if let encoded = try? encoder.encode(self.user){
                   UserDefaults.standard.set(encoded, forKey: "UserInfo")
               }
            }
            let userInfo = ["item": self.user as User]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userPhotoChanged"), object: nil, userInfo: userInfo)
            MBProgressHUD.hide(for: self.view, animated: true)
            self.dismissProfileImagePicker()
        }
        
    }
    
    @IBAction func pickImageGalleryButtonClicked(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        imagePicker.sourceType = .photoLibrary
        self.pickImageGalleryButton.layer.borderWidth = 0
        self.pickImageCameraButton.layer.borderWidth = 0
        MBProgressHUD.hide(for: self.view, animated: true)
        pickImage()
    }
    
    @IBAction func pickImageCameraButtonClicked(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.pickImageCameraButton.layer.borderWidth = 0
        self.pickImageGalleryButton.layer.borderWidth = 0
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController(title: nil, message: "Device has no camera.", preferredStyle: .alert)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            let okAction = UIAlertAction(title: "Alright", style: .default, handler: { (alert: UIAlertAction!) in
            })
        
            alertController.addAction(okAction)
            MBProgressHUD.hide(for: self.view, animated: true)
            self.present(alertController, animated: true, completion: nil)
        } else {
            imagePicker.sourceType = .camera
            MBProgressHUD.hide(for: self.view, animated: true)
            pickImage()
        }
        
    }
}

