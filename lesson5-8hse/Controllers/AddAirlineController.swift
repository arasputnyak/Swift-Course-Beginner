//
//  AddAirlineController.swift
//  Lesson5Task
//
//  Created by Анастасия Распутняк on 17.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit
import CoreData

class AddAirlineController: UIViewController {
    
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let context = CoreDataManager.instance.persistentContainer.viewContext
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        codeField.delegate = self
        nameField.delegate = self
    }
    
    
    // MARK: Actions
    
    @IBAction func actionDone(_ sender: UIBarButtonItem) {
        if codeField.text == "" || nameField.text == "" {
            simpleAlert(self)
            return
        }
        
        let newAirline = NSEntityDescription.entity(forEntityName: String(describing: Airline.self), in: context)
        if let newAirlineEntity = NSManagedObject(entity: newAirline!, insertInto: context) as? Airline {
            newAirlineEntity.code = codeField.text
            newAirlineEntity.name = nameField.text
        }
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
        self.dismiss(animated: true)
    }
    
    @IBAction func actionCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {}
    }
    
    @IBAction func actionCodeChanged(_ sender: UITextField) {
        nameField.text = ""
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
        if sender.text?.count != 2 {
            return
        }
        
        let url = URL(string: "https://aita-amadeus-hack.appspot.com/api/l/airline?code=\(sender.text ?? "")&&format=json")
        
        let task = session.dataTask(with: url!) { data, response, error in
            
            guard let dataResponse = data, error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                
                guard let jsonDict = jsonResponse as? [String: Any] else {
                    return
                }
                
                guard let name = jsonDict["name"] as? String else { return }
                
                OperationQueue.main.addOperation({
                    self.loadingIndicator.stopAnimating()
                    self.nameField.text = name
                })
            } catch let parsingError {
                print("Error", parsingError)
            }
            
        }
        
        task.resume()
    }
    
    
}


extension AddAirlineController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == codeField {
            let letters = CharacterSet.uppercaseLetters
            let validation = letters.inverted
            
            let blocks = string.components(separatedBy: validation)
            if blocks.count > 1 {
                return false
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == codeField {
            nameField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == nameField {
            return false
        }
        
        return true
    }
}
