//
//  Airline+CoreDataProperties.swift
//  Lesson5Task
//
//  Created by Анастасия Распутняк on 17.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//
//

import Foundation
import CoreData


extension Airline {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Airline> {
        return NSFetchRequest<Airline>(entityName: "Airline")
    }

    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var flights: NSSet?

}

// MARK: Generated accessors for flights
extension Airline {

    @objc(addFlightsObject:)
    @NSManaged public func addToFlights(_ value: Flight)

    @objc(removeFlightsObject:)
    @NSManaged public func removeFromFlights(_ value: Flight)

    @objc(addFlights:)
    @NSManaged public func addToFlights(_ values: NSSet)

    @objc(removeFlights:)
    @NSManaged public func removeFromFlights(_ values: NSSet)

}
