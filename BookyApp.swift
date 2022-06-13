//
//  BookyApp.swift
//
//  Created by Alex Hay on 07/06/2022.
//

import SwiftUI

@main
struct BookyApp: App {
    
    @AppStorage("isFirstRun") var isFirstRun = true
    @StateObject var viewModel = ViewModel.shared
    let context = PersistenceController.shared.container.viewContext
    
    var body: some Scene {
        WindowGroup {
            ListView()
                .environment(\.managedObjectContext, context)
                .environmentObject(viewModel)
                .onAppear {
                    if isFirstRun {
                        // Adds 3 dummy books to the library on first run
                        do {
                            try BookManager.shared.addDummyBooks(context: context)
                            isFirstRun = false
                        } catch {
                            print("Dummy books weren't added")
                        }
                    }
                }
        }
    }
    
}
