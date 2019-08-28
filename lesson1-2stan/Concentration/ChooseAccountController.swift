//
//  ChooseAccountController.swift
//  Concentration
//
//  Created by Анастасия Распутняк on 25.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit
import CoreData

class ChooseAccountController: UIViewController {
    
    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let context = CoreDataManager.instance.persistentContainer.viewContext
    var existingAccounts : [User]!
    var selected : IndexPath?
    var chosenUser : User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        chooseLabel.font = UIFont(name: "PartyLetPlain", size: 50)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        existingAccounts = getUsers(context: context)
    }
    
    @IBAction func actionCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionGo(_ sender: UIBarButtonItem) {
        if chosenUser == nil {
            simpleAlert(self, withTitle: "Error!", andMessage: "You have to choose an account.")
            return
        }
        
        let mainC = self.storyboard?.instantiateViewController(withIdentifier: "MainController") as? MainController
        mainC?.player = chosenUser
        
        self.present(mainC!, animated: true, completion: nil)
    }
}


extension ChooseAccountController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return existingAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "userCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.textColor = UIColor.orange
        cell?.tintColor = UIColor.orange
        cell?.backgroundColor = tableView.backgroundColor
        cell?.textLabel?.text = existingAccounts[indexPath.row].name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if selected != nil {
            let lastCell = tableView.cellForRow(at: selected!)
            lastCell?.accessoryType = .none
        }
        
        let currentCell = tableView.cellForRow(at: indexPath)
        currentCell?.accessoryType = .checkmark
        chosenUser = existingAccounts[indexPath.row]
        selected = indexPath
        
    }
    
}
