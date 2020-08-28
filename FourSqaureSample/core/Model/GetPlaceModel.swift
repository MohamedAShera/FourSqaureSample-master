//
//  GetPlaceModel.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import Foundation

struct GetPlaceModel: Codable {
    let meta: Meta?
    let response: Response?
}
struct Meta: Codable {
    let code: Int?
    let requestID: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case requestID = "requestId"
    }
}

struct Response: Codable {
    let group: Group?
}
struct Group: Codable {
    let results: [Result]?
    let totalResults: Int?
}
struct Result: Codable {
    let venue: Venue?
    let photo: ResultPhoto?
}


struct Venue: Codable {
    let id, name: String?
    let location: Location?
  //  let categories: [Category]?
    let dislike, ok: Bool?
   // let venuePage: VenuePage?
}
struct Location: Codable {
    let address, crossStreet: String?
    let lat, lng: Double?
   // let labeledLatLngs: [LabeledLatLng]?
    let distance: Int?
   // let cc: Cc?
    let city: String?
   // let state: Name?
   // let country: Country?
    let formattedAddress: [String]?
    let postalCode, neighborhood: String?
}
struct ResultPhoto: Codable {
    let id: String?
    let createdAt: Int?
    let photoPrefix: String?
    let suffix: String?
    let width, height: Int?
   // let visibility: Visibility?
    
    enum CodingKeys: String, CodingKey {
        case id, createdAt
        case photoPrefix = "prefix"
        case suffix, width, height
    }
}
