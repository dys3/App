//
//  NewEventViewController.swift
//  WhereYouAt
//
//  Created by SongYuda on 5/7/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse
import AFNetworking

protocol NewEventViewControllerDelegate: class {
    func afterPost(controller: NewEventViewController)
}

class NewEventViewController: UIViewController, LocationsViewControllerDelegate, addAttendeesViewControllerDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    weak var delegate : NewEventViewControllerDelegate!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var descriptionTextField: UITextView!
    
    @IBOutlet weak var datePickTextField: UITextField!
    
    @IBOutlet weak var addressLabel: UILabel!

    
    @IBOutlet weak var pinImage: UIImageView!
    
    @IBOutlet weak var timeImage: UIImageView!
    
    var timeChosen = false
    
    var addedAttendees : [PFObject]? = []
    var pickedImage : UIImage!
    var date: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        
        datePicker.addTarget(self , action: #selector(NewEventViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        datePickTextField.inputView = datePicker

        // Do any additional setup after loading the view.
    }
    
    var langitude: NSNumber!
    var longitude: NSNumber!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onTapChooseLocation(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "addLocation" , sender: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocation" {
        let locationsViewController = segue.destination as! LocationsViewController
        locationsViewController.delegate = self
        }
        
        if segue.identifier == "addAttendees" {
            let addVC = segue.destination as! addAttendeesViewController
            addVC.delegate = self
        }
    }
    
    @IBAction func onClickChooseUser(_ sender: Any) {
        
        self.performSegue(withIdentifier: "addAttendees", sender: nil)
    }
    
    func locationsPickedLocation(controller: LocationsViewController, address: String, lat: NSNumber, lng: NSNumber) {
        addressLabel.text = address
        pinImage.image = #imageLiteral(resourceName: "iconmonstr-location-1-240-blue")
        langitude = lat
        longitude = lng
    }
    
    func pickedUser(controller: addAttendeesViewController, user: PFObject) {
        
        print(user.description)
        var username : [String]? = []
        addedAttendees!.append(user)
        for addedAttendee in addedAttendees! {
                username?.append(addedAttendee["username"] as! String)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("back")
        
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.pickedImage = resize(image: editedImage)
        
        eventImage.image = self.pickedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapChooseImage(_ sender: UITapGestureRecognizer) {
        
        print("touched")
        let vc = UIImagePickerController()
            
        vc.delegate = self
        vc.allowsEditing = true
            
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
        } else {
            vc.sourceType = .photoLibrary
        }
            
        self.present(vc, animated: true, completion: nil)
    }
    
  
    @IBAction func onClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickedPost(_ sender: Any) {
        let event = PFObject(className: "Event")
        if let username = PFUser.current()?["username"]{
            event["author"] = username
        }
        else {
            print("no username")
        }
        
        event["location"] = self.addressLabel.text
        
        if let id = PFUser.current()?.objectId {
            event.add(id, forKey: "attendees")
        }
        else {
            print("no user id")
        }
        
        if let description = self.descriptionTextField.text {
            event["description"] = description
        }
        else {
            event["description"] = " "
        }
        
        if let date = date {
            event["event_time"] = date
        }
        
        if let name = self.nameTextField.text {
            event["name"] = name
        }
        
        if let lat = self.langitude {
            event["latitude"] = lat
        }
        
        if let lng = self.longitude {
            event["longitude"] = lng
        }

        if let image = self.pickedImage {
            event["imageFile"] = getPFFileFromImage(image: image)
        }
        
        if let attendees = self.addedAttendees {
            for attendee in attendees {
                event.add(attendee.objectId!, forKey: "attendees")
            }
        }
        
        event.saveInBackground { (success, error) in
            if success {
                print("saved")
                self.delegate.afterPost(controller: self)
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print(error?.localizedDescription)
            }
        }
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
        let resizeImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 80))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss"
        self.datePickTextField.text = dateFormatter.string(from: sender.date)
        self.date = sender.date
        timeChosen = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        if(timeChosen) {
            timeImage.image = #imageLiteral(resourceName: "iconmonstr-time-1-240-blue")       }
    }

}
