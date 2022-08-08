# Booky Demo App

![alt text](https://i.imgur.com/j6bylg7.png)

### ℹ️ ABOUT

**Booky** is a work-in-progress, heavily-commented demo app built to explore Apple's new '[**App Intents**](https://developer.apple.com/documentation/appintents/app-intents)' framework introduced in iOS 16.

This API lets you extend actions from your app into other areas of the OS - for example the Shortcuts app and Siri.

Functionally, Booky is a basic library you can add books to and mark them as read or unread. It's runnable code that is conceptually and structurally similar to the examples provided in WWDC22's ['Dive Into App Intents'](https://developer.apple.com/videos/play/wwdc2022/10032) session. 

Technically, Booky is built using SwiftUI and persists saved books to a local CoreData store. It has only been tested on iPhone but the code should run on iPad (though the UI hasn't been optimised for it yet).

When you first open the app, three dummy books will be added to the library for testing. Please note that the functionality is extremely bare bones. Testing, error handling and localization are all currently absent. Hopefully, however, it'll be a useful playground to help explore some of what the App Intents framework has to offer. 

There are some known issues with the app (see *'Known Issues'* below) - I'll try and iron these out as the betas progress.

Here are some of the things covered by Booky:

* 5x Shortcut actions
* Foreground & background actions
* Conditional parameter summaries
* Rich confirmation prompts
* Dynamic lookup parameters with thumbnails and subtitles
* Custom entity with queryable properties 
* Action library categories
* Custom errors
* Snippet results

---

### ⚙️ SHORTCUTS ACTIONS

Booky has five actions (or 'intents') that it provides to the Shortcuts app:

#### ADD BOOK
> Add a new book to the library.
> 
> This action has properties of various types which support different input options, such as per-word keyboard capitalization.  
> 
> It displays a SwiftUI 'Snippet' UI (functionally similar to a Homescreen widget) showing a preview of the new book when it completes successfully.
> 
> It also outputs a rich custom 'Book' entity for use in the next action. 

#### MARK BOOKS AS READ
> Mark multiple books as either read or unread.
> 
> This action has a parameter that accepts an array of a custom Book entities. When tapped, it populates a dynamic, filterable list of Books that display along with images. It is sectioned into a 'read' & 'unread' section using a [DynamicOptionsProvider](https://developer.apple.com/documentation/appintents/dynamicoptionsprovider).
> 
> It also demonstrates how to use an enum to create a fixed multiple-choice parameter.   

#### OPEN BOOK
> Opens the chosen book in the Booky app or navigates to the root library view.
> 
> This action demonstrates how to perform a foreground action in your app from Shortcuts. It opens the app and uses the new programmatic navigation API in SwiftUI to either jump to a specific detail view or clear the navigation stack.
> 
> It uses the Switch/Case API in [ParameterSummary](https://developer.apple.com/documentation/appintents/parametersummary) to display a conditional summary depending on which option is chosen.  

#### DELETE BOOKS
> Deletes the selected books from the library.
> 
> This action demonstrates how to prompt the user with an optional confirmation (containing images in a Snippet) before deleting the books.
> 
> It uses the ParameterSummary's [When/Otherwise](https://developer.apple.com/documentation/appintents/parametersummarywhencondition) API. 

#### FIND BOOKS ⚠️
> New in iOS 16, this action is *automatically* added when you add a custom entity with a query that conforms to EntityPropertyQuery (*Not sure this is actually correct since it currently shows when conforming to EntityStringQuery/EntityQuery too?*). 
> 
> This action allows the user to query Booky's database for Books using combinations of property queries. For example: `Books published after the year 2000 that are unread`.

---

### ✅ REQUIREMENTS
The [iOS16](https://developer.apple.com/download/) & [Xcode 14](https://developer.apple.com/download/applications/) betas.

If Booky's shortcut actions aren't showing in the Shortcuts app, make sure `xcode-select` is pointing to the correct Xcode, as per the [Xcode release notes](https://developer.apple.com/documentation/Xcode-Release-Notes/xcode-14-release-notes) for Dev Beta 1

![alt text](https://i.imgur.com/pT3TUP5.png)

---

### ⚠️ KNOWN ISSUES (*as of dev beta 4*)
* The **'Find Books'** action isn't working yet.
* As of dev beta 3, Shortcuts won't show in the Shortcuts app when building as `Release` rather than `Debug` (TestFlight etc). A workaround for this is to explicitly mark all App Intents as `Public`. This is noted under the 'Swift' section of the release notes  
* ~~Adding any code comments to the App Intent's `parameterSummary` method causes the summary not to render in Shortcuts~~
* ~~Input options seem to have no effect - for example the Title & Author parameters in the Add Book action should be capitalized by word (FB10200372)~~
* ~~The text colour in a Snippet view doesn't show the correct (lighter) colour in dark mode (FB10209882)~~
* ~~The **Delete Books** parameter sumary doesn't show correctly, instead showing as if none has been set. I believe this is an issue with `ParameterSummary`'s When/Otherwise API (FB10208191)~~
* ~~Long-pressing a File parameter in the list UI (as opposed to the parameter summary) has no effect, which makes it impossible to select a magic variable (FB10191345)~~
* ~~The **Book** entity display name is not showing correctly (FB10210421)~~
* ~~When tapping on an action's parameter that accepts a custom `ShortcutsBookEntity`, the filtering isn't working. The `entities(matching String)` never seems to get called. (FB10213109)~~

---

### 🎓 STILL TO EXPLORE
* Booky currently uses singletons for CoreData access and ViewModel changes but [it seems](https://twitter.com/mgorbach/status/1534359435916632065?s=21&t=WaiYbv7j0G3ZaDuetIImCw) the better way to access the app's state in the App Intent's 'perform' method is by using dependency injection with [IntentDependency](https://developer.apple.com/documentation/appintents/intentdependency) & [IntentDependencyManager](https://developer.apple.com/documentation/appintents/intentdependencymanager)
* [PredictableIntent protocol](https://twitter.com/mgorbach/status/1534361073213657089?s=21&t=WaiYbv7j0G3ZaDuetIImCw)
* [App Shortcuts](https://developer.apple.com/wwdc22/10170) - Shortcuts containing a single action that are automatically added by the developer to the Shortcuts app
* [Customising donated intents](https://twitter.com/mgorbach/status/1534360425269080064?s=21&t=WaiYbv7j0G3ZaDuetIImCw) based on user behaviour & specific sets of parameters
* [Intent discovery](https://developer.apple.com/documentation/appintents/intent-discovery) documentation
* [Focus Filters](https://developer.apple.com/wwdc22/10121)
* [Resolvers](https://developer.apple.com/documentation/appintents/resolvers)
* Live Activity Snippets
* Siri dialog improvements (for example for errors)
* Localization
* [Matching legacy SiriKit intents to prevent duplicates](https://twitter.com/mgorbach/status/1534361485190651904?s=21&t=WaiYbv7j0G3ZaDuetIImCw)

---

### 📚 FURTHER READING
* **WWDC SESSIONS**
    * 2022
        * ['Dive Into App Intents' (WWDC22)](https://developer.apple.com/videos/play/wwdc2022/10032)
        * ['Design App Shortcuts' (WWDC22)](https://developer.apple.com/wwdc22/10169)
        * ['Implement App Shortcuts With App Intents' (WWDC22)](https://developer.apple.com/wwdc22/10170)
        * ['Meet Focus Filters' (WWDC22)'](https://developer.apple.com/wwdc22/10121)
    * 2021
        * ['Design Great Actions For Shortcuts, Siri & Suggestions' (WWDC21)](https://developer.apple.com/wwdc21/10283)
* **DOCUMENTATION**
    * [App Intents documentation](https://developer.apple.com/documentation/appintents)
    * [Siri/Shortcuts HIG](https://developer.apple.com/design/human-interface-guidelines/technologies/siri/introduction/)
* **SAMPLE CODE**
    * Apple's [Food Truck](https://developer.apple.com/documentation/swiftui/food_truck_building_a_swiftui_multiplatform_app/) example app. This cross-platform app includes one basic intent that displays a chart in a Snippet. It also implements App Shortcuts.
* **RELEASE NOTES**
    * [iOS & iPadOS 16 Beta Release Notes](https://developer.apple.com/documentation/ios-ipados-release-notes/ios-ipados-16-release-notes)
    * [Xcode 14 Beta Release Notes](https://developer.apple.com/documentation/Xcode-Release-Notes/xcode-14-release-notes)

---

### 📨 CONTACT
Questions, code contributions & contructive feedback welcome. I don't have a clue what I'm doing. 

You can find me on Twitter: [@mralexhay](https://www.twitter.com/mralexhay).
