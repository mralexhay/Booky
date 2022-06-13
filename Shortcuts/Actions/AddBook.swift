//
//  ShowBook.swift
//  Booky
//
//  Created by Alex Hay on 10/06/2022.
//

import AppIntents
import SwiftUI

struct AddBook: AppIntent {
    
    // The name of the action in Shortcuts
    static var title: LocalizedStringResource = "Add Book"
    
    // Description of the action in Shortcuts
    // Category name allows you to group actions - shown when tapping on an app in the Shortcuts library
    static var description: IntentDescription = IntentDescription(
"""
Add a new book to your collection.

A preview of the new book is optionally shown as a Snippet after the action has run.
""", categoryName: "Editing")

    // String input options allow you to set the keyboard type, capitalization and more
    @Parameter(title: "Title", inputOptions: StringInputOptions(capitalizationType: .words), requestValueDialog: IntentDialog("What is the title of the book?"))
    var title: String

    @Parameter(title: "Author", inputOptions: StringInputOptions(capitalizationType: .words), requestValueDialog: IntentDialog("What is the author of the book's name?"))
    var author: String
    
    // Optionally accept an image to set as the book's cover. We can define the types of files that are accepted
    @Parameter(title: "Cover Image", supportedTypeIdentifiers: ["public.image"], requestValueDialog: IntentDialog("What image should be used as the cover of the book?"))
    var coverImage: IntentFile?

    @Parameter(title: "Read", default: false, requestValueDialog: IntentDialog("Have you read the book?"))
    var isRead: Bool
    
    @Parameter(title: "Date Published", requestValueDialog: IntentDialog("What date was the book published?"))
    var datePublished: Date
    
    // How the summary will appear in the shortcut action.
    // More parameters are included below the fold in the trailing closure. In Shortcuts, they are listed in the reverse order they are listed here
    static var parameterSummary: some ParameterSummary {
        Summary("Add \(\.$title) by \(\.$author) with \(\.$coverImage)") {
            \.$datePublished
            \.$isRead
        }
    }

    @MainActor // <-- include if the code needs to be run on the main thread
    func perform() async throws -> some PerformResult {
        
        var image: UIImage? = nil
        if let imageData = coverImage?.data {
            image = UIImage(data: imageData)
        }
        
        do {
            let newBook = try BookManager.shared.addBook(title: title, author: author, datePublished: datePublished, coverImage: image, isRead: isRead)
            
            // Passing a book entity as output from the action. This could be used as input in another action, such at the 'Mark Book As Read' or 'Open Book' actions
            let entity = ShortcutsBookEntity(id: newBook.id, title: newBook.title, author: newBook.author, coverImageData: newBook.coverImage, isRead: newBook.isRead, datePublished: newBook.datePublished)

            return .finished(value: entity) { // <-- we output the 'Book' to be used in the next shortcut action
                
                // Including a trailing closure with a SwiftUI view adds a 'Show When Run' button to the Shortcut action
                // If this is toggled, the view will be shown as a 'Snippet' then the result is output
                // A snippet is an archived SwiftUI View (similar to a medium-size widget)
                // You can use multiple Links() in Snippets which will open in the background
                // Like widgets, you cannot use animated or interactive elements like ScrollViews
                BookView(book: newBook, smallImage: true)
            }
        } catch let error {
            throw error
        }
    }    
}
