//
//  Flight+CoreDataProperties.swift
//  Lesson5Task
//
//  Created by Анастасия Распутняк on 17.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//
//

import Foundation
import CoreData


extension Flight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flight> {
        return NSFetchRequest<Flight>(entityName: "Flight")
    }

    @NSManaged public var number: String?
    @NSManaged public var airline: Airline?

}
