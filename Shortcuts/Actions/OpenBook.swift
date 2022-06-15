//
//  OpenBook.swift
//  Booky
//
//  Created by Alex Hay on 07/06/2022.
//

import AppIntents

// These will be the options in the Shortcut action to open a book or navigate to the library
enum NavigationType: String, AppEnum, CaseDisplayRepresentable {
    case library
    case book

    // This will be displayed as the title of the menu shown when picking from the options
    static var typeDisplayName: LocalizedStringResource = "Navigation"
    
    /*
    // The strings that will be shown for each item in the menu
    static var caseDisplayRepresentations: [NavigationType: DisplayRepresentation] = [
        .library: "Library",
        .book: "Book"
    ]
     */
    
    static var caseDisplayRepresentations: [Self:DisplayRepresentation] = [
        .library: DisplayRepresentation(title: "Library", subtitle: "Return to the home page", image: .init(systemName: "books.vertical")),
        .book: DisplayRepresentation(title: "Book", subtitle: "Navigate to a specific book", image: .init(systemName: "book"))
    ]
}

struct OpenBook: AppIntent {
    
    // Title of the action in the Shortcuts app
    static var title: LocalizedStringResource = "Open Book"
    // Description of the action in the Shortcuts app
    static var description: IntentDescription = IntentDescription("This action will open the selected book in the Booky app or navigate to the home library.", categoryName: "Navigation")
    // This opens the host app when the action is run
    static var openAppWhenRun = true
    
    // A dynamic lookup parameter
    @Parameter(title: "Book", requestValueDialog: IntentDialog("Which book would you like to open?"))
    var book: ShortcutsBookEntity
    
    // An enum parameter
    @Parameter(title: "Navigation", default: .book, requestValueDialog: IntentDialog("What would you like to navigate to?"))
    var navigation: NavigationType
    
    // How the summary will appear in the shortcut action.
    static var parameterSummary: some ParameterSummary {
        
        Switch(\OpenBook.$navigation) {
            Case(NavigationType.book) {
                Summary("Open \(\.$navigation) \(\.$book)")
            }
            Case(NavigationType.library) {
                Summary("Open \(\.$navigation)")
            }
            DefaultCase {
                Summary("Open \(\.$navigation) \(\.$book)")
            }
        }
    }

    @MainActor // <-- include if the code needs to be run on the main thread
    func perform() async throws -> some PerformResult {
        do {
            if navigation == .book {
                let matchingBook = try BookManager.shared.findBook(withId: book.id)
                ViewModel.shared.navigateTo(book: matchingBook)
            } else {
                ViewModel.shared.navigateToLibrary()
            }
        return .finished
        } catch let error {
            throw error
        }
    }
}

