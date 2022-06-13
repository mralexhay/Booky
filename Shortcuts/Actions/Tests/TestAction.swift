//
//  ShowSnippet.swift
//  Booky
//
//  Created by Alex Hay on 11/06/2022.
//

import AppIntents
import SwiftUI

/*
struct TestAction: AppIntent {
    static var title: LocalizedStringResource = "Test Action"
    
    @Parameter(title: "Book Title",
                   optionsProvider: AuthorNamesOptionsProvider())
        var bookTitle: DynamicOptionsResult<String>
    
    private struct AuthorNamesOptionsProvider: DynamicOptionsProvider {
        func results() async throws -> [DynamicOptionsResult<String>] {
            let results = [
                DynamicOptionsResult(promptLabel: "This is a prompt?", usesIndexedCollation: false, sections: [DynamicOptionsSection<_>])
            ]
            return results
        }
    }
    
    /*
    static var parameterSummary: some ParameterSummary {
        Summary("Open \(\.$bookTitle)")
    }
     */

    func perform() async throws -> some PerformResult {
        // Do something
        return .finished
    }    
}

*/
