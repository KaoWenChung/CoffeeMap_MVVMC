//
//  CafeDetailResponseDTO.swift
//  CoffeeMap
//
//  Created by wyn on 2022/12/23.
//

struct CafeDetailResponseDTO: Decodable {
    let categories: [CafeDetailCategoryDTO]?
    let chains: [String]?
    let fsqId: String?
    let geocodes: CafeDetailGeocodeDTO?
    let link: String?
    let location: CafeDetailLocationDTO?
    let name: String?
    let timezone: String?
    
    enum CodingKeys: String, CodingKey {
        case categories
        case chains
        case fsqId = "fsq_id"
        case geocodes
        case link
        case location
        case name
        case timezone
    }
}

struct CafeDetailLocationDTO: Decodable {
    let address: String?
    let censusBlock: String?
    let country: String?
    let dma: String?
    let formattedAddress: String?
    let locality: String?
    let postcode: String?
    let region: String?
    
    enum CodingKeys: String, CodingKey {
        case address
        case censusBlock = "census_block"
        case country
        case dma
        case formattedAddress = "formatted_address"
        case locality
        case postcode
        case region
    }
}

struct CafeDetailGeocodeDTO: Decodable {
    let main: CafeDetailMainDTO?
    let roof: CafeDetailMainDTO?
    
    enum CodingKeys: String, CodingKey {
        case main
        case roof
    }
}

struct CafeDetailMainDTO: Decodable {
    let latitude: Float?
    let longitude: Float?
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}

struct CafeDetailCategoryDTO: Decodable {
    let icon: CafeDetailIconDTO?
    let id: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case icon
        case id
        case name
    }
}

struct CafeDetailIconDTO: Decodable {
    let prefix: String?
    let suffix: String?
    
    enum CodingKeys: String, CodingKey {
        case prefix
        case suffix
    }
}
