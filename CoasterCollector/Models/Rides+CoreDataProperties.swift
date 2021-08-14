//
//  Rides+CoreDataProperties.swift
//  CoasterCollector
//
//  Created by Mattw on 8/14/21.
//

import Foundation
import CoreData


extension Rides {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rides> {
        return NSFetchRequest<Rides>(entityName: "Rides")
    }

    @NSManaged public var date: Date?
    @NSManaged public var park: NSSet?
    @NSManaged public var ride: NSSet?

}

// MARK: Generated accessors for park
extension Rides {

    @objc(addParkObject:)
    @NSManaged public func addToPark(_ value: ThemePark)

    @objc(removeParkObject:)
    @NSManaged public func removeFromPark(_ value: ThemePark)

    @objc(addPark:)
    @NSManaged public func addToPark(_ values: NSSet)

    @objc(removePark:)
    @NSManaged public func removeFromPark(_ values: NSSet)

}

// MARK: Generated accessors for ride
extension Rides {

    @objc(addRideObject:)
    @NSManaged public func addToRide(_ value: Coasters)

    @objc(removeRideObject:)
    @NSManaged public func removeFromRide(_ value: Coasters)

    @objc(addRide:)
    @NSManaged public func addToRide(_ values: NSSet)

    @objc(removeRide:)
    @NSManaged public func removeFromRide(_ values: NSSet)

}

extension Rides : Identifiable {

}
