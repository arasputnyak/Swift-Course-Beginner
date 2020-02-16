//
//  BedroomFactory.swift
//  AbstractFactory
//
//  Created by Анастасия Распутняк on 13.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation


class BedroomFactory: AbstractFactory {
    func createChair() -> Chair {
        return ChairBedroom()
    }
    
    func createTable() -> Table {
        return TableBedroom()
    }
    
    func createSofa() -> Sofa {
        return SofaBedroom()
    }
}
