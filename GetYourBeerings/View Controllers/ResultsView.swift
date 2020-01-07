//
//  ResultsView.swift
//  Get Your Beerings
//
//  Created by Will Nixon on 10/19/19.
//  Copyright © 2019 Will Nixon. All rights reserved.
//

import UIKit
import ArcGIS
import RadioGroup

class ResultsView: UIViewController {
  
  var sortOptionsView: SortOptionsView!
  var placeholderText: UILabel!
  var linksView: UIView!
  var stateController: StateController!
  var collectionView: UICollectionView!
  var results: [VenueData]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.results = self.stateController.venues
    if (self.results.count > 0) {
      self.placeholderText.isHidden = true
      self.linksView.isHidden = true
    } else {
      self.placeholderText.isHidden = false
      self.linksView.isHidden = false
    }
    self.sortResultsBy(radioGroup: sortOptionsView.radioGroup)
    self.collectionView.reloadData()
  }
  
  func initView() {
    self.view.backgroundColor = UIColor(red: 249/255, green: 200/255, blue: 51/255, alpha: 1)
    
    sortOptionsView = SortOptionsView(title: "Sort results by:", options: ["Name", "Distance"])
    self.view.addSubview(sortOptionsView)
    sortOptionsView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      sortOptionsView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
      sortOptionsView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      sortOptionsView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      sortOptionsView.heightAnchor.constraint(equalToConstant: 80),
      sortOptionsView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
    ])
    sortOptionsView.radioGroup.addTarget(self, action: #selector(sortResultsBy(radioGroup:)), for: .valueChanged)
    
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 80, height: 80)
    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    self.view.addSubview(collectionView)
    collectionView.backgroundColor = UIColor(red: 249/255, green: 200/255, blue: 51/255, alpha: 1)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: sortOptionsView.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
    ])
    self.collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: "SearchResultCell")
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.collectionView.allowsMultipleSelection = false
    
    placeholderText = UILabel()
    self.view.addSubview(placeholderText)
    placeholderText.textColor = .black
    placeholderText.text = "Use the map to find breweries, pubs, and beer-gardens near you or in an area you plan to visit"
    placeholderText.textColor = .black
    placeholderText.numberOfLines = 3
    placeholderText.adjustsFontSizeToFitWidth = true
    placeholderText.minimumScaleFactor = 0.5
    placeholderText.textAlignment = .center
    placeholderText.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      placeholderText.centerYAnchor.constraint(equalTo: self.collectionView.centerYAnchor),
      placeholderText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      placeholderText.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
      placeholderText.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 50),
      placeholderText.trailingAnchor.constraint(greaterThanOrEqualTo: self.view.trailingAnchor, constant: -50)
    ])
    
    linksView = UIView()
    self.view.addSubview(linksView)
    linksView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      linksView.topAnchor.constraint(equalTo: placeholderText.bottomAnchor, constant: 25),
      linksView.leadingAnchor.constraint(equalTo: placeholderText.leadingAnchor),
      linksView.trailingAnchor.constraint(equalTo: placeholderText.trailingAnchor),
      linksView.heightAnchor.constraint(equalToConstant: 45),
      linksView.centerXAnchor.constraint(equalTo: placeholderText.centerXAnchor),
    ])
        
    let privacyPolicy = UIButton()
    linksView.addSubview(privacyPolicy)
    privacyPolicy.setTitle("Privacy Policy", for: .normal)

    privacyPolicy.setTitleColor(UIColor(red: 0/255, green: 101/255, blue: 255/255, alpha: 1.0), for: .normal)
    privacyPolicy.titleLabel!.font = .systemFont(ofSize: 16)
    privacyPolicy.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      privacyPolicy.trailingAnchor.constraint(equalTo: linksView.centerXAnchor),
      privacyPolicy.widthAnchor.constraint(equalTo: linksView.widthAnchor, multiplier: 0.5),
      privacyPolicy.heightAnchor.constraint(equalToConstant: 45),
    ])
    privacyPolicy.addTarget(self, action: #selector(launchWebsite(tapped:)), for: .touchUpInside)

    let termsOfService = UIButton()
    linksView.addSubview(termsOfService)
    termsOfService.setTitle("Terms of Service", for: .normal)
    termsOfService.setTitleColor(UIColor(red: 0/255, green: 101/255, blue: 255/255, alpha: 1.0), for: .normal)
    termsOfService.titleLabel!.font = .systemFont(ofSize: 16)
    termsOfService.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      termsOfService.leadingAnchor.constraint(equalTo: linksView.centerXAnchor),
      termsOfService.widthAnchor.constraint(equalTo: linksView.widthAnchor, multiplier: 0.5),
      termsOfService.heightAnchor.constraint(equalToConstant: 45),
    ])
    termsOfService.addTarget(self, action: #selector(launchWebsite(tapped:)), for: .touchUpInside)

  }
  
  @IBAction func launchWebsite(tapped: UIButton) {
    let buttonTapped = tapped.titleLabel!.text!
    var url: String!
    if (buttonTapped == "Privacy Policy") {
      url = "http://www.getyourbeerings.com/privacy-policy.html"
    } else {
      url = "http://www.getyourbeerings.com/tos.html"
    }
    UIApplication.shared.open(NSURL(string: url)! as URL)
  }
  
  func calculateDistance(user: CLLocation, venue: Location) -> Double {
    let distance = user.distance(from: CLLocation(latitude: CLLocationDegrees(venue.lat), longitude: CLLocationDegrees(venue.lng)))
    return distance
  }
  
  @IBAction func sortResultsBy(radioGroup: RadioGroup) {
    guard let option = radioGroup.titles[radioGroup.selectedIndex] else { return }
    switch(option) {
      case "Name":
        self.results.sort(by: { $0.name < $1.name } )
        self.collectionView.reloadData()
        break
      case "Distance":
        self.results.sort(by: { self.calculateDistance(user: self.stateController.userLocation, venue: $0.location) < self.calculateDistance(user: self.stateController.userLocation, venue: $1.location) } )
        self.collectionView.reloadData()
        break
      case "Rating":
        break
      default:
        break
    }
  }
  
  @IBAction func handleFetchRequest() {
    if let selectedVenue = self.stateController.selectedVenue {
      if let venueDetails = self.stateController.selectedVenueDetails {
        if selectedVenue.id == venueDetails.id {
          let detailsView = DetailsView()
          detailsView.stateController = self.stateController
          self.present(detailsView, animated: true, completion: nil)
        } else {
          self.stateController.selectedVenuePhotos.removeAll()
          self.fetchVenueDetails()
        }
      } else {
        self.stateController.selectedVenuePhotos.removeAll()
        self.fetchVenueDetails()
      }
    }
  }
    
  func fetchVenueDetails() {
    if let selectedVenue = self.stateController.selectedVenue {
        RouteManager.request(router: .getDetails, latLong: nil, radius: nil, venueID: selectedVenue.id) { (result: Result<VenueDetailsResponse, Error>) in
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
  }

}

// MARK: CollectionView DataSource
extension ResultsView: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.results.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
    let venue = self.results[indexPath.row]
    
    cell.name.text = venue.name
    cell.address.text = venue.location.address
    cell.city.text = "\(venue.location.city ?? ""), \(venue.location.state ?? "")"
    cell.country.text = venue.location.country
    cell.button.addTarget(self, action: #selector(handleFetchRequest), for: .touchUpInside)
    
    if (venue.location.distance != nil) {
      if let userLocation = self.stateController.userLocation {
        let meters = calculateDistance(user: userLocation, venue: venue.location)
        let miles = meters / 1609.34
        let milesFormatted = String(format: "%.2f", miles)
        cell.distance.text = "\(milesFormatted) miles"
      }
    }
    
    if let selectedVenue = self.stateController.selectedVenue {
      if (cell.name.text == selectedVenue.name) {
        cell.isSelected = true
      } else {
        cell.isSelected = false
      }
    }
    
    if cell.isSelected {
      cell.contentView.layer.cornerRadius = 10
      cell.contentView.layer.borderWidth = 1.0
      cell.contentView.layer.borderColor = UIColor.clear.cgColor
      cell.contentView.layer.masksToBounds = true
      cell.layer.shadowColor = UIColor.black.cgColor
      cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
      cell.layer.shadowRadius = 2.0
      cell.layer.shadowOpacity = 0.5
      cell.layer.masksToBounds = false
      cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
      cell.button.isHidden = false
    } else {
      cell.backgroundColor = UIColor(red: 254/255, green: 225/255, blue: 147/255, alpha: 1.0)
      cell.layer.borderWidth = 0
      cell.layer.cornerRadius = 10
      cell.contentView.layer.cornerRadius = 0
      cell.contentView.layer.borderWidth = 0
      cell.contentView.layer.borderColor = UIColor.clear.cgColor
      cell.contentView.layer.masksToBounds = true
      cell.layer.shadowColor = UIColor.black.cgColor
      cell.layer.shadowOffset = CGSize(width: 0, height: 0)
      cell.layer.shadowRadius = 0
      cell.layer.shadowOpacity = 0
      cell.button.isHidden = true
    }

    return cell
  }

}

