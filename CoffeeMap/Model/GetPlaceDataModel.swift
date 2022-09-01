//
//  GetPlaceDataModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

struct GetPlaceParamModel: Encodable {
    var ll: String?
    var radius: Int?
    var query: String?
}


struct GetPlaceResponseModel: Decodable {

    let context: GetPlaceContextModel?
    let results: [GetPlaceResultModel]?

    enum CodingKeys: String, CodingKey {
        case context
        case results = "results"
    }

}

struct GetPlaceResultModel: Decodable {
    /// The calculated distance (in meters) from the provided location (i.e. ll + radius OR near OR ne + sw) in the API call. This field will only be returned by the Place Search endpoint.
    let distance: Int?
    /// A unique identifier for a FSQ Place (formerly known as Venue ID).
    let fsqId: String?
    let geocodes: GetPlaceGeocodeModel?
    let location: GetPlaceLocationModel?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case distance = "distance"
        case fsqId = "fsq_id"
        case geocodes
        case location
        case name = "name"
    }

}

struct GetPlaceLocationModel: Decodable {

    let address: String?
    let adminRegion: String?
    let country: String?
    let crossStreet: String?
    let formattedAddress: String?
    let locality: String?
    let neighborhood: [String]?
    let postTown: String?
    let postcode: String?
    let region: String?

    enum CodingKeys: String, CodingKey {
        case address = "address"
        case adminRegion = "admin_region"
        case country = "country"
        case crossStreet = "cross_street"
        case formattedAddress = "formatted_address"
        case locality = "locality"
        case neighborhood = "neighborhood"
        case postTown = "post_town"
        case postcode = "postcode"
        case region = "region"
    }

}
struct GetPlaceGeocodeModel: Decodable {

    let main: GetPlaceCenterModel?
    let roof: GetPlaceCenterModel?

    enum CodingKeys: String, CodingKey {
        case main
        case roof
    }

}

struct GetPlaceContextModel: Decodable {

    let geoBounds: GetPlaceGeoBoundModel?

    enum CodingKeys: String, CodingKey {
        case geoBounds
    }

}

struct GetPlaceGeoBoundModel: Decodable {

    let circle: GetPlaceCircleModel?

    enum CodingKeys: String, CodingKey {
        case circle
    }

}
struct GetPlaceCircleModel: Decodable {

    let center: GetPlaceCenterModel?
    let radius: Int?

    enum CodingKeys: String, CodingKey {
        case center
        case radius = "radius"
    }

}

struct GetPlaceCenterModel: Decodable {

    let latitude: Double?
    let longitude: Double?

    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }

}

