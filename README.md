# CoffeeMap
* Without any third-party library.
This is an app for users to use their location to find coffee venues nearby.
Users can find coffee venue information on the table view.

## Requirement
Users have to provide the location for this app in order to query the coffee venues data

## Instruction
You will need to sign up as a Foursquare developer and create an app in order to use their services. Please see [Foursquare](https://developer.foursquare.com/docs/places-api-getting-started) for more details.<br/>
Please add your Foursquare API Key at
`~/CoffeeMap/CoffeeMap/Application/AppConfiguration.swift`<br/>
Or search by keyword "// TODO: ADD API KEY HERE" in the project. <br/>
Modify the method getAPIKey in the class AppConfiguration

## Features
### UI Implementation
- Implement CafeListView to display a list of cafe venues
- Implement CafeDetailView to present the detail of the cafe venue including images
- Implement CafeMapView to present the route between the user and the cafe venue
### API Data Fetching
- Get cafe list by GET API https://api.foursquare.com/v3/places/search
  - Pagination by the cursor
  - Sort the list by distance or popularity
- Get cafe venues' images by GET API https://api.foursquare.com/v3/places/{fsqId}/photos
### Localized Content
- Used Extension protocol with enumeration to define and use localized strings.
### Test Implementation
- Unit testing
  - Implement dependency injection and mock dependencies to improve the testability of code.
### Image Cache
- Implement image cache by NSCache

### Technologies:
- Swift
- MVVM + Coordinator
- Interface builder(.xib)
- Clean Architecture
- POP (protocol LocallizedStringType)
- OOP
- MapKit
- Concurrency (await async)
- Unit testing
- Observable
- Image Cache (NSCache)
- Dependency Injection
- Adapter pattern (TableViewAdapter)
- Singleton pattern (Spinner)
