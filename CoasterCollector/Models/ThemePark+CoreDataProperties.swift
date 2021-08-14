//
//  ThemePark+CoreDataProperties.swift
//  CoasterCollector
//
//  Created by Mattw on 8/14/21.
//

import Foundation
import CoreData


extension ThemePark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ThemePark> {
        return NSFetchRequest<ThemePark>(entityName: "ThemePark")
    }

    @NSManaged public var name: String?
    @NSManaged public var location: String?
    @NSManaged public var coasters: NSSet?
    @NSManaged public var rides: NSSet?

}

// MARK: Generated accessors for coasters
extension ThemePark {

    @objc(addCoastersObject:)
    @NSManaged public func addToCoasters(_ value: Coasters)

    @objc(removeCoastersObject:)
    @NSManaged public func removeFromCoasters(_ value: Coasters)

    @objc(addCoasters:)
    @NSManaged public func addToCoasters(_ values: NSSet)

    @objc(removeCoasters:)
    @NSManaged public func removeFromCoasters(_ values: NSSet)

}

// MARK: Generated accessors for rides
extension ThemePark {

    @objc(addRidesObject:)
    @NSManaged public func addToRides(_ value: Rides)

    @objc(removeRidesObject:)
    @NSManaged public func removeFromRides(_ value: Rides)

    @objc(addRides:)
    @NSManaged public func addToRides(_ values: NSSet)

    @objc(removeRides:)
    @NSManaged public func removeFromRides(_ values: NSSet)

}

extension ThemePark : Identifiable {

}
