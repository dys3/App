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
    UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    
    weak var delegate : NewEventViewControllerDelegate!

    @IBOutlet weak var attendeesScrollView: UIScrollView!
    
    @IBOutlet weak var descriptionView: UIView!
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
    var keyboardHeight: CGFloat!
    var viewChangeOffset: CGFloat!
    
    var langitude: NSNumber!
    var longitude: NSNumber!
    
    var images : [UIImage] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        
        datePicker.addTarget(self , action: #selector(NewEventViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        datePickTextField.inputView = datePicker
        descriptionTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)


        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let imageWidth : CGFloat = 30
        let imageHeight : CGFloat = 30
        var xPosition: CGFloat = 8
        var scrollViewContentSize: CGFloat = 0;
        
        print(images)
        
        for image in images {
            
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = UIViewContentMode.scaleToFill
            
            let radius = imageView.frame.width / 2
            imageView.layer.cornerRadius = radius
            imageView.layer.masksToBounds = true
            
            
            imageView.frame.size.width = imageWidth
            imageView.frame.size.height = imageHeight
            imageView.frame.origin.y = 5
            imageView.frame.origin.x = xPosition
            self.attendeesScrollView.addSubview(imageView)
            
            print("added")
            
            xPosition += 38
            scrollViewContentSize += (imageHeight + 8)
            attendeesScrollView.contentSize = CGSize(width: scrollViewContentSize, height: imageHeight)
        
        }
    }


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
        
        self.images = []
        
        for attendee in addedAttendees! {
            if let image = attendee["profilePic"] as? PFFile {
                
                image.getDataInBackground(block: { (imageData, error) in
                    if let imageData = imageData {
                        let image = UIImage(data: imageData)
                        self.images.append(image!)
                        print("append")
                    }
                })
            }
            else {
                let profile = #imageLiteral(resourceName: "iconmonstr-user-1-240")
                images.append(profile)
            }
        }

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("back")
        
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.pickedImage = editedImage
        eventImage.image = self.pickedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapChooseImage(_ sender: UITapGestureRecognizer) {
        
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
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.keyboardHeight = keyboardHeight
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.2) {
            
            self.viewChangeOffset =
            self.keyboardHeight - (self.view.frame.height - self.descriptionView.frame.origin.y - self.descriptionView.frame.height) + 20
            self.view.frame.origin.y -= self.viewChangeOffset
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y += self.viewChangeOffset
        }
    }

}
