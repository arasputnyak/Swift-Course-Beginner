//
//  ViewController.swift
//  MVPTestProject
//
//  Created by Анастасия Распутняк on 11.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var greetingLabel: UILabel!
    
    var presenter: MainViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func actionShowGreeting(_ sender: UIButton) {
        presenter.showGreeting()
    }
}


extension MainViewController: MainViewProtocol {
    func setGreeting(greeting: String) {
        greetingLabel.text = greeting
    }
}

