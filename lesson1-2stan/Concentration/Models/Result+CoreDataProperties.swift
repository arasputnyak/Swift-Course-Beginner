//
//  Result+CoreDataProperties.swift
//  Concentration
//
//  Created by Анастасия Распутняк on 24.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//
//

import Foundation
import CoreData


extension Result {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Result> {
        return NSFetchRequest<Result>(entityName: "Result")
    }

    @NSManaged public var score: Int32
    @NSManaged public var date: NSDate?
    @NSManaged public var player: User?

}
