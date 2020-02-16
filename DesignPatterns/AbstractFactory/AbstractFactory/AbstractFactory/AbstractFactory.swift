//
//  AbstractFactory.swift
//  AbstractFactory
//
//  Created by Анастасия Распутняк on 13.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation


protocol AbstractFactory {
    func createChair() -> Chair
    func createTable() -> Table
    func createSofa() -> Sofa
}
