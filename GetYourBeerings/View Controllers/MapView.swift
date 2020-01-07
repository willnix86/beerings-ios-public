//
//  MapView.swift
//  Get Your Beerings
//
//  Created by Will Nixon on 10/19/19.
//  Copyright © 2019 Will Nixon. All rights reserved.
//

import UIKit
import ArcGIS

class MapView: UIViewController {
  
  var stateController: StateController!
  var mapview: AGSMapView!
  var map: AGSMap!
  var search: SearchBarWithPrompt!
  var searchSuggestions: [String] = ["Search nearby"]
  var suggestionsTable: UITableView!
  var locatorTask: AGSLocatorTask!
  var venueSearchResults: [VenueData] = []
  var overlay: AGSGraphicsOverlay!
  var originalMapScale: Double = 577790.5625
  var locateButton: UIButton!
  var searchEditing: Bool = false
  var currentCountry: String!
  var panMode: String!

  override func viewDidLoad() {
    super.viewDidLoad()
    initViews()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.mapview.locationDisplay.stop()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.initLocationTracker()
    
    guard let selectedVenue = stateController.selectedVenue else { return }
    let lat = CLLocationDegrees(selectedVenue.location.lat)
    let lng = CLLocationDegrees(selectedVenue.location.lng)
    let point = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: lat, longitude: lng))
    self.recenterMap(center: point, scale: (self.originalMapScale / 12), searchResult: nil)
    
    self.mapview.callout.show(at: point, screenOffset: CGPoint(x: 0, y: 0), rotateOffsetWithMap: true, animated: true)
    self.mapview.callout.title = selectedVenue.name
    self.mapview.callout.detail = selectedVenue.location.address
  }
  
  func initViews() {
    self.view.backgroundColor = UIColor(red: 249/255, green: 200/255, blue: 51/255, alpha: 1)
    
    search = SearchBarWithPrompt(prompt: "Enter a place or address to search near")
    self.view.addSubview(search)
    search.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      search.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      search.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      search.heightAnchor.constraint(equalToConstant: 80)
    ])
    search.searchBar.delegate = self
    
    self.initMap()
    
    suggestionsTable = UITableView()
    suggestionsTable.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    suggestionsTable.backgroundColor = .white
    suggestionsTable.dataSource = self
    suggestionsTable.delegate = self
    self.view.addSubview(suggestionsTable)
    suggestionsTable.isHidden = true
    suggestionsTable.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      suggestionsTable.topAnchor.constraint(equalTo: search.bottomAnchor, constant: -5),
      suggestionsTable.heightAnchor.constraint(equalToConstant: 200),
      suggestionsTable.centerXAnchor.constraint(equalTo: search.centerXAnchor)
    ])
    
    let buttonSize = 45
    locateButton = UIButton(frame: CGRect(x: 160, y: 100, width: buttonSize, height: buttonSize))
    locateButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    locateButton.layer.backgroundColor = UIColor(red: 255/255, green: 151/255, blue: 80/255, alpha: 1.0).cgColor
    locateButton.layer.cornerRadius = 0.5 * locateButton.bounds.size.width
    locateButton.layer.masksToBounds = true
    let buttonImage = UIImage(named: "LocateButton")
    locateButton.setImage(buttonImage?.withTintColor(.white), for: .normal)
    locateButton.setImage(buttonImage, for: .highlighted)
    self.view.addSubview(locateButton)
    locateButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      locateButton.heightAnchor.constraint(equalToConstant: CGFloat(integerLiteral: buttonSize)),
      locateButton.widthAnchor.constraint(equalToConstant: CGFloat(integerLiteral: buttonSize)),
      locateButton.bottomAnchor.constraint(equalTo: self.mapview.bottomAnchor, constant: -120),
      locateButton.trailingAnchor.constraint(equalTo: self.mapview.trailingAnchor, constant: -25)
    ])
    locateButton.addTarget(self, action: #selector(locateUser), for: .touchUpInside)
    
    // MARK: Constraints dependent on device size
    if (UIDevice.current.userInterfaceIdiom == .pad) {
      NSLayoutConstraint.activate([
        search.widthAnchor.constraint(lessThanOrEqualToConstant: 1000),
        suggestionsTable.widthAnchor.constraint(equalTo: search.widthAnchor),
      ])
    } else {
      NSLayoutConstraint.activate([
        search.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 20),
        search.trailingAnchor.constraint(greaterThanOrEqualTo: self.view.trailingAnchor, constant: -20),
        suggestionsTable.leadingAnchor.constraint(equalTo: search.leadingAnchor),
        suggestionsTable.trailingAnchor.constraint(equalTo: search.trailingAnchor),
      ])
    }
    
  }
  
  func initMap() {
    self.map = AGSMap(basemapType: AGSBasemapType.navigationVector, latitude: 38.9072, longitude: -77.0369, levelOfDetail: 10)
    self.mapview = AGSMapView()
    self.mapview.map = map
    self.view.addSubview(mapview)
    self.mapview.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.mapview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      self.mapview.widthAnchor.constraint(equalTo: self.view.widthAnchor),
      self.mapview.topAnchor.constraint(equalTo: self.search.bottomAnchor),
      self.mapview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
    self.mapview.touchDelegate = self
    
    self.mapview.callout.isAccessoryButtonHidden = false
    self.mapview.callout.accessoryButtonType = .custom
    self.mapview.callout.accessoryButtonImage = UIImage(named: "OpenVenue")
    self.mapview.callout.margin = CGSize(width: 10, height: 5)
    self.mapview.callout.color = .black
    self.mapview.callout.titleColor = .white
    self.mapview.callout.detailColor = .white
    self.mapview.callout.delegate = self
    
    self.mapview.map?.load(completion: { [weak self] (error:Error?) -> Void in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      
      if self?.mapview.map?.loadStatus == .loaded {
        print("Map loaded")
        self?.initLocator()
        self?.originalMapScale = (self?.mapview.mapScale)!
      }
    })
  }
  
  func initLocator() {
    self.locatorTask = AGSLocatorTask(url: URL(string: "https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer")!)
    self.locatorTask.load(completion: { [weak self] (error:Error?) -> Void in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      
      if self?.locatorTask.loadStatus == .loaded {
        print("Locator ready")
      }
    })
  }
  
  func initLocationTracker() {
    self.mapview.locationDisplay.autoPanMode = .recenter
    self.panMode = "recenter"
    self.mapview.locationDisplay.start { [weak self] (error:Error?) -> Void in
      if let error = error {
        ErrorManager.showAlert(title: "Error", message: error.localizedDescription, vc: self)
      }
    }
    print("Location tracking started")
            
    if let location = CLLocationManager().location {
      self.stateController.userLocation = location
      let reverseGeocoder = CLGeocoder()
      reverseGeocoder.reverseGeocodeLocation(location) { (placemarks, error) in
        if error != nil {
          print("Error getting location")
        } else {
          self.currentCountry = placemarks?.first?.country!
        }
      }
    }
  }
  
  func recenterMap(center: AGSPoint, scale: Double, searchResult: AGSGeocodeResult?) {
    self.mapview.setViewpointCenter(center, scale: scale, completion: { finished in
      
      if (searchResult != nil) {
        guard let latitude = searchResult!.displayLocation?.toCLLocationCoordinate2D().latitude, let longitude = searchResult!.displayLocation?.toCLLocationCoordinate2D().longitude else {
          print("Eror getting lat-long")
          return
        }
        self.fetchVenues(latLong: "\(latitude),\(longitude)")
      }
    })
  }
  
  func handleMapSearch(search: String) {
    if let overlay = self.overlay {
      if (overlay.graphics.count > 0) {
        overlay.graphics.removeAllObjects()
      }
    }
    
    if (search == "Search nearby") {
      guard let location = self.mapview.locationDisplay.mapLocation?.toCLLocationCoordinate2D() else { return }
      let latitude = location.latitude
      let longitude = location.longitude
      self.fetchVenues(latLong: "\(latitude),\(longitude)")
      return
    }
    self.locatorTask.geocode(withSearchText: search) {
      (results, error) in
      guard error == nil else {
        print("Error geocoding '\(search)': \(error!.localizedDescription)")
        return
      }
      
      guard let firstResult = results?.first, let extent = firstResult.extent else {
        ErrorManager.showAlert(title: "No results found for", message: search, vc: self)
        return
      }
      
      self.recenterMap(center: extent.center, scale: (self.originalMapScale / 7), searchResult: firstResult)
    }
  }
  
  func fetchVenues(latLong: String) {
    RouteManager.request(router: .getVenues, latLong: latLong, radius: "8000", venueID: nil) { (result: Result<VenueReponse, Error>) in
      switch result {
      case .success:
        do {
          let venueResponseObj = try result.get()
          guard let venues = venueResponseObj.response.venues else { return }
          self.venueSearchResults.append(contentsOf: venues)
          self.addGraphicsToMap(venues: venues)
          self.stateController!.venues.removeAll()
          self.stateController!.venues.append(contentsOf: venues)
        } catch let error {
          print("Error: \(error)")
        }
      case .failure(let error):
        ErrorManager.showAlert(title: "Search error:", message: error as? String, vc: self)
      }
    }
  }
  
  func fetchVenueDetails(venueID: String) {
      RouteManager.request(router: .getDetails, latLong: nil, radius: nil, venueID: venueID) { (result: Result<VenueDetailsResponse, Error>) in
        switch result {
        case .success:
          do {
            let venueDetailsResponseObj = try result.get()
            guard let venueDetails = venueDetailsResponseObj.response.venue else { return }
            self.stateController.selectedVenueDetails = venueDetails
            DispatchQueue.main.async {
              let detailsView = DetailsView()
              detailsView.stateController = self.stateController
              self.present(detailsView, animated: true, completion: nil)
            }
          } catch let error {
            print("Error: \(error)")
          }
        case .failure(let error):
          ErrorManager.showAlert(title: "Search error:", message: error as? String, vc: self)
      }
    }
  }

  func addGraphicsToMap(venues: [VenueData]) {
    var graphics: [AGSGraphic] = []
    if (self.mapview.graphicsOverlays.count < 1) {
      self.overlay = AGSGraphicsOverlay()
      self.mapview.graphicsOverlays.add(overlay!)
    }
    for venue in self.venueSearchResults {
      let markerImage = UIImage(named: "MapMarker")
      let marker = AGSPictureMarkerSymbol(image: markerImage!)
      marker.height = CGFloat(25.0)
      marker.width = CGFloat(25.0)
      let venuePoint = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: CLLocationDegrees(venue.location.lat), longitude: CLLocationDegrees(venue.location.lng)))
      let graphic = AGSGraphic(geometry: venuePoint, symbol: marker, attributes: ["name": venue.name!, "address": venue.location.address ?? ""])
      graphics.append(graphic)
    }
    self.overlay?.graphics.addObjects(from: graphics)
  }
  
  @IBAction func locateUser() {
    if let location = self.mapview.locationDisplay.location {
      let center = location.position
      self.recenterMap(center: center!, scale: (self.originalMapScale / 7), searchResult: nil)
    }
    if (self.panMode == "recenter") {
      print("recenter")
      self.mapview.locationDisplay.autoPanMode = .compassNavigation
      self.panMode = "compass"
    } else {
      print("compass")
      self.mapview.locationDisplay.autoPanMode = .recenter
      self.panMode = "recenter"
    }
  }
  
}

