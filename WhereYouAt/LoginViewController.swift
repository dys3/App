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
import CoreLocation
import MapKit

class LoginViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var currentLongitude: CLLocationDegrees!
    var currentLatitude: CLLocationDegrees!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
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
            
            //self.scrollView.setContentOffset(CGPoint(x: 0,y: keyboardFrame.size.height/2) , animated: true)
            
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
                
                //let currentUser = PFUser.current()
                print(user!["longitude"])
                user!.setObject(self.currentLongitude, forKey: "longitude")
                user!.setObject(self.currentLatitude, forKey: "latitude")
                
                /*user!["longitude"] = self.currentLongitude
                user!["latitude"] = self.currentLatitude
                */
                user!.saveInBackground(block: { (success:Bool, error: Error?) in
                    print("SavedCurrentLocation")
                })

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

    // LocationManager functions for finding current user location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLatitude = location.coordinate.latitude
            currentLongitude = location.coordinate.longitude
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
