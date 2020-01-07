//
//  Router.swift
//  Get Your Beerings
//
//  Created by Will Nixon on 10/22/19.
//  Copyright © 2019 Will Nixon. All rights reserved.
//

import Foundation

enum Router {
  case getVenues
  case getDetails
  case getPhotos
  
  var scheme: String {
    switch self {
    case .getVenues, .getDetails, .getPhotos:
      return "https"
    }
  }
  
  var host: String {
    switch self {
    case .getVenues, .getDetails, .getPhotos:
      return "api.foursquare.com"
    }
  }
  
  var path: String {
    switch self {
    case .getVenues:
      return "/v2/venues/search"
    case .getDetails:
      return "/v2/venues"
    case .getPhotos:
      return "/v2/venues"
    }
  }
  
  var parameters: [URLQueryItem] {
    let clientId = "XXXXXXXXXXXXXXX"
    let clientSecret = "XXXXXXXXXXXXXX"
    let version = "20191022"
    
    switch self {
    case .getVenues:
      let intent = "browser"
      let limit = "50"
      let categories = "4bf58dd8d48988d155941735,56aa371ce4b08b9a8d573583,52e81612bcbc57f1066b7a06,56aa371ce4b08b9a8d57356c,4bf58dd8d48988d117941735,4bf58dd8d48988d11b941735,50327c8591d4c4b30a586d5d,4bf58dd8d48988d14b941735,4bf58dd8d48988d1de941735,4bf58dd8d48988d123941735,4bf58dd8d48988d122941735"
      return [
        URLQueryItem(name: "client_id", value: clientId),
        URLQueryItem(name: "client_secret", value: clientSecret),
        URLQueryItem(name: "limit", value: limit),
        URLQueryItem(name: "intent", value: intent),
        URLQueryItem(name: "v", value: version),
        URLQueryItem(name: "categoryId", value: categories)
      ]
    case .getDetails:
      return [
        URLQueryItem(name: "client_id", value: clientId),
        URLQueryItem(name: "client_secret", value: clientSecret),
        URLQueryItem(name: "v", value: version),
      ]
    case .getPhotos:
      let group = "venue"
      let limit = "75"
      return [
        URLQueryItem(name: "client_id", value: clientId),
        URLQueryItem(name: "client_secret", value: clientSecret),
        URLQueryItem(name: "v", value: version),
        URLQueryItem(name: "group", value: group),
        URLQueryItem(name: "limit", value: limit)
      ]
    }
  }
  
  var method: String {
    switch self {
    case .getVenues, .getDetails, .getPhotos:
      return "GET"
    }
  }
  
}

class RouteManager {
  class func request<T: Codable>(router: Router, latLong: String?, radius: String?, venueID: String?, completion: @escaping (Result<T, Error>) -> ()) {
    var components = URLComponents()
    components.scheme = router.scheme
    components.host = router.host
    components.queryItems = router.parameters
    
    if (router == .getVenues) {
      components.path = router.path
      components.queryItems?.append(contentsOf: [
        URLQueryItem(name: "ll", value: latLong),
        URLQueryItem(name: "radius", value: radius),
      ])
    }
    
    if (router == .getDetails || router == .getPhotos) {
     components.path = "\(router.path)/\(venueID!)"
    }
    
    if (router == .getPhotos) {
      components.path = "\(components.path)/photos"
    }
    
    guard let url = components.url else { return }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = router.method
    
    let session = URLSession(configuration: .default)
    let dataTask = session.dataTask(with: urlRequest) { data, response, error in
      
      if let error = error {
        completion(.failure(error))
      } else {
        if let response = response as? HTTPURLResponse {
          print("statusCode: \(response.statusCode)")
        }
        if let data = data {
          do {
            let decoder = JSONDecoder()
            let responseObj = try decoder.decode(T.self, from: data)
            completion(.success(responseObj))
          } catch let parsingError {
            print("Error: \(parsingError)")
          }
        }
      }
    }
    dataTask.resume()
  }
}
