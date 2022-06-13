//
//  BookEntity+CoreDataProperties.swift
//  Booky
//
//  Created by Alex Hay on 12/06/2022.
//
//

import Foundation
import CoreData


extension BookEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookEntity> {
        return NSFetchRequest<BookEntity>(entityName: "BookEntity")
    }

    @NSManaged public var author: String
    @NSManaged public var coverImage: Data?
    @NSManaged public var datePublished: Date?
    @NSManaged public var id: UUID
    @NSManaged public var isRead: Bool
    @NSManaged public var title: String

}

extension BookEntity : Identifiable {

}
