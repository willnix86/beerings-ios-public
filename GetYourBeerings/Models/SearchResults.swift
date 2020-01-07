//
//  VenueData.swift
//  Get Your Beerings
//
//  Created by Will Nixon on 10/22/19.
//  Copyright © 2019 Will Nixon. All rights reserved.
//

import Foundation

struct VenueReponse: Codable {
  let meta: Meta
  let response: Response
}

struct Meta: Codable {
  let code: Int
  let requestId: String
}

struct Response: Codable {
  let venues: [VenueData]!
}

struct VenueData: Codable {
  let id: String!
  let name: String!
  let location: Location!
  let categories: [Category]!
}

struct Location: Codable {
  let address: String!
  let crossStreet: String!
  let distance: Int!
  let postalCode: String!
  let city: String!
  let state: String!
  let country: String!
  let lat: Float!
  let lng: Float!
}

extension Location {
  static var distanceFromUser: Int!
}

struct Category: Codable {
  let name: String!
  let shortName: String!
}

