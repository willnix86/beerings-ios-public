//
//  PhotoResults.swift
//  GetYourBeerings
//
//  Created by Will Nixon on 11/7/19.
//  Copyright © 2019 Will Nixon. All rights reserved.
//

import Foundation

// MARK: - PhotoResults
struct PhotoResults: Codable {
  let meta: MetaPhoto
  let response: ResponsePhoto
}

// MARK: - Meta
struct MetaPhoto: Codable {
  let code: Int
  let requestID: String
  
  enum CodingKeys: String, CodingKey {
    case code
    case requestID = "requestId"
  }
}

// MARK: - Response
struct ResponsePhoto: Codable {
  let photos: Photos
}

// MARK: - Photos
struct Photos: Codable {
  let count: Int!
  let items: [Item]!
  let dupesRemoved: Int!
}

// MARK: - Item
struct Item: Codable {
  let id: String!
  let createdAt: Int!
  let source: Source!
  let itemPrefix: String!
  let suffix: String!
  let width, height: Int!
  let user: User!
  let checkin: Checkin!
  let visibility: String!
  
  enum CodingKeys: String, CodingKey {
    case id, createdAt, source
    case itemPrefix = "prefix"
    case suffix, width, height, user, checkin, visibility
  }
}

// MARK: - Checkin
struct Checkin: Codable {
  let id: String!
  let createdAt: Int!
  let type: String!
  let timeZoneOffset: Int!
}

// MARK: - Source
struct Source: Codable {
  let name: String!
  let url: String!
}

// MARK: - User
struct User: Codable {
  let id, firstName, lastName, gender: String!
  let photo: Photo!
}

// MARK: - Photo
struct Photo: Codable {
  let photoPrefix: String!
  let suffix: String!
  
  enum CodingKeys: String, CodingKey {
    case photoPrefix = "prefix"
    case suffix
  }
}
