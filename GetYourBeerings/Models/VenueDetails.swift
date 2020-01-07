//
//  VenueDetails.swift
//  GetYourBeerings
//
//  Created by Will Nixon on 10/28/19.
//  Copyright © 2019 Will Nixon. All rights reserved.
//

import Foundation

// MARK: - VenueDetails
struct VenueDetailsResponse: Codable {
  let meta: MetaDetails
  let response: ResponseDetails
}

// MARK: - Meta
struct MetaDetails: Codable {
  let code: Int
  let requestID: String
  
  enum CodingKeys: String, CodingKey {
    case code
    case requestID = "requestId"
  }
}

// MARK: - Response
struct ResponseDetails: Codable {
  let venue: VenueDetails!
}

// MARK: - Venue
struct VenueDetails: Codable {
  let id, name: String!
  let contact: VenueContact!
  let venueLocation: VenueLocation!
  let canonicalURL: String!
  let venueCategories: [VenueCategory]!
  let verified: Bool!
  let stats: Stats!
  let url: String!
  let likes: Likes!
  let rating: Double!
  let ratingColor: String!
  let ratingSignals: Int!
  let photos: Listed!
  let venueDescription: String!
  let tips: Listed!
  let shortURL: String!
  let timeZone: String!
  let phrases: [Phrase]!
  let hours, popular: Hours!
  let pageUpdates, inbox: Inbox!
  let attributes: Attributes!
  let bestPhoto: BestPhotoClass!
}

// MARK: - Attributes
struct Attributes: Codable {
  let groups: [Group]
}

// MARK: - GroupItem
struct GroupItem: Codable {
  let displayName, displayValue, id, name: String?
  let itemDescription, type: String?
  let user: BestPhotoUser?
  let editable, itemPublic, collaborative: Bool?
  let url: String?
  let canonicalURL: String?
  let createdAt, updatedAt: Int?
  let photo: BestPhotoClass?
  let followers: Tips?
  let listItems: Inbox?
  let itemPrefix: String?
  let suffix: String?
  let width, height: Int?
  let visibility, text: String?
  let photourl: String?
  let lang: String?
  let logView: Bool?
  let agreeCount, disagreeCount: Int?
  let todo: Tips?
  let editedAt: Int?
  let authorInteractionType: String?
}

// MARK: - Group
struct Group: Codable {
  let type: String!
  let name, summary: String!
  let count: Int!
  let items: [GroupItem]!
}

// MARK: - Tips
struct Tips: Codable {
  let count: Int!
}

// MARK: - Inbox
struct Inbox: Codable {
  let count: Int!
  let items: [InboxItem]!
}

// MARK: - InboxItem
struct InboxItem: Codable {
  let id: String?
  let createdAt: Int?
  let photo: BestPhotoClass?
  let url: String?
}

// MARK: - BestPhotoClass
struct BestPhotoClass: Codable {
  let id: String!
  let createdAt: Int!
  let photoPrefix: String!
  let suffix: String!
  let width, height: Int!
  let visibility: String!
  let user: BestPhotoUser?
  
  enum CodingKeys: String, CodingKey {
    case id, createdAt
    case photoPrefix = "prefix"
    case suffix, width, height, visibility, user
  }
}

// MARK: - BestPhotoUser
struct BestPhotoUser: Codable {
  let id, firstName, gender: String!
  let photo: IconClass?
  let type, lastName: String?
}

// MARK: - IconClass
struct IconClass: Codable {
  let photoPrefix: String!
  let suffix: String!
  
  enum CodingKeys: String, CodingKey {
    case photoPrefix = "prefix"
    case suffix
  }
}

// MARK: - Category
struct VenueCategory: Codable {
  let id, name, pluralName, shortName: String!
  let icon: IconClass!
  let primary: Bool!
}

// MARK: - VenueContact
struct VenueContact: Codable {
  let phone, formattedPhone, twitter, instagram: String?
  let facebook, facebookUsername, facebookName: String?
}

// MARK: - Hours
struct Hours: Codable {
  let status: String!
  let isOpen, isLocalHoliday: Bool!
  let timeframes: [Timeframe]!
}

// MARK: - Timeframe
struct Timeframe: Codable {
  let days: String!
  let includesToday: Bool?
  let timeframeOpen: [Open]!
  
  enum CodingKeys: String, CodingKey {
    case days, includesToday
    case timeframeOpen = "open"
  }
}

// MARK: - Open
struct Open: Codable {
  let renderedTime: String!
}

// MARK: - Likes
struct Likes: Codable {
  let count: Int!
  let summary: String!
}

// MARK: - Listed
struct Listed: Codable {
  let count: Int!
  let groups: [Group]!
}

// MARK: - Location
struct VenueLocation: Codable {
  let address, crossStreet: String!
  let lat, lng: Double!
  let postalCode, cc, city, state: String!
  let country: String!
  let formattedAddress: [String]!
}

// MARK: - Phrase
struct Phrase: Codable {
  let phrase: String!
  let sample: Sample!
  let count: Int!
}

// MARK: - Sample
struct Sample: Codable {
  let entities: [Entity]!
  let text: String!
}

// MARK: - Entity
struct Entity: Codable {
  let indices: [Int]!
  let type: String!
}

// MARK: - Stats
struct Stats: Codable {
  let checkinsCount, usersCount, tipCount, visitsCount: Int!
}
