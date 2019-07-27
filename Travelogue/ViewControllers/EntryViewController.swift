//
//  EntryViewController.swift
//  Travelogue
//
//  Created by Felipe Costa on 7/23/19.
//  Copyright © 2019 Felipe Costa. All rights reserved.
//

import UIKit
import MobileCoreServices


class EntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    let imagePicker = UIImagePickerController()
    var entry : Entry?
    var trip : Trip?
    var newMedia: Bool?

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var entryImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let entry = entry{
            titleTextField.text = entry.name
            contentTextView.text = entry.content
            entryImage.image = entry.image ?? nil
        }

    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func titleChanged(_ sender: Any) {
        title = titleTextField.text
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        self.dismiss(animated: true, completion: nil)
        
        if (mediaType.isEqual(to: kUTTypeImage as String)){
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            entryImage.image = image
            if (newMedia == true){
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(EntryViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
            }
            
        }
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer){
        if (error != nil){
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addPhoto(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Photo", message: "Please choose from your camera roll or take a new picture", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertAction.Style.default, handler: {
            (UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.newMedia = false
                return
            }
        }))
        alert.addAction(UIAlertAction(title: "Use Camera", style: UIAlertAction.Style.default, handler: {
            (alertAction) -> Void in
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.newMedia = true
                return
            }
            else{
                let alert = UIAlertController(title: "No Camera", message: "The device has no camera", preferredStyle: UIAlertController.Style.alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveEntry(_ sender: Any) {
        if entry == nil {//new entry
            let title = titleTextField.text ?? ""
            let content = contentTextView.text ?? ""
            let date = Date(timeIntervalSinceNow: 0)
            let picture = entryImage.image
            
            if let entry = Entry(title: title, content: content, date: date, image: picture){
                print("Entry exists")
                if let trip = trip {
                    print("adding entry")
                    trip.addToRawEntries(entry)
                }
                do{
                    try entry.managedObjectContext?.save()
                    self.navigationController?.popViewController(animated: true)
                }catch{
                    print("entry could not be saved")
                }
                print("Entry should be saved")
            }
        }else{//update
            print("updating")
            let title = titleTextField.text ?? ""
            let content = contentTextView.text ?? ""
            let date = Date(timeIntervalSinceNow: 0)
            let picture = entryImage.image
            entry?.update(title: title, content: content, date: date, image: picture)
            do{
                let managedContext = entry?.managedObjectContext
                try managedContext?.save()
            }catch{
                print("The entry could not be saved")
            }
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    

}
