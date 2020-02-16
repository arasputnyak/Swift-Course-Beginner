//
//  Jumping.swift
//  FactoryMethod
//
//  Created by Анастасия Распутняк on 12.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation

class Jumping: Exercise {
    var name: String = "Прыжки"
    
    var type: String = "Упражнение для ног"
    
    func start() {
        print("Начинаем прыжки")
    }
    
    func stop() {
        print("Заканчиваем прыжки")
    }
}
