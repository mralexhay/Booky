//
//  BookshelfView.swift
//  Booky
//
//  Created by Alex Hay on 13/06/2022.
//

import SwiftUI

struct BookshelfView: View {
    
    var images: [UIImage]
    
    var body: some View {
        HStack {
            ForEach(images.prefix(4), id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 120)
                    .cornerRadius(8)
            }
            Spacer()
        }
        .padding([.leading, .top, .bottom])
    }
}
