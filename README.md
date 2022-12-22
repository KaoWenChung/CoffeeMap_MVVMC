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
Modify method getAPIKey in class AppConfiguration

## Features
### UI Implementation
- Implement a list to show cafe venue information
  - select one item from the cafe list will show the map and the route between the user and the cafe venue
- Implement a button to refresh the cafe venue list
### API Data Fetching
- Get cafe list by GET API https://api.foursquare.com/v3/places/search
### Localized Content
- Used Protocol Oriented Programming with enumeration to define and use localized strings.
### Test Implementation
- Unit testing
  - Implement dependency injection and mock dependencies to improve the testability of code.

### Technologies:
- Swift
- MVVM
- Interface builder(.xib)
- Clean Architecture
- POP (protocol LocallizedStringType)
- OOP
- Concurrency
- Unit testing
- Coordinator
- Observable
- Dependency Injection
- Adapter pattern (TableViewAdapter)
- Singleton pattern (Spinner)

### To-Do list of features and time I need:
- [x] A map page shows the user and coffee venue location
- [ ] UI testing
- [ ] Use Foursquare API to get coffee venue photos and show them on the table view cell - 2 hours
