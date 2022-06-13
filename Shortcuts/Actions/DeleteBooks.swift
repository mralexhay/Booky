//
//  DeleteBooks.swift
//  Booky
//
//  Created by Alex Hay on 12/06/2022.
//

import AppIntents

struct DeleteBooks: AppIntent {
    
    // Title of the action in the Shortcuts app
    static var title: LocalizedStringResource = "Delete Books"
    // Description of the action in the Shortcuts app
    static var description: IntentDescription = IntentDescription("""
This action will delete the selected books.

By default you will be prompted for confirmation before the books are deleted from your library.
""", categoryName: "Editing")
    
    // A dynamic lookup parameter
    @Parameter(title: "Books", requestValueDialog: IntentDialog("Which books would you like to delete?"))
    var books: [ShortcutsBookEntity]
    
    @Parameter(title: "Confirm Before Deleting", default: false)
    var confirmBeforeDeleting: Bool
    
    static var parameterSummary: some ParameterSummary {
        
        // ⚠️ ParameterSummaries that use the When/Otherwise conditional don't appear to display properly in the Shortcuts on Dev Beta 1 (FB10208191)
        When(\DeleteBooks.$confirmBeforeDeleting, .equalTo, true, {
            // Delete books WITH confirmation
            Summary("Delete \(\.$books)") {
                \.$confirmBeforeDeleting
            }
        }, otherwise: {
            // Delete books WITHOUT confirmation
            Summary("Immediately delete \(\.$books)") {
                \.$confirmBeforeDeleting
            }
        })
        
    }

    @MainActor // <-- include if the code needs to be run on the main thread
    func perform() async throws -> some PerformResult {
        do {
            
            if confirmBeforeDeleting {
                let bookList = books.map{ "'\($0.title)' by \($0.author)" }
                let formattedList = bookList.formatted(.list(type: .and, width: .short))
                // Here we prompt the user for confirmation before performing the deletion. User cancellation will throw an error
                try await requestConfirmation(output: .finished(dialog: "Are you sure you want to delete \(formattedList)?"))
                for book in books {
                    try BookManager.shared.deleteBook(withId: book.id)
                }
                return .finished
            } else {
                for book in books {
                    try BookManager.shared.deleteBook(withId: book.id)
                }
                return .finished
            }
        } catch let error {
            throw error
        }
    }
}
