//
//  BookController.swift
//  Booky
//
//  Created by Alex Hay on 07/06/2022.
//

import AppIntents
import CoreData
import UIKit

class BookManager {
    
    static let shared = BookManager()
    
    let context = PersistenceController.shared.container.viewContext
    
    func getAllBooks() -> [BookEntity] {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        do {
            return try context.fetch(request).sorted(by: { $0.title < $1.title })
        } catch let error {
            print("Couldn't fetch all books: \(error.localizedDescription)")
            return []
        }
    }
    
    func addBook(title: String, author: String, datePublished: Date, coverImage: UIImage?, isRead: Bool = false) throws -> BookEntity {
        
        let newBook = BookEntity(context: context)
        newBook.id = UUID()
        newBook.title = title
        newBook.author = author
        newBook.datePublished = datePublished
        newBook.coverImage = coverImage?.jpegData(compressionQuality: 0.75)
        newBook.isRead = isRead
        
        do {
            try saveContext()
            return newBook
        } catch {
            throw Error.addFailed(title: title)
        }
    }
    
    func findBook(withId id: UUID) throws -> BookEntity {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            guard let foundBook = try context.fetch(request).first else {
                throw Error.notFound
            }
            return foundBook
        } catch {
            throw Error.notFound
        }
    }
    
    // Mark a book as read or unread
    func markBook(withId id: UUID, as status: BookStatus) throws {
        do {
            let matchingBook = try Self.shared.findBook(withId: id)
            switch status {
                case .read:
                    matchingBook.isRead = true
                case .unread:
                    matchingBook.isRead = false
            }
            try saveContext()
        } catch let error {
            throw error
        }
    }
     
    func deleteBook(withId id: UUID) throws {
        do {
            let matchingBook = try Self.shared.findBook(withId: id)
            context.delete(matchingBook)
            try saveContext()
        } catch let error {
            print("Couldn't delete book with ID: \(id.uuidString): \(error.localizedDescription)")
            throw Error.deletionFailed
        }
    }
    
    func saveContext() throws {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch let error {
            print("Couldn't save CoreData context: \(error.localizedDescription)")
            throw Error.coreDataSave
        }
    }
    
}

extension BookManager {
    
    // Adds 3 dummy books to the library
    func addDummyBooks(context: NSManagedObjectContext) throws {
        
        let cal = Calendar.current
        
        let hobbit = BookEntity(context: context)
        hobbit.id = UUID()
        hobbit.title = "The Hobbit"
        hobbit.author = "J.R.R. Tolkien"
        hobbit.datePublished = DateComponents(calendar: cal, year: 1937, month: 09, day: 21).date
        hobbit.isRead = true
        hobbit.coverImage = UIImage(named: "hobbit")?.jpegData(compressionQuality: 0.7)
        
        let mocking = BookEntity(context: context)
        mocking.id = UUID()
        mocking.title = "To Kill A Mockingbird"
        mocking.author = "Harper Lee"
        mocking.datePublished = DateComponents(calendar: cal, year: 1960, month: 07, day: 11).date
        mocking.isRead = true
        mocking.coverImage = UIImage(named: "mocking")?.jpegData(compressionQuality: 0.7)
        
        let queen = BookEntity(context: context)
        queen.id = UUID()
        queen.title = "The Queen Of Hearts"
        queen.author = "Kimmery Martin"
        queen.datePublished = DateComponents(calendar: cal, year: 2018, month: 02, day: 15).date
        queen.isRead = false
        queen.coverImage = UIImage(named: "queen")?.jpegData(compressionQuality: 0.7)
        
        do {
            try saveContext()
        } catch let error {
            print("Couldn't add dummy books: \(error.localizedDescription)")
            throw error
        }
    }
    
}
