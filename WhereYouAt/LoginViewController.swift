//
//  LoginViewController.swift
//  WhereYouAt
//
//  Created by Richard Du on 4/26/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        scrollView.bounces = false
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (Notification) in
            print("hide keyboard")
            
            let contentInset:UIEdgeInsets = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInset
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (Notification) in
            print("show keyboard")
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(_ sender: AnyObject) {
        
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.backgroundView.color = UIColor.darkGray
        progressHUD.bezelView.color = UIColor.white
        progressHUD.backgroundView.alpha = 0.5
        progressHUD.backgroundView.isUserInteractionEnabled = false
        progressHUD.label.text = "Authenticating"
        self.view.endEditing(true)
        PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { (user: PFUser?, error:Error?) in
            progressHUD.hide(animated: true)
            progressHUD.backgroundView.isUserInteractionEnabled = true

            if user != nil {
                print("You're logged in")
                
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                let alertController = UIAlertController(title: "Access Denied", message: error!.localizedDescription, preferredStyle: .alert)
                
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // handle response here.
                }
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
            }
        }
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
