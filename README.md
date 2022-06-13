# Booky Demo App

### ABOUT

**Booky** is a simple, heavily-commented demo app built to demonstrate Apple's new [**'App Intents'**](https://developer.apple.com/documentation/appintents/app-intents) framework introduced in iOS16. 

This API lets you extend actions from your app into other areas of the OS - for example the Shortcuts app and through Siri.

Functionally, Booky is a library you can add books to and mark them as read or unread. It's working code that is conceptually similar to the examples provided in WWDC22's ['Dive Into App Intents'](https://developer.apple.com/videos/play/wwdc2022/10032) session (also see session notes [here](https://www.wwdcnotes.com/notes/wwdc22/10032/)). 

Technically, Booky is built using SwiftUI and persists saved books to a local CoreData store. Please note that functionality is extremely bare bones with testing, error handling & localization entirely absent! The app is simply meant as a way to explore some of what the App Intents framework has to offer. 

There are some known issues with the app (see *'Known Issues'* below) - I'll try and iron these out as the betas progress.

Here are some of the things covered by Booky:

    * 5x Shortcut actions
    * Foreground & background actions
    * Conditional parameter summaries
    * Confirmation prompts
    * Dynamic lookup parameters with thumbnails and subtitles
    * Custom entity with queryable properties 
    * Action library categories
    * SwiftUI Snippets

### SHORTCUTS ACTIONS

Booky has five actions ('intents') that it provides to the Shortcuts app.

#### Add Book
This action lets you add a new book to the library.

It features input properties of various types which support different input options, such as per-word keyboard capitalization.  

It displays a SwiftUI 'Snippet' UI (functionally similar to a Homescreen widget) showing a preview of the new book when it completes successfully.

It also outputs a rich custom 'Book' entity for use in the next action. 

#### Mark Books As Read

#### Open Book

#### Delete Books

#### Find Books



### KNOWN ISSUES

### FURTHER READING
