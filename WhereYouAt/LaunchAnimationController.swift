//
//  LaunchAnimationController.swift
//  WhereYouAt
//
//  Created by Ulric Ye on 5/26/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LaunchAnimationController: UIViewController {
    
    @IBOutlet weak var backgroundLight: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //backgroundLight.center = CGPoint(x: 164, y: 280.5)
        
        backgroundLight.layer.borderWidth = 1
        backgroundLight.layer.masksToBounds = false
        backgroundLight.layer.borderColor = UIColor.white.cgColor
        backgroundLight.layer.cornerRadius = backgroundLight.frame.height/2
        backgroundLight.clipsToBounds = true
        backgroundLight.alpha = 0
        
        UIView.animate(withDuration: 1) {
            self.backgroundLight.alpha = 1
        }
        
        UIView.animate(withDuration: 1.5, animations: {() in
            self.backgroundLight.transform = CGAffineTransform(scaleX: 20.0, y: 20.0)
        }, completion:{(Bool) in
            if PFUser.current() != nil {
                print("There's a user!")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController")
                self.show(vc, sender: vc)
            } else {
                print("There is no user!")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SignInController")
                self.show(vc, sender: vc)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
