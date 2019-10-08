//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Анастасия Распутняк on 03.10.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation

struct EmojiArt : Codable {
    var url : URL?
    var imageData : Data?
    var emojies = [EmojiInfo]()
    
    struct EmojiInfo : Codable {
        let x : Int
        let y : Int
        let text : String
        let size : Int
    }
    
    var json : Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init(url : URL, emojies : [EmojiInfo]) {
        self.url = url
        self.emojies = emojies
    }
    
    init(imageData : Data, emojies : [EmojiInfo]) {
        self.imageData = imageData
        self.emojies = emojies
    }
    
    init?(json : Data) {
        if let newValue = try? JSONDecoder().decode(EmojiArt.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
}
