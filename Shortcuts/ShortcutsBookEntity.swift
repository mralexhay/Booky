//
//  ShortcutsBookEntity.swift
//  Booky
//
//  Created by Alex Hay on 08/06/2022.
//

import Foundation
import AppIntents
import CoreData

// A structure that defines a book object from Booky in the Shortcuts app
// If you don't want all the query capabilities and want a disposable object you can output from Shortcuts with parameters, use the TransientEntity protocol instead: https://developer.apple.com/documentation/appintents/transiententity
struct ShortcutsBookEntity: Identifiable, Hashable, Equatable, AppEntity {
  
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Book")
    typealias DefaultQueryType = IntentsBookQuery
    static var defaultQuery: IntentsBookQuery = IntentsBookQuery()
    
    var id: UUID
    
    @Property(title: "Title")
    var title: String
    
    @Property(title: "Author")
    var author: String
    
    //@Property(title: "Cover Image")
    var coverImage: IntentFile?
    
    @Property(title: "Is Read")
    var isRead: Bool
    
    @Property(title: "Date Published")
    var datePublished: Date
    
    init(id: UUID, title: String?, author: String?, coverImageData: Data?, isRead: Bool, datePublished: Date?) {
        
        let bookTitle = title ?? "Unknown Title"
        let bookAuthor = author ?? "Unknown Author"
        
        self.id = id
        self.title = bookTitle
        self.author = bookAuthor
        if let coverImageData {
            self.coverImage = IntentFile(data: coverImageData, filename: "\(bookTitle) by \(bookAuthor).jpg")
        }
        self.isRead = isRead
        self.datePublished = datePublished ?? Date()
    }
    
    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(
            title: "\(title)",
            subtitle: "\(author)",
            image: coverImage == nil ? .init(systemName: "book.closed") : .init(data: coverImage!.data)
        )
    }
}

extension ShortcutsBookEntity {
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Equtable conformance
    static func ==(lhs: ShortcutsBookEntity, rhs: ShortcutsBookEntity) -> Bool {
        return lhs.id == rhs.id
    }
    
}


struct IntentsBookQuery: EntityPropertyQuery {

    // Find books by ID
    // For example a user may have chosen a book from a list when tapping on a parameter that accepts Books. The ID of that book is now hardcoded into the Shortcut. When the shortcut is run, the ID will be matched against the database in Booky
    func entities(for identifiers: [UUID]) async throws -> [ShortcutsBookEntity] {
        return identifiers.compactMap { identifier in
                if let match = try? BookManager.shared.findBook(withId: identifier) {
                    return ShortcutsBookEntity(
                        id: match.id,
                        title: match.title,
                        author: match.author,
                        coverImageData: match.coverImage,
                        isRead: match.isRead,
                        datePublished: match.datePublished)
                } else {
                    return nil
                }
        }
    }
    
    // Returns all Books in the Booky database. This is what populates the list when you tap on a parameter that accepts a Book
    func suggestedEntities() async throws -> [ShortcutsBookEntity] {
        let allBooks = BookManager.shared.getAllBooks()
        return allBooks.map {
            ShortcutsBookEntity(
                id: $0.id,
                title: $0.title,
                author: $0.author,
                coverImageData: $0.coverImage,
                isRead: $0.isRead,
                datePublished: $0.datePublished)
        }
    }
    
    // Find books matching the given query.
    func entities(matching query: String) async throws -> [ShortcutsBookEntity] {
        
        // Allows the user to filter the list of Books by title or author when tapping on a param that accepts a 'Book'
        let allBooks = BookManager.shared.getAllBooks()
        let matchingBooks = allBooks.filter {
            return ($0.title.localizedCaseInsensitiveContains(query) || $0.author.localizedCaseInsensitiveContains(query))
        }

        return matchingBooks.map {
            ShortcutsBookEntity(
                id: $0.id,
                title: $0.title,
                author: $0.author,
                coverImageData: $0.coverImage,
                isRead: $0.isRead,
                datePublished: $0.datePublished)
        }
    }
         