// MARK: CollectionView Delegate
extension ResultsView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! SearchResultCell
    cell.contentView.layer.cornerRadius = 10
    cell.contentView.layer.borderWidth = 1.0
    cell.contentView.layer.borderColor = UIColor.clear.cgColor
    cell.contentView.layer.masksToBounds = true
    cell.layer.shadowColor = UIColor.black.cgColor
    cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
    cell.layer.shadowRadius = 2.0
    cell.layer.shadowOpacity = 0.5
    cell.layer.masksToBounds = false
    cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    cell.button.isHidden = false
    let selectedVenue = self.results[indexPath.row]
    stateController.selectedVenue = selectedVenue
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? SearchResultCell else { return }
    cell.backgroundColor = UIColor(red: 254/255, green: 225/255, blue: 147/255, alpha: 1.0)
    cell.layer.borderWidth = 0
    cell.layer.cornerRadius = 10
    cell.contentView.layer.cornerRadius = 0
    cell.contentView.layer.borderWidth = 0
    cell.contentView.layer.borderColor = UIColor.clear.cgColor
    cell.contentView.layer.masksToBounds = true
    cell.layer.shadowColor = UIColor.black.cgColor
    cell.layer.shadowOffset = CGSize(width: 0, height: 0)
    cell.layer.shadowRadius = 0
    cell.layer.shadowOpacity = 0
    cell.button.isHidden = true
  }
}

// MARK: CollectionView FlowLayout Delegate
extension ResultsView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    var width: Int!
    let height = 300
    if (UIDevice.current.userInterfaceIdiom == .pad) {
      width = 250
    } else {
      let noOfCellsInRow = 2
      width = Int(CGFloat(self.collectionView.bounds.width - 16) / CGFloat(noOfCellsInRow))
    }
    
    return CGSize(width: width, height: height)
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    var sides = CGFloat(5)
    if (UIDevice.current.userInterfaceIdiom == .pad) {
      sides = CGFloat(50)
    }
    return UIEdgeInsets.init(top: 5, left: sides, bottom: 5, right: sides)
  }
  
}
