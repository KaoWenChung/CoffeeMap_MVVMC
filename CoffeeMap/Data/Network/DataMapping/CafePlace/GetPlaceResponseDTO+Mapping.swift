//
//  GetPlaceResponseDTO+Mapping.swift
//  CoffeeMap
//
//  Created by wyn on 2022/11/8.
//

struct CafePlaceResponse {
    let cursor: String?
    let response: CafePlaceResponseDTO
}

struct CafePlaceResponseDTO: Decodable {
    let results: [GetPlaceResultDTO]?

    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct GetPlaceResultDTO: Decodable {
    let categories : [GetPlaceCategoryDTO]?
    /// The calculated distance (in meters) from the provided location (i.e. ll + radius OR near OR ne + sw) in the API call. This field will only be returned by the Place Search endpoint.
    let distance: Int?
    /// A unique identifier for a FSQ Place (formerly known as Venue ID).
    let fsqId: String?
    let description: String?
    let geocodes: GetPlaceGeocodeDTO?
    let location: GetPlaceLocationDTO?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case categories
        case distance
        case fsqId = "fsq_id"
        case description
        case geocodes
        case location
        case name
    }
}

extension GetPlaceResultDTO {
    struct GetPlaceCategoryDTO: Decodable {
        let icon: GetPlaceIconDTO?
        let id: Int?
        let name: String?

        enum CodingKeys: String, CodingKey {
            case icon
            case id
            case name
        }
    }

    struct GetPlaceIconDTO: Decodable {
        let prefix : String?
        let suffix : String?

        enum CodingKeys: String, CodingKey {
            case prefix
            case suffix
        }
    }

    struct GetPlaceLocationDTO: Decodable {

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
            case address
            case adminRegion = "admin_region"
            case country
            case crossStreet = "cross_street"
            case formattedAddress = "formatted_address"
            case locality
            case neighborhood
            case postTown = "post_town"
            case postcode
            case region
        }

    }
    struct GetPlaceGeocodeDTO: Decodable {

        let main: GetPlaceCenterDTO?
        let roof: GetPlaceCenterDTO?

        enum CodingKeys: String, CodingKey {
            case main
            case roof
        }

    }

    struct GetPlaceGeoBoundDTO: Decodable {

        let circle: GetPlaceCircleDTO?

        enum CodingKeys: String, CodingKey {
            case circle
        }

    }
    struct GetPlaceCircleDTO: Decodable {

        let center: GetPlaceCenterDTO?
        let radius: Int?

        enum CodingKeys: String, CodingKey {
            case center
            case radius
        }

    }

    struct GetPlaceCenterDTO: Decodable {

        let latitude: Double?
        let longitude: Double?

        enum CodingKeys: String, CodingKey {
            case latitude
            case longitude
        }
    }
}

extension GetPlaceResultDTO {
    func toEntity() -> Cafe {
        Cafe(distance: distance,
             fsqId: fsqId,
             name: name,
             formattedAddress: location?.formattedAddress,
             latitude: geocodes?.main?.latitude,
             longitude: geocodes?.main?.longitude,
             description: description)
    }
}
