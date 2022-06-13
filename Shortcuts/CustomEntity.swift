import AppIntents

struct ShortcutsBookEntity: Identifiable, AppEntity {
    var id: UUID
    
    @Property(title: "Title")
    var title: String
    
    @Property(title: "Author")
    var author: String
    
    @Property(title: "Cover Image")
    var coverImage: IntentFile?
    
    @Property(title: "Is Read")
    var isRead: Bool
    
    @Property(title: "Date Published")
    var datePublished: Date
    
    init(id: UUID, title: String?, author: String?, coverImageData: Data?, isRead: Bool, datePublished: Date?) {
        
        let bookTitle = title ?? "Unknown Title"
        let bookAuthor = author ?? "Unknown Author"
        
        self.id = id
        self.title = bookTitle
        self.author = bookAuthor
        if let coverImageData {
            self.coverImage = IntentFile(data: coverImageData, filename: "\(bookTitle) by \(bookAuthor).jpg")
        }
        self.isRead = isRead
        self.datePublished = datePublished ?? Date()
    }
    
    static var typeDisplayName: LocalizedStringResource = "Book"
    static var defaultQuery = IntentsBookQuery()
    
    // Requires the full LocalizedStringResource initializer in Dev Beta 1
    // https://developer.apple.com/documentation/ios-ipados-release-notes/ios-ipados-16-release-notes
    var displayRepresentation: DisplayRepresentation {
        if let coverImage {
            // Use the cover image as a thumbnail in UI lists if it has one
            return DisplayRepresentation(
                title: LocalizedStringResource(stringLiteral: "\(title)"),
                subtitle: LocalizedStringResource(stringLiteral: "\(author)"),
                image: .init(data: coverImage.data)
            )
        } else {
            // If the book doesn't have a cover image, use a generic SF Symbol instead
            return DisplayRepresentation(
                title: LocalizedStringResource(stringLiteral: "\(title)"),
                subtitle: LocalizedStringResource(stringLiteral: "\(author)"),
                image: .init(systemName: "book.closed")
            )
        }
    }
}

struct IntentsBookQuery: EntityStringQuery {
    
    func entities(for identifiers: [UUID]) async throws -> [ShortcutsBookEntity] {
        return identifiers.compactMap { identifier in
                if let match = try? BookManager.shared.findBook(withId: identifier) {
                    return ShortcutsBookEntity(
                        id: match.id,
                        title: match.title,
                        author: match.author,
                        coverImageData: match.coverImage,
                        isRead: match.isRead,
                        datePublished: match.datePublished)
                } else {
                    return nil
                }
        }
    }

    // I can't get this func to be called
    func entities(matching query: String) async throws -> [ShortcutsBookEntity] {
        
        let allBooks = BookManager.shared.getAllBooks()
        let matchingBooks = allBooks.filter {
            return $0.title.localizedCaseInsensitiveContains(query) || $0.author.localizedCaseInsensitiveContains(query)
        }

        return matchingBooks.map {
            ShortcutsBookEntity(
                id: $0.id,
                title: $0.title,
                author: $0.author,
                coverImageData: $0.coverImage,
                isRead: $0.isRead,
                datePublished: $0.datePublished)
        }
    }
     
    func suggestedEntities() async throws -> [ShortcutsBookEntity] {
        let allBooks = BookManager.shared.getAllBooks()
        return allBooks.map {
            ShortcutsBookEntity(
                id: $0.id,
                title: $0.title,
                author: $0.author,
                coverImageData: $0.coverImage,
                isRead: $0.isRead,
                datePublished: $0.datePublished)
        }
    }
}
