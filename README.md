# CoffeeMap
* Without any third party library.
This is an app for users to use their location to find coffee venues nearby.
Users can find coffee venues information on the table view.
This is a project built with MVVM design pattern and Interface builder.

## Requirement
Users have to provide the location for this app in order to query the coffee venues data

## Instruction
You will need to sign up as a Foursquare developer and create an app in order to use their services. Please see [Foursquare](https://developer.foursquare.com/docs/places-api-getting-started) for more details.<br/>
Please add your Foursquare API Key at
`~/CoffeeMap/CoffeeMap/Repository/BaseRepository.swift`<br/>
Modify property apiKey in class BaseRepository

### Technologies:
- Swift
- MVVM
- Interface builder(.xib)
- Dependency Injection
- Unit tests
- Singleton

### Developing time: 8 hours
- feature design and api testing 30 mins
- system design 30 mins
- feature developing 5 hours
- unit test implementing 2 hours

### To-Do list of features and time I need:
- [x] A map page shows user and coffee venue location - 2 hours
- [ ] Unit test for a map page shows user and coffee venue location - 1 hour
- [ ] Implementing Chain of Responsibility on fetch placemark by coordinate or address - 1 hour
- [ ] Use Foursquare API to get coffee venue photos and show them on the table view cell - 2 hours
