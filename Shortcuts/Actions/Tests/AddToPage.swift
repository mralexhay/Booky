//
//  AddToPage.swift
//  Booky
//
//  Created by Alex Hay on 12/06/2022.
//

import AppIntents
import SwiftUI

/*
enum InputType: String, AppEnum {
    case text
    case image

    static var typeDisplayName: LocalizedStringResource = "Type"
    static var caseDisplayRepresentations: [InputType: DisplayRepresentation] = [
        .text: "Text",
        .image: "Image"
    ]
}

struct AddToPage: AppIntent {
    static var title: LocalizedStringResource = "Add To Page"
    static var description: IntentDescription =  IntentDescription("Add either text or an image to the page.",
                                                                   categoryName: "Editing Tools",
                                                                   searchKeywords: ["edit", "document"])

    @Parameter(title: "Type")
    var inputType: InputType
    
    @Parameter(title: "Text",
               inputOptions: StringInputOptions(capitalizationType: .words),
               requestValueDialog: IntentDialog("What text would you like to add to the page?"))
    var text: String
    
    @Parameter(title: "Image",
               supportedTypeIdentifiers: ["public.image"],
               requestValueDialog: IntentDialog("Which image would you like to add to the page?"))
    var image: IntentFile

    @Parameter(title: "Include Padding")
    var padding: Bool?

    static var parameterSummary: some ParameterSummary {

        
        Switch(\AddToPage.$inputType) {
            Case(InputType.text) {
                Summary("Add \(\.$text) to page") {
                    \.$padding
                    \.$inputType
                }
            }
            Case(InputType.image) {
                Summary("Add \(\.$image) to page") {
                    \.$padding
                    \.$inputType
                }
            }
            DefaultCase {
                Summary("Add to page") {
                    \.$padding
                    \.$inputType
                }
            }
        }
    }

    func perform() async throws -> some PerformResult {
        // do something
        return .finished
    }
}
*/
