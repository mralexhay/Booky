//
//  StringQueryExample.swift
//  Booky
//
//  Created by Alex Hay on 13/06/2022.
//

import AppIntents

/*
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
    // When the user taps a parameter that accepts Books and types into the search bar at the top, this is where the results are populated from
    func entities(matching query: String) async throws -> [ShortcutsBookEntity] {
        
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
         
    static var properties = EntityQueryProperties {
        Property(keyPath: \ShortcutsBookEntity.title) {
            EqualToComparator { NSPredicate(format: "title = %@", $0) }
            ContainsComparator { NSPredicate(format: "title CONTAINS %@", $0) }
        }
        Property(keyPath: \ShortcutsBookEntity.author) {
            EqualToComparator { NSPredicate(format: "author = %@", $0) }
            ContainsComparator { NSPredicate(format: "author CONTAINS %@", $0) }
        }
        Property(keyPath: \ShortcutsBookEntity.datePublished) {
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
        // Return matching books
        return []
    }
}
*/

// Database.shared.findBooks(matching: comparators, matchAll: mode == .and, sorts: sortedBy.map { (keyPath: $0.by, ascending: $0.order == .ascending) })


/*
 Property(keyPath: \ShortcutsBookEntity.isRead) {
     EqualToComparator { NSPredicate(format: "isRead == %@", NSNumber(booleanLiteral: $0)) }
     NotEqualToComparator { NSPredicate(format: "isRead == %@", NSNumber(booleanLiteral: !$0)) }
 }
 */
