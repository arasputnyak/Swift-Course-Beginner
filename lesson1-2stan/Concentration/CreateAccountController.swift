//
//  CreateAccountController.swift
//  Concentration
//
//  Created by Анастасия Распутняк on 23.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit
import CoreData

class CreateAccountController: UIViewController {
    
    @IBOutlet weak var createLabel: UILabel!
    @IBOutlet weak var userPicImageView: UIImageView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    let context = CoreDataManager.instance.persistentContainer.viewContext
    var existingNames : [String]!
    var createdUser : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLabel.font = UIFont(name: "PartyLetPlain", size: 50)
        goButton.titleLabel?.font = UIFont(name: "PartyLetPlain", size: 50)
        
        userNameField.layer.borderColor = createColor(withRed: 255, green: 149, andBlue: 49).cgColor
        userNameField.layer.borderWidth = 1
        userNameField.layer.cornerRadius = 5
        
        userPicImageView.layer.cornerRadius = userPicImageView.bounds.width / 2
        
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionTap))
        userPicImageView.addGestureRecognizer(tapGestureRecognizer)
        
        setupToHideKeyboardOnTapOnView()
        
        existingNames = getNames()
        
    }
    
    @IBAction func actionGo(_ sender: UIButton) {
        if userNameField.text == "" || userNameField.text == nil {
            simpleAlert(self, withTitle: "Error!", andMessage: "You must fill the name-field.")
            return
        }
        
        if existingNames.contains(userNameField.text!) {
            simpleAlert(self, withTitle: "Oops!", andMessage: "Seems like this name already exists :(")
            return
        }
        
        let newUser = NSEntityDescription.entity(forEntityName: String(describing: User.self), in: context)
        if let newUserEntity = NSManagedObject(entity: newUser!, insertInto: context) as? User {
            newUserEntity.name = userNameField.text
            newUserEntity.photo = userPicImageView.image!.pngData() as NSData?
            
            createdUser = newUserEntity
        }
        
        do {
            try context.save()
            let mainC = self.storyboard?.instantiateViewController(withIdentifier: "MainController") as? MainController
            mainC?.player = createdUser
            self.present(mainC!, animated: true)
            print("saved!")
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            createdUser = nil
        }
    }
}


extension CreateAccountController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func actionTap(sender : UIGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.mediaTypes = ["public.image"]
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userPicImageView.image = image
        }
    }
    
}


extension CreateAccountController {
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(CreateAccountController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func getNames() -> [String] {
        var names = [String]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: User.self))
        
        request.propertiesToFetch = ["name"]
        request.resultType = .dictionaryResultType
         
        do {
            let result = try context.fetch(request)
         
            for item in result {
                if let name = item as? [String: String] {
                    names.append(name["name"] ?? "")
                }
            }
        } catch {
            print("Failed")
        }
        
        return names
    }
    
}
