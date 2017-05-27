//
//  NewUserViewController.swift
//  WhereYouAt
//
//  Created by Richard Du on 4/26/17.
//  Copyright © 2017 dys3. All rights reserved.
//
import UIKit
import Parse
import MBProgressHUD

class NewUserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmEmailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var screenNameTextField: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var profileImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        scrollView.bounces = false
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (Notification) in
            //print("hide keyboard")
            
            let contentInset:UIEdgeInsets = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInset
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (Notification) in
            //print("show keyboard")
            var userInfo = Notification.userInfo!
            var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            var contentInset:UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            self.scrollView.contentInset = contentInset
            
        }
    }

    

    @IBAction func dismissKeyboard(_ sender: Any) {
    
        view.endEditing(true)
        print("dismissing keyboard")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onSignup(_ sender: AnyObject) {
        
        let signupAlertController = UIAlertController(title: "Success", message: "", preferredStyle: .alert)
        // create an OK action
        
        let signupOKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here
            self.presentingViewController?.dismiss(animated: true, completion: {
                
                let vc = UIApplication.shared.keyWindow?.rootViewController
                vc?.performSegue(withIdentifier: "loginSegue", sender: nil)
            })
        }
        signupAlertController.addAction(signupOKAction)
        
        
        let newUser = PFUser()
        
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        newUser.email = emailTextField.text
        
        if passwordTextField.text != confirmPasswordTextField.text {
            let errorAlertController = UIAlertController(title: "Error", message: "Passwords do not match.", preferredStyle: .alert)
            // create an OK action
            let errorOKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            // add the OK action to the alert controller
            errorAlertController.addAction(errorOKAction)
            self.present(errorAlertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
            }
        }
        else if emailTextField.text != confirmEmailTextField.text {
            let errorAlertController = UIAlertController(title: "Error", message: "Emails do not match.", preferredStyle: .alert)
            // create an OK action
            let errorOKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            // add the OK action to the alert controller
            errorAlertController.addAction(errorOKAction)
            self.present(errorAlertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
            }
        }
        else {
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.backgroundView.color = UIColor.darkGray
            progressHUD.bezelView.color = UIColor.white
            progressHUD.backgroundView.alpha = 0.5
            progressHUD.backgroundView.isUserInteractionEnabled = false
            progressHUD.label.text = "Creating New User"
            self.view.endEditing(true)
            newUser.signUpInBackground { (success: Bool, error:Error?) in
                progressHUD.hide(animated: true)
                progressHUD.backgroundView.isUserInteractionEnabled = true
                if success {
                    
                    print("A new user was created")
                    newUser["screen_name"] = self.screenNameTextField.text
                    newUser["first_name"] = self.firstNameTextField.text
                    newUser["last_name"] = self.lastNameTextField.text
                    
                    if let image = self.profileImageView.image {
                        newUser["profilePic"] = self.getPFFileFromImage(image: image)
                    }
                    
                    newUser.saveInBackground(block: { (success:Bool, error: Error?) in
                        self.present(signupAlertController, animated: true) {
                            // optional code for what happens after the alert controller has finished presenting
                        }
                    })
                } else {
                    let errorAlertController = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                    // create an OK action
                    let errorOKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        // handle response here.
                    }
                    // add the OK action to the alert controller
                    errorAlertController.addAction(errorOKAction)
                    self.present(errorAlertController, animated: true) {
                        // optional code for what happens after the alert controller has finished presenting
                    }
                }
            }
        }
    }
    
    @IBAction func onTapImage(_ sender: UITapGestureRecognizer) {
        let vc = UIImagePickerController()
        
        vc.delegate = self
        vc.allowsEditing = true
        let chooseActionSheet = UIAlertController(title:"Choose image from",message: "choose", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {action in
            print("here")
            vc.sourceType = .camera
            self.present(vc, animated: true, completion: nil)
            
        })
        let photoRollAction = UIAlertAction(title: "Photo Library", style: .default, handler: {action in
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true, completion: nil)
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
        })
        
        chooseActionSheet.addAction(cameraAction)
        chooseActionSheet.addAction(photoRollAction)
        chooseActionSheet.addAction(cancelAction)
        
        self.present(chooseActionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("back")
        
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.profileImage = resize(image: editedImage)
        profileImageView.image = self.profileImage
        
        let radius = profileImageView.frame.width / 2
        profileImageView.layer.cornerRadius = radius
        profileImageView.layer.masksToBounds = true
        
        dismiss(animated: true, completion: nil)
    }

    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                print("return image")
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    func resize(image: UIImage) -> UIImage {
        let resizeImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 240, height: 240))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
