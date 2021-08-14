//
//  Coasters+CoreDataProperties.swift
//  CoasterCollector
//
//  Created by Mattw on 8/14/21.
//

import Foundation
import CoreData


extension Coasters {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coasters> {
        return NSFetchRequest<Coasters>(entityName: "Coasters")
    }

    @NSManaged public var name: String?
    @NSManaged public var category: String?
    @NSManaged public var id: UUID?
    @NSManaged public var developer: String?
    @NSManaged public var rank: Int64
    @NSManaged public var themePark: ThemePark?
    @NSManaged public var rides: NSSet?

}

// MARK: Generated accessors for rides
extension Coasters {

    @objc(addRidesObject:)
    @NSManaged public func addToRides(_ value: Rides)

    @objc(removeRidesObject:)
    @NSManaged public func removeFromRides(_ value: Rides)

    @objc(addRides:)
    @NSManaged public func addToRides(_ values: NSSet)

    @objc(removeRides:)
    @NSManaged public func removeFromRides(_ values: NSSet)

}

extension Coasters : Identifiable {

}
