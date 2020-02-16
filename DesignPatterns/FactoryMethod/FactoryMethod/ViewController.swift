//
//  ViewController.swift
//  FactoryMethod
//
//  Created by Анастасия Распутняк on 12.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var exercises = [Exercise]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createExercise(exName: .jumping)
        runExercise()
    }
    
    func createExercise(exName: Exercises) {
        let newEx = FactoryExercises.defaultFactory.createExercise(name: exName)
        exercises.append(newEx)
    }

    func runExercise() {
        for ex in exercises {
            ex.start()
            ex.stop()
        }
    }

}

