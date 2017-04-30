//
//  NewUserViewController.swift
//  WhereYouAt
//
//  Created by Richard Du on 4/26/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse

class NewUserViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmEmailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var screenNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSignup(_ sender: AnyObject) {
        
        let usernameErrorAlertController = UIAlertController(title: "Error", message: "Username is already taken.", preferredStyle: .alert)
        // create an OK action
        let usernameOKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        usernameErrorAlertController.addAction(usernameOKAction)
 
        let signupAlertController = UIAlertController(title: "Success", message: "", preferredStyle: .alert)
        // create an OK action
        
        let signupOKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        signupAlertController.addAction(signupOKAction)
        
        
        let newUser = PFUser()
        
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        newUser.email = emailTextField.text
        
        newUser.signUpInBackground { (success: Bool, error:Error?) in
            if success {
                print("A new user was created")
                newUser["screen_name"] = self.screenNameTextField.text
                newUser.saveInBackground(block: { (success:Bool, error: Error?) in
                    self.present(signupAlertController, animated: true) {
                        // optional code for what happens after the alert controller has finished presenting
                        // self.presentingViewController?.dismiss(animated: true, completion: nil)
                        self.presentingViewController?.dismiss(animated: true, completion: {
                            
                            let vc = UIApplication.shared.keyWindow?.rootViewController
                            vc?.performSegue(withIdentifier: "loginSegue", sender: nil)
                        })
                        
                    }
                })
                
                
                
            } else {
                
                self.present(usernameErrorAlertController, animated: true) {
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
