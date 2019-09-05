//
//  StringExt.swift
//  SwiftEazyTasks
//
//  Created by Анастасия Распутняк on 19.07.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation

extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        get {
            return self[i ..< i + 1]
        }
        
        set {
            if newValue.count == 1 {
                self = self[0 ..< i] + newValue + self[i + 1 ..< self.count]
            }
        }
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        
        get {
            let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                                upper: min(length, max(0, r.upperBound))))
            let start = index(startIndex, offsetBy: range.lowerBound)
            let end = index(start, offsetBy: range.upperBound - range.lowerBound)
            return String(self[start ..< end])
        }
        
        set {
            let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                                upper: min(length, max(0, r.upperBound))))
            let start = index(startIndex, offsetBy: range.lowerBound)
            let end = index(start, offsetBy: range.upperBound - range.lowerBound)
            
            self = self[startIndex ..< start] + newValue + self[end ..< endIndex]
        }
        
    }
    
}
