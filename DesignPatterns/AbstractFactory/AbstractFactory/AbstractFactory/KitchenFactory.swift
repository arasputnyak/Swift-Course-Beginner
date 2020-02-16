//
//  KitchenFactory.swift
//  AbstractFactory
//
//  Created by Анастасия Распутняк on 13.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation


class KitchenFactory: AbstractFactory {
    func createChair() -> Chair {
        return ChairKitchen()
    }
    
    func createTable() -> Table {
        return TableKitchen()
    }
    
    func createSofa() -> Sofa {
        return SofaKitchen()
    }
}
