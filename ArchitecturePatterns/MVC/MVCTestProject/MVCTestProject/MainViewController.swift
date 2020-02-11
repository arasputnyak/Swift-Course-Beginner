//
//  ViewController.swift
//  MVCTestProject
//
//  Created by Анастасия Распутняк on 11.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var greetingLabel: UILabel!
    
    let person = Person(firstName: "Anastasia", lastName: "Voskresenskaya")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func actionShowGreeting(_ sender: UIButton) {
        let greeting = "Hello, \(person.firstName) \(person.lastName)!"
        greetingLabel.text = greeting
    }
    
}

