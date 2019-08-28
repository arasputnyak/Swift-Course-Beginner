//
//  User+CoreDataProperties.swift
//  Concentration
//
//  Created by Анастасия Распутняк on 24.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var photo: NSData?
    @NSManaged public var results: NSSet?

}

// MARK: Generated accessors for results
extension User {

    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: Result)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: Result)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSSet)

}
