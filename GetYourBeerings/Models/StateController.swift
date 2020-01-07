//
//  StateController.swift
//  GetYourBeerings
//
//  Created by Will Nixon on 10/24/19.
//  Copyright © 2019 Will Nixon. All rights reserved.
//

import Foundation
import ArcGIS

class StateController {
  var venues: [VenueData] = []
  var selectedVenue: VenueData!
  var selectedVenueDetails: VenueDetails!
  var selectedVenuePhotos: [Item] = []
  var userLocation: CLLocation!
}
