//
//  Exercise.swift
//  FactoryMethod
//
//  Created by Анастасия Распутняк on 12.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation


protocol Exercise {
    var name: String { get }
    var type: String { get }
    
    func start()
    func stop()
}