    static var properties = EntityQueryProperties<ShortcutsBookEntity, NSPredicate> {
        Property(\ShortcutsBookEntity.$title) {
            EqualToComparator { NSPredicate(format: "title = %@", $0) }
            ContainsComparator { NSPredicate(format: "title CONTAINS %@", $0) }

        }
        Property(\ShortcutsBookEntity.$author) {
            EqualToComparator { NSPredicate(format: "author = %@", $0) }
            ContainsComparator { NSPredicate(format: "author CONTAINS %@", $0) }
        }
        Property(\ShortcutsBookEntity.$datePublished) {
            LessThanComparator { NSPredicate(format: "datePublished < %@", $0 as NSDate) }
            GreaterThanComparator { NSPredicate(format: "datePublished > %@", $0 as NSDate) }
        }
    }
    
    static var sortingOptions = SortingOptions {
        SortableBy(\ShortcutsBookEntity.$title)
        SortableBy(\ShortcutsBookEntity.$author)
        SortableBy(\ShortcutsBookEntity.$datePublished)
    }
    
    func entities(
        matching comparators: [NSPredicate],
        mode: ComparatorMode,
        sortedBy: [Sort<ShortcutsBookEntity>],
        limit: Int?
    ) async throws -> [ShortcutsBookEntity] {
        print("Fetching books")
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        let predicate = NSCompoundPredicate(type: mode == .and ? .and : .or, subpredicates: comparators)
        request.fetchLimit = limit ?? 5
        request.predicate = predicate
//        request.sortDescriptors = sortedBy.map({
//            NSSortDescriptor(key: $0.by, ascending: $0.order == .ascending)
//        })
        let matchingBooks = try context.fetch(request)
        return matchingBooks.map {
            ShortcutsBookEntity(id: $0.id, title: $0.title, author: $0.author, coverImageData: $0.coverImage, isRead: $0.isRead, datePublished: $0.datePublished)
        }
    }
}



/*
// Used if not providing an advanced filtering action?
// Allow Shortcuts to query Booky's database for Books
struct IntentsBookQuery: EntityPropertyQuery {
    
    // Find books by ID
    // For example a user may have chosen a book from a list when tapping on a parameter that accepts Books. The ID of that book is now hardcoded into the Shortcut. When the shortcut is run, the ID will be matched against the database in Booky
    func entities(for identifiers: [UUID]) async throws -> [ShortcutsBookEntity] {
        return identifiers.compactMap { identifier in
                if let match = try? BookManager.shared.findBook(withId: identifier) {
                    return ShortcutsBookEntity(
                        id: match.id,
                        title: match.title,
                        author: match.author,
                        coverImageData: match.coverImage,
                        isRead: match.isRead,
                        datePublished: match.datePublished)
                } else {
                    return nil
                }
        }
    }
    
    // Find books matching the given query.
    // When the user taps a parameter that accepts Books and types into the search bar at the top, this is where the results are populated from
    func entities(matching query: String) async throws -> [ShortcutsBookEntity] {
        print("Finding books containing '\(query)'")
        // Allows the user to filter the list of Books by title or author
        let allBooks = BookManager.shared.getAllBooks()
        let matchingBooks = allBooks.filter {
            return ($0.title.localizedCaseInsensitiveContains(query) || $0.author.localizedCaseInsensitiveContains(query))
        }

        return matchingBooks.map {
            ShortcutsBookEntity(
                id: $0.id,
                title: $0.title,
                author: $0.author,
                coverImageData: $0.coverImage,
                isRead: $0.isRead,
                datePublished: $0.datePublished)
        }
    }
     
    // Returns all Books in the Booky database. This is what populates the list when you tap on a parameter that accepts a Book
    func suggestedEntities() async throws -> [ShortcutsBookEntity] {
        let allBooks = BookManager.shared.getAllBooks()
        return allBooks.map {
            ShortcutsBookEntity(
                id: $0.id,
                title: $0.title,
                author: $0.author,
                coverImageData: $0.coverImage,
                isRead: $0.isRead,
                datePublished: $0.datePublished)
        }
    }
}
 */
