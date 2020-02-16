//
//  ViewController.swift
//  AbstractFactory
//
//  Created by Анастасия Распутняк on 13.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var chair: Chair?
    var table: Table?
    var sofa: Sofa?
    
    let bedroomFactory = BedroomFactory()
    let kitchenFactory = KitchenFactory()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func actionOrderBedroom(_ sender: UIButton) {
        chair = bedroomFactory.createChair()
        table = bedroomFactory.createTable()
        sofa = bedroomFactory.createSofa()
        
        showTable()
    }
    
    @IBAction func actionOrderKitchen(_ sender: UIButton) {
        chair = kitchenFactory.createChair()
        table = kitchenFactory.createTable()
        sofa = kitchenFactory.createSofa()
        
        showTable()
    }
    
    func showTable() {
        let tvc = TableViewController()
        
        guard let chair = chair, let table = table, let sofa = sofa else {
            return
        }
        
        let furniture = [
            "\(chair.name) \(chair.type)",
            "\(table.name) \(table.type)",
            "\(sofa.name) \(sofa.type)"
        ]
        
        tvc.furniture = furniture
        navigationController?.pushViewController(tvc, animated: true)
    }
    
}

