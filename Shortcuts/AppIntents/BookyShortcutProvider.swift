//
//  BookyShortcutProvider.swift
//  Booky
//
//  Created by Jake Nelson on 18/08/2022.
//

import Foundation
import AppIntents

struct ShortcutsBookProvider: AppShortcutsProvider {
    
    static var shortcutTileColor: ShortcutTileColor = .yellow
    
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: DeleteBook(),
                    phrases: [
                        "Delete \(\.$book) from \(.applicationName)",
                        "Delete the title \(\.$book) from \(.applicationName)",
                        "Delete the book \(\.$book) from \(.applicationName)",
                        // will disambiguate
                        "Delete a book from \(.applicationName)"
                    ]
        )
    }
}

struct DeleteBook: AppIntent {
    
    // Title of the action in the Shortcuts app
    static var title: LocalizedStringResource = "Delete Books"
    // Description of the action in the Shortcuts app
    static var description: IntentDescription = IntentDescription("""
This action will delete the selected book.
""", categoryName: "Editing")
    
    // A dynamic lookup parameter
    @Parameter(title: "Books", description: "The books to be deleted from the library", requestValueDialog: IntentDialog("Which books would you like to delete?"))
    var book: ShortcutsBookEntity?
    
    static var parameterSummary: some ParameterSummary {
        Summary("Immediately delete \(\.$book)")
    }
    
    func perform() async throws -> some ProvidesDialog {
        
        let allBooks: [ShortcutsBookEntity] = try await ShortcutsBookEntity.defaultQuery.suggestedEntities()
        
        var bookToDelete = self.book
        if bookToDelete == nil {
            bookToDelete = try await $book.requestDisambiguation(
                among: allBooks,
                dialog: "Which book do you want to delete?"
            )
        }
        
        guard let finalBookToDelete = bookToDelete else {
            return .result(dialog: "Sorry no book found. Please open the app to check.")
        }
        
        do {
            try BookManager.shared.deleteBook(withId: finalBookToDelete.id)
        } catch let error {
            throw error
        }
        return .result(dialog: ("\(book?.title ?? "") deleted"))
    }
}
