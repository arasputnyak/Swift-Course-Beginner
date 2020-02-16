//
//  FactoryExercises.swift
//  FactoryMethod
//
//  Created by Анастасия Распутняк on 12.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation

enum Exercises {
    case jumping
    case squarts
}

class FactoryExercises {
    static let defaultFactory = FactoryExercises()
    
    func createExercise(name: Exercises) -> Exercise {
        switch name {
        case .jumping:
            return Jumping()
        case .squarts:
            return Squarts()
        }
    }
}
