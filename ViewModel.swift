//
//  ViewModel.swift
//  Booky
//
//  Created by Alex Hay on 12/06/2022.
//

import SwiftUI

class ViewModel: ObservableObject  {
    
    static let shared = ViewModel()
    
    @Published var path: [BookEntity] = []
    @Published var showingAddNewBook = false
    @Published var showingImagePicker = false
    
    // Opens a specific Book detail view
    func navigateTo(book: BookEntity) {
        path = [book]
    }
    
    // Clears the navigation stack and returns home
    func navigateToLibrary() {
        path = []
    }
}
