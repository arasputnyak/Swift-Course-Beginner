//
//  AddFlightController.swift
//  Lesson5Task
//
//  Created by Анастасия Распутняк on 17.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit
import CoreData

class AddFlightController: UIViewController {
    
    @IBOutlet weak var airlineField: UITextField!
    @IBOutlet weak var flightNumberField: UITextField!
    @IBOutlet weak var airlinePicker: UIPickerView!
    
    @IBOutlet weak var airlinePickerBottomConstraint: NSLayoutConstraint!
    
    let context = CoreDataManager.instance.persistentContainer.viewContext
    var airlines : [Airline]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Add flight"
        
        airlineField.delegate = self
        airlineField.inputView = airlinePicker
        flightNumberField.delegate = self
        setupToHideKeyboardOnTapOnView()
        
        airlinePicker.dataSource = self
        airlinePicker.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        airlines = getPickerData()
        airlinePicker.reloadAllComponents()
    }
    
    // MARK: - Actions -
    
    @IBAction func actionAdd(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let optionsVC = storyboard.instantiateViewController(
            withIdentifier: "AddAirlineNavigController")
        
        optionsVC.modalPresentationStyle = .popover
        
        optionsVC.popoverPresentationController?.sourceView = sender
        
        self.present(optionsVC, animated: true) {}
    }
    
    @IBAction func actionCreate(_ sender: UIButton) {
        if airlineField.text == "" || flightNumberField.text == "" {
            simpleAlert(self)
            return
        }
        
        let newFlight = NSEntityDescription.entity(forEntityName: String(describing: Flight.self), in: context)
        if let newFlightEntity = NSManagedObject(entity: newFlight!, insertInto: context) as? Flight {
            let chosenAirline = airlines[airlinePicker.selectedRow(inComponent: 0)]
            
            newFlightEntity.airline = chosenAirline
            newFlightEntity.number = chosenAirline.code! + "-" + (flightNumberField.text ?? "")
        }
        
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

}


extension AddFlightController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == airlineField {
            airlinePicker.isHidden ? showPicker() : hidePicker()
            return false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == flightNumberField {
            let numbers = CharacterSet.decimalDigits
            let validation = numbers.inverted
            
            let blocks = string.components(separatedBy: validation)
            if blocks.count > 1 {
                return false
            }
        }
        
        return true
    }
}


extension AddFlightController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return airlines.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return airlines[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        airlineField.text = airlines[row].name
        hidePicker()
    }
    
}

extension AddFlightController {
    func getPickerData() -> [Airline] {
        var airlines = [Airline]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Airline.self))
        
        
        do {
            let result = try context.fetch(request)
            
            for item in result {
                if let airline = item as? Airline {
                    airlines.append(airline)
                }
            }
            
        } catch {
            print("Failed")
        }
        
        return airlines
    }
    
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(AddFlightController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func showPicker() {
        
        airlinePickerBottomConstraint.constant = airlinePicker.frame.height
        
        airlinePicker.isHidden = false
        airlinePicker.superview?.layoutIfNeeded()
        
        self.airlinePickerBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.airlinePicker.superview?.layoutIfNeeded()
        }
    }
    
    func hidePicker() {
        
        self.airlinePickerBottomConstraint.constant = self.airlinePicker.frame.height
        UIView.animate(withDuration: 0.5, animations: {
            self.airlinePicker.superview?.layoutIfNeeded()
        }) { finished in
            self.airlinePicker.isHidden = true
        }
    }
}