// MARK: Search Bar Delegate
extension MapView: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar,
                 textDidChange searchText: String) {
    if searchText != "" {
      self.mapview.callout.dismiss()
      if self.locatorTask.locatorInfo!.supportsSuggestions {
        let suggestParams = AGSSuggestParameters()
        suggestParams.maxResults = 10
        suggestParams.categories = ["address", "postal", "populated place"]
        if (self.currentCountry != nil) {
          suggestParams.countryCode = self.currentCountry!
        }
        self.locatorTask.suggest(withSearchText: searchText, parameters: suggestParams, completion: {(results, error) in
          if error != nil {
            ErrorManager.showAlert(title: "Error", message: error?.localizedDescription, vc: self)
            return
          }
          results?.forEach {(result) in
            // maxResults + 1 for search nearby
            if (self.searchSuggestions.count == (suggestParams.maxResults + 1)) {
              // remove at 1 so don't remove search nearby
              self.searchSuggestions.remove(at: 1)
            }
            self.searchSuggestions.append(result.label)
          }
          if (self.suggestionsTable.isHidden) {
            self.suggestionsTable.isHidden = false
          }
          self.suggestionsTable.reloadData()
        })
      }
    } else {
      self.suggestionsTable.isHidden = true
      if self.venueSearchResults.count > 0 {
        self.venueSearchResults.removeAll()
        self.stateController!.venues.removeAll()
        self.overlay.graphics.removeAllObjects()
        self.mapview.callout.dismiss()
      }
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    guard let searchText = searchBar.text, !searchText.isEmpty else {
      ErrorManager.showAlert(title: "Search field cannot be blank", message: "Please enter one or more words to search by", vc: self)
      return
    }
    if (!self.suggestionsTable.isHidden) {
      self.suggestionsTable.isHidden = true
    }
    self.handleMapSearch(search: searchText)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    if self.venueSearchResults.count > 0 {
      self.venueSearchResults.removeAll()
      self.stateController!.venues.removeAll()
      self.overlay.graphics.removeAllObjects()
    }
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.searchEditing = true
    self.suggestionsTable.isHidden = false
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    self.searchEditing = false
  }
  
}

