//
//  DetailView.swift
//  Booky
//
//  Created by Alex Hay on 07/06/2022.
//

import SwiftUI

struct DetailView: View {
    
    var book: BookEntity
    
    var body: some View {
        ScrollView {
            BookView(book: book)
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BookView: View {
    
    var book: BookEntity
    var smallImage: Bool = false
    
    var body: some View {
        if let imageData = book.coverImage, let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(smallImage ? 10 : 0)
                .frame(width: smallImage ? 150 : nil)
        }
        Text("\(book.title)")
            .font(.title)
            .bold()
            .padding(.top)
        Text("by \(book.author)")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .bold()
    }
}
