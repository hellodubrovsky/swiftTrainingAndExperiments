//
//  Task+CoreDataProperties.swift
//  CoreDataExample
//
//  Created by Илья on 15.03.2022.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String?

}

extension Task : Identifiable {

}