// MARK: Suggestions Table Delegate
extension MapView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let suggestion = self.searchSuggestions[indexPath.item]
    self.search.searchBar.text = suggestion
    self.handleMapSearch(search: suggestion)
    if (!self.suggestionsTable.isHidden) {
      self.suggestionsTable.isHidden = true
      self.search.searchBar.resignFirstResponder()
    }
  }
}

// MARK: Suggestions Table Datasource
extension MapView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.searchSuggestions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
    let suggestion = self.searchSuggestions[indexPath.item]
    cell.backgroundColor = .clear
    cell.textLabel?.text = suggestion
    cell.textLabel?.textColor = .black
    return cell
  }
  
}

// MARK: Map Interaction Delegsate
extension MapView: AGSGeoViewTouchDelegate {
  func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
    
    if (self.searchEditing) {
      self.search.searchBar.endEditing(true)
    }
    
    if (self.suggestionsTable.isHidden == false) {
      self.suggestionsTable.isHidden = true
    }
    
    if (self.mapview.callout.isHidden == false) {
      self.mapview.callout.dismiss()
      if (stateController.selectedVenue != nil) {
        stateController.selectedVenue = nil
      }
    }
    
    if (self.overlay != nil) {
      let tolerance: Double = 12
      self.mapview.identify(self.overlay, screenPoint: screenPoint, tolerance: tolerance, returnPopupsOnly: false, maximumResults: 10, completion: { [weak self] (result: AGSIdentifyGraphicsOverlayResult) in
        if let error = result.error {
          print("Error identifying graphics: \(error.localizedDescription)")
        } else {
          if !result.graphics.isEmpty {
            let tappedVenue = result.graphics[0]
            let tappedVenueName = tappedVenue.attributes.value(forKey: "name") as! String
            let tappedVenueAddress = tappedVenue.attributes.value(forKey: "address") as! String
            self?.mapview.callout.title = tappedVenueName
            self?.mapview.callout.detail = tappedVenueAddress
            self?.mapview.callout.show(for: tappedVenue, tapLocation: AGSPoint(x: Double(screenPoint.x), y: Double(screenPoint.y), spatialReference: nil), animated: true)
            let venue = self?.stateController.venues.first(where: { $0.name == tappedVenueName })
            self?.stateController.selectedVenue = venue
          }
        }
      })
    }

  }
}

// MARK: Callout Delegate
extension MapView: AGSCalloutDelegate {
  func didTapAccessoryButton(for callout: AGSCallout) {
    guard let venue = stateController.venues.first(where: { $0.name == callout.title }) else { return }
    stateController.selectedVenue = venue
    if let venueDetails = self.stateController.selectedVenueDetails {
      if (venueDetails.id == venue.id) {
        let detailsView = DetailsView()
        detailsView.stateController = self.stateController
        self.present(detailsView, animated: true, completion: nil)
      } else {
        self.fetchVenueDetails(venueID: venue.id)
      }
    } else {
      self.fetchVenueDetails(venueID: venue.id)
    }
  }
  
  func calloutDidDismiss(_ callout: AGSCallout) {
    guard let venue = stateController.selectedVenue else { return }
    if (venue.name == callout.title) {
      stateController.selectedVenue = nil
    }
  }
}
