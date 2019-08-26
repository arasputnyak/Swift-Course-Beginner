//
//  Helper.swift
//  Lesson5Task
//
//  Created by Анастасия Распутняк on 17.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation
import UIKit

func simpleAlert(_ sender: UIViewController) {
    let alert = UIAlertController(title: "Error!", message: "All fields are requiered!", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    sender.present(alert, animated: true)
}
