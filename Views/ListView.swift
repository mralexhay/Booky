//
//  ContentView.swift
//  Booky
//
//  Created by Alex Hay on 07/06/2022.
//

import SwiftUI
import CoreData

struct ListView: View {
    
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var vm: ViewModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BookEntity.title, ascending: true)],
        animation: .default)
    private var books: FetchedResults<BookEntity>
    
    var body: some View {
        NavigationStack(path: $vm.path) {
            List {
                if books.isEmpty {
                    HStack {
                        Spacer()
                        Button {
                            try? BookManager.shared.addDummyBooks(context: context)
                        } label: {
                            Text("Add Dummy Books")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        Spacer()
                    }
                } else {
                    ForEach(books) { book in
                        NavigationLink(value: book, label: {
                            ListRowView(book: book)
                        })
                    }
                    .onDelete(perform: deleteBooks)
                }
            }
            .navigationDestination(for: BookEntity.self) { book in
                DetailView(book: book)
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem {
                    Button {
                        vm.showingAddNewBook = true
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $vm.showingAddNewBook) {
                NewBookView()
                    .environment(\.managedObjectContext, context)
                    .environmentObject(vm)
            }
        }
    }
    
    private func deleteBooks(offsets: IndexSet) {
        withAnimation {
            offsets.map { books[$0] }.forEach(context.delete)
            do {
                try context.save()
            } catch let error {
                print("Couldn't delete book: \(error.localizedDescription)")
            }
        }
    }
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
