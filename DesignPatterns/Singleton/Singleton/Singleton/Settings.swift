//
//  Settings.swift
//  Singleton
//
//  Created by Анастасия Распутняк on 12.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

class Settings {
    // singleton из-за static будет жить до конца приложения
    static let shared = Settings()
    
    var colorStyle = UIColor.white
    var volumeLevel: Float = 1.0
    
    private init() {
        // ?
    }
}
