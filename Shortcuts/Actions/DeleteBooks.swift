//
//  DeleteBooks.swift
//  Booky
//
//  Created by Alex Hay on 12/06/2022.
//

import AppIntents
import UIKit

struct DeleteBooks: AppIntent {
    
    // Title of the action in the Shortcuts app
    static var title: LocalizedStringResource = "Delete Books"
    // Description of the action in the Shortcuts app
    static var description: IntentDescription = IntentDescription("""
This action will delete the selected books.

By default you will be prompted for confirmation before the books are deleted from your library.
""", categoryName: "Editing")
    
    // A dynamic lookup parameter
    @Parameter(title: "Books", description: "The books to be deleted from the library", requestValueDialog: IntentDialog("Which books would you like to delete?"))
    var books: [ShortcutsBookEntity]
    
    @Parameter(title: "Confirm Before Deleting", description: "If toggled, you will need to confirm the books will be deleted", default: true)
    var confirmBeforeDeleting: Bool
    
    static var parameterSummary: some ParameterSummary {
        When(\DeleteBooks.$confirmBeforeDeleting, .equalTo, true, {
            Summary("Delete \(\.$books)") {
                \.$confirmBeforeDeleting
            }
        }, otherwise: {
            Summary("Immediately delete \(\.$books)") {
                \.$confirmBeforeDeleting
            }
        })
    }

    func perform() async throws -> some IntentResult {
        do {
            if confirmBeforeDeleting {
                let bookList = books.map{ $0.title }
                let formattedList = bookList.formatted(.list(type: .and, width: .short))
                // Here we prompt the user for confirmation before performing the deletion. User cancellation will throw an error
                try await requestConfirmation(result: .result(dialog: "Are you sure you want to delete \(formattedList)?") {
                    // This 'bookshelf' will visually display the first 4 of the books that are being deleted in the prompt
                    BookshelfView(images: books.compactMap {
                        if let imageData = $0.coverImage?.data {
                            return UIImage(data: imageData)
                        } else {
                            return nil
                        }
                    })
                })
                for book in books {
                    try BookManager.shared.deleteBook(withId: book.id)
                }
                return .result(dialog: IntentDialog(stringLiteral: (books.count == 1) ? "Book deleted" : "\(books.count) books deleted"))
            } else {
                for book in books {
                    try BookManager.shared.deleteBook(withId: book.id)
                }
                return .result(dialog: IntentDialog(stringLiteral: (books.count == 1) ? "Book deleted" : "\(books.count) books deleted"))
            }
        } catch let error {
            throw error
        }
    }
}
