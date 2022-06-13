//
//  NewBookView.swift
//  Booky
//
//  Created by Alex Hay on 07/06/2022.
//

import SwiftUI
import CoreData

struct NewBookView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var vm: ViewModel
    
    @State private var title = ""
    @State private var author = ""
    @State private var isRead = false
    @State private var datePublished = Date()
    @State private var image: UIImage? = nil
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title, prompt: Text("Title"))
                TextField("Author", text: $author, prompt: Text("Author"))
                DatePicker("Published", selection: $datePublished, displayedComponents: .date)
                Toggle("Read", isOn: $isRead)
                HStack {
                    Text("Image") 
                    Spacer()
                    Button {
                        vm.showingImagePicker = true
                    } label: {
                        if let image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                        } else {
                            Image(systemName: "photo")
                                .foregroundColor(.secondary)
                        }
                    }

                }
            }
            .textInputAutocapitalization(.words)
            .sheet(isPresented: $vm.showingImagePicker) {
                ImagePicker(image: $image)
            }
            .navigationTitle("New Book")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel, action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                            .bold()
                            .foregroundColor(.red)
                    })
                }
                ToolbarItem {
                    Button(action: {
                        do {
                            _ = try BookManager.shared.addBook(title: title, author: author, datePublished: datePublished, coverImage: image, isRead: isRead)
                            dismiss()
                        } catch let error {
                            print("Couldn't add book: \(error.localizedDescription)")
                        }
                    }, label: {
                        Text("Save")
                            .bold()
                    })
                    .disabled(title == "" || author == "")
                }
            }
        }
    }
}

struct NewBookView_Previews: PreviewProvider {
    static var previews: some View {
        NewBookView()
    }
}
