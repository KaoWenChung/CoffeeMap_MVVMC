# CoffeeMap (work in progress)
* Without any third party library.
This is an app for users to use their location to find coffee venues nearby.
Users can find coffee venues information on the table view.
This is a project built with MVVM design pattern and Interface builder.

## Requirement
Users have to provide the location for this app in order to query the coffee venues data

## Instruction
You will need to sign up as a Foursquare developer and create an app in order to use their services. Please see [Foursquare](https://developer.foursquare.com/docs/places-api-getting-started) for more details.<br/>
Please add your Foursquare API Key at
`~/CoffeeMap/CoffeeMap/Application/AppConfiguration.swift`<br/>
Or search by keyword "// TODO: ADD API KEY HERE" in project. <br/>
Modify method getAPIKey in class AppConfiguration

### Technologies:
- Swift
- MVVM
- Interface builder(.xib)
- Clean Architecture
- Concurrency(work in progress)
- Unit testing(work in progress)
- Dependency Injection
- Adapter pattern
- Singleton pattern

### To-Do list of features and time I need:
- [x] A map page shows user and coffee venue location - 2 hours
- [ ] Unit test for a map page shows user and coffee venue location - 1 hour
- [ ] Implementing Chain of Responsibility on fetch placemark by coordinate or address - 1 hour
- [ ] Use Foursquare API to get coffee venue photos and show them on the table view cell - 2 hours
