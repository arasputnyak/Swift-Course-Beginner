//
//  Helper.swift
//  Concentration
//
//  Created by Анастасия Распутняк on 22.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation
import UIKit
import CoreData


func createColor(withRed red : Int, green : Int, andBlue blue : Int) -> UIColor {
    return UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
}

func simpleAlert(_ sender: UIViewController, withTitle title : String, andMessage message : String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    sender.present(alert, animated: true)
}

func getUsers(context : NSManagedObjectContext) -> [User] {
    var users = [User]()
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: User.self))
    
    do {
        let result = try context.fetch(request)
        
        for item in result {
            if let user = item as? User {
                users.append(user)
            }
        }
        
    } catch {
        print("Failed")
    }
    
    return users
}

