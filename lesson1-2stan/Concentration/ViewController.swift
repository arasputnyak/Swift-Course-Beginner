//
//  ViewController.swift
//  Concentration
//
//  Created by Анастасия Распутняк on 20.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startButton.titleLabel?.font = UIFont(name: "PartyLetPlain", size: 50)
    }


}

