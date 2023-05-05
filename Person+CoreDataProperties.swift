//
//  Person+CoreDataProperties.swift
//  CDApp
//
//  Created by Виталик Молоков on 12.04.2023.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var gender: String?
    @NSManaged public var image: Data?
}

extension Person : Identifiable {

}
