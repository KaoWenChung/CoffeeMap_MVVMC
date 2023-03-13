//
//  GetPlaceResultDTO_Stub.swift
//  CoffeeMapTests
//
//  Created by wyn on 2023/3/13.
//

@testable import CoffeeMap

extension GetPlaceResultDTO {
    static func stub(name: String = "Mock name",
                     address: String? = nil,
                     distance: Int? = nil) -> Self {
        GetPlaceResultDTO(categories: nil,
                          distance: distance,
                          fsqId: nil,
                          description: nil,
                          geocodes: nil,
                          location: GetPlaceLocationDTO(address: nil,
                                                        adminRegion: nil,
                                                        country: nil,
                                                        crossStreet: nil,
                                                        formattedAddress: address,
                                                        locality: nil,
                                                        neighborhood: nil,
                                                        postTown: nil,
                                                        postcode: nil,
                                                        region: nil),
                          name: name)
    }
}
