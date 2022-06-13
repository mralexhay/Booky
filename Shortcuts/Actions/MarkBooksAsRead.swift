//
//  MarkBooksAsRead.swift
//  Booky
//
//  Created by Alex Hay on 07/06/2022.
//

import AppIntents

// These will be the options in the Shortcut action to mark the book as read or unread
enum BookStatus: String, AppEnum {
    case read
    case unread

    // This will be displayed as the title of the menu shown when picking from the options
    static var typeDisplayName: LocalizedStringResource = "Status"
    
    // The strings that will be shown for each item in the menu
    static var caseDisplayRepresentations: [BookStatus: DisplayRepresentation] = [
        .read: "Read",
        .unread: "Unread"
    ]
}

struct MarkBooksAsRead: AppIntent {
    
    // Title of the action in the Shortcuts app
    static var title: LocalizedStringResource = "Mark Books As Read"

    // Description of the action in the Shortcuts app
    // Category name allows you to group actions - shown when tapping on an app in the Shortcuts library
    // Search Keywords allow users to match terms not included in the title or description
    static var description: IntentDescription =  IntentDescription("Mark the chosen books in your library as either read or unread.",
                                                                   categoryName: "Editing",
                                                                   searchKeywords: ["complete", "finished"])
    
    // An enum parameter
    @Parameter(title: "Status", requestValueDialog: IntentDialog("How should the books be marked?"))
    var status: BookStatus
    
    // A dynamic lookup parameter that allows multiple selections
    @Parameter(title: "Books", requestValueDialog: IntentDialog("Which books would you like to edit?"))
    var books: [ShortcutsBookEntity]
        
    // How the summary will appear in the shortcut action
    static var parameterSummary: some ParameterSummary {
        Summary("Mark \(\.$books) as \(\.$status)")  // Mark {Harry Potter and The Bible} as {Read}
    }
        
    @MainActor // <-- include if the code needs to be run on the main thread
    func perform() async throws -> some PerformResult {
        
        // Code here is executed when the shortcut action is run
        for book in books {
            try BookManager.shared.markBook(withId: book.id, as: status)
        }
        return .finished
    }
}
