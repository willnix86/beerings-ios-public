//
//  DetailsView.swift
//  Get Your Beerings
//
//  Created by Will Nixon on 10/19/19.
//  Copyright © 2019 Will Nixon. All rights reserved.
//

import UIKit

class DetailsView: UIViewController {
  
  var stateController: StateController!
  var imageView: UIImageView!
  var ratingsView: UIStackView!
  var ratingsViewsArray: [UIView] = []
  var tipsView: UIStackView!
  var tipsViewsArray: [UILabel] = []
  var scrollView: UIScrollView!
  var contentView: UIView!
  var venueName: UILabel!
  var venueAddress: UILabel!
  var venueDescription: UILabel!
  var hoursSection: UIView!
  var venueWebsite: UIButton!
  var venuePhone: UIButton!
  var venueImage: UIImage!
  var daysOfTheWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

  override func viewDidLoad() {
    super.viewDidLoad()
    initViews()
  }
    
  func initViews() {
    self.view.backgroundColor = UIColor(red: 254/255, green: 225/255, blue: 147/255, alpha: 1.0)
    guard let venue = stateController.selectedVenueDetails else { return }
    scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(scrollView)
    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
    
    contentView = UIView()
    scrollView.addSubview(contentView)
    contentView.backgroundColor = .clear
    contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
    ])
    
    if (UIScreen.main.bounds.height < 700) {
      contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 1.3).isActive = true
    }
    
    venueImage = UIImage(named: "Sign")
    
    if let photo = venue.bestPhoto, let prefix = photo.photoPrefix, let suffix = photo.suffix, let width = photo.width, let height = photo.height {
      let urlString = "\(prefix)\(width)x\(height)\(suffix)"
      if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
          if let image = UIImage(data: data) {
           venueImage = image
          }
        }
      }
    }
    
    imageView = UIImageView(image: venueImage)
    contentView.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
      imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 175),
      imageView.widthAnchor.constraint(equalToConstant: 175)
    ])
    let tap = UITapGestureRecognizer(target: self, action: #selector(openMainPhoto))
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(tap)
    
    venueName = UILabel()
    contentView.addSubview(venueName)
    venueName.text = venue.name
    venueName.textColor = .black
    venueName.textAlignment = .center
    venueName.font = .boldSystemFont(ofSize: 26)
    venueName.adjustsFontSizeToFitWidth = true
    venueName.minimumScaleFactor = 0.5
    venueName.numberOfLines = 2
    venueName.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      venueName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
      venueName.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
      venueName.widthAnchor.constraint(equalToConstant: 265),
      venueName.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
    ])
    
    var elementAbove = venueName
    
    if let location = stateController.venues.first(where: { $0.id == venue.id })?.location {
      venueAddress = UILabel()
      contentView.addSubview(venueAddress)
      venueAddress.text = "\(location.address ?? ""), \(location.city ?? ""), \(location.state ?? "") \(location.postalCode ?? "")"
      venueAddress.textColor = .black
      venueAddress.textAlignment = .center
      venueAddress.font = .systemFont(ofSize: 16)
      venueAddress.adjustsFontSizeToFitWidth = true
      venueAddress.minimumScaleFactor = 0.5
      venueAddress.numberOfLines = 2
      venueAddress.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        venueAddress.topAnchor.constraint(equalTo: venueName.bottomAnchor, constant: 15),
        venueAddress.leftAnchor.constraint(equalTo: venueName.leftAnchor, constant: 5),
        venueAddress.rightAnchor.constraint(equalTo: venueName.rightAnchor, constant: -5),
        venueAddress.centerXAnchor.constraint(equalTo: venueName.centerXAnchor),
        venueAddress.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
      ])
      
      elementAbove = venueAddress
    }
    
    if let description = venue.venueDescription {
      venueDescription = UILabel()
      contentView.addSubview(venueDescription)
      venueDescription.text = "\(description)"
      venueDescription.textColor = .black
      venueDescription.textAlignment = .center
      venueDescription.font = .systemFont(ofSize: 16)
      venueDescription.adjustsFontSizeToFitWidth = true
      venueDescription.minimumScaleFactor = 0.5
      venueDescription.numberOfLines = 2
      venueDescription.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        venueDescription.topAnchor.constraint(equalTo: elementAbove!.bottomAnchor, constant: 15),
        venueDescription.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
        venueDescription.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
        venueDescription.centerXAnchor.constraint(equalTo: venueName.centerXAnchor),
      ])
      elementAbove = venueDescription
    }
    
    if (venue.rating != nil) {
      let rating = Int(venue.rating) / 2
      for _ in 1...rating {
        let ratingIcon = RatingIcon(ratingImage: "10")
        ratingsViewsArray.append(ratingIcon)
      }
      if (rating % 2 > 0 && Int(venue.rating) < 10) {
        let ratingIcon = RatingIcon(ratingImage: "5")
        ratingsViewsArray.append(ratingIcon)
      }
      ratingsView = UIStackView(arrangedSubviews: ratingsViewsArray)
      contentView.addSubview(ratingsView)
      ratingsView.axis = .horizontal
      ratingsView.alignment = .center
      ratingsView.distribution = .equalSpacing
      ratingsView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
        ratingsView.topAnchor.constraint(equalTo: elementAbove!.bottomAnchor),
        ratingsView.centerXAnchor.constraint(equalTo: elementAbove!.centerXAnchor, constant: -12.5),
        ratingsView.heightAnchor.constraint(equalToConstant: 50),
        ratingsView.widthAnchor.constraint(equalToConstant: 150)
      ])
    }
    
    let elementAboveTwo = (ratingsView != nil) ? ratingsView : elementAbove
    
    if let hours = venue.hours, let timeframes = hours.timeframes {
      hoursSection = UIView()
      contentView.addSubview(hoursSection)
      hoursSection.translatesAutoresizingMaskIntoConstraints = false
      
      let status = UILabel()
      hoursSection.addSubview(status)
      status.text = venue.hours.status
      status.textColor = .black
      if (venue.hours.status.contains("Open")) {
        status.textColor = UIColor(red: 70/255, green: 181/255, blue: 36/255, alpha: 1.0)
      } else {
        status.textColor = UIColor(red: 240/255, green: 21/255, blue: 36/255, alpha: 1.0)
      }
      status.font = .boldSystemFont(ofSize: 18)
      status.textAlignment = .center
      status.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        status.centerXAnchor.constraint(equalTo: elementAbove!.centerXAnchor),
        status.heightAnchor.constraint(equalToConstant: 30),
        status.topAnchor.constraint(equalTo: hoursSection.topAnchor),
      ])
      
      var previousDay = status
      for timeframe in timeframes {
        let dayLabel = UILabel()
        dayLabel.text = timeframe.days
        dayLabel.textColor = .black
        let hoursLabel = UILabel()
        hoursLabel.text = timeframe.timeframeOpen[0].renderedTime
        hoursLabel.textColor = .black
        
        hoursSection.addSubview(dayLabel)
        hoursSection.addSubview(hoursLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        hoursLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          dayLabel.leadingAnchor.constraint(equalTo: hoursSection.leadingAnchor),
          dayLabel.topAnchor.constraint(equalTo: previousDay.bottomAnchor, constant: 10),
          hoursLabel.trailingAnchor.constraint(equalTo: hoursSection.trailingAnchor),
          hoursLabel.topAnchor.constraint(equalTo: dayLabel.topAnchor),
        ])
        
        previousDay = dayLabel
      }
      NSLayoutConstraint.activate([
        hoursSection.topAnchor.constraint(equalTo: elementAboveTwo!.bottomAnchor, constant: 30),
        hoursSection.centerXAnchor.constraint(equalTo: elementAbove!.centerXAnchor),
        hoursSection.heightAnchor.constraint(lessThanOrEqualToConstant: CGFloat((timeframes.count + 1) * 35)),
        hoursSection.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
        hoursSection.bottomAnchor.constraint(equalTo: previousDay.bottomAnchor)
      ])
    }
    
    let elementAboveThree = (hoursSection != nil) ? hoursSection : elementAboveTwo
    
    if (venue.contact != nil && venue.contact.phone != nil) {
      venuePhone = UIButton()
      contentView.addSubview(venuePhone)
      venuePhone.setTitle("Call Venue", for: .normal)
      venuePhone.setTitleColor(.white, for: .normal)
      venuePhone.setTitleColor(.black, for: .highlighted)
      venuePhone.titleLabel?.font = .boldSystemFont(ofSize: 20)
      venuePhone.backgroundColor = UIColor(red: 255/255, green: 151/255, blue: 80/255, alpha: 1.0)
      venuePhone.layer.cornerRadius = 10
      venuePhone.layer.masksToBounds = false
      venuePhone.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        venuePhone.topAnchor.constraint(equalTo: elementAboveThree!.bottomAnchor, constant: 25),
        venuePhone.widthAnchor.constraint(greaterThanOrEqualToConstant: 150),
        venuePhone.trailingAnchor.constraint(equalTo: imageView!.centerXAnchor, constant: -10),
        venuePhone.heightAnchor.constraint(equalToConstant: 35)
      ])
      venuePhone.addTarget(self, action: #selector(callVenue), for: .touchUpInside)
    }
    
    var elementAboveFour = (venuePhone != nil) ? venuePhone : elementAboveThree
    
    if (venue.url != nil) {
      venueWebsite = UIButton()
      contentView.addSubview(venueWebsite)
      venueWebsite.setTitle("Visit Website", for: .normal)
      venueWebsite.setTitleColor(.white, for: .normal)
      venueWebsite.setTitleColor(.black, for: .highlighted)
      venueWebsite.titleLabel?.font = .boldSystemFont(ofSize: 20)
      venueWebsite.backgroundColor = UIColor(red: 255/255, green: 151/255, blue: 80/255, alpha: 1.0)
      venueWebsite.layer.cornerRadius = 10
      venueWebsite.layer.masksToBounds = false
      venueWebsite.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        venueWebsite.topAnchor.constraint(equalTo: elementAboveThree!.bottomAnchor, constant: 25),
        venueWebsite.widthAnchor.constraint(greaterThanOrEqualToConstant: 150),
        venueWebsite.heightAnchor.constraint(equalToConstant: 35)
      ])
      if venuePhone != nil {
        venueWebsite.leadingAnchor.constraint(equalTo: imageView.centerXAnchor, constant: 10).isActive = true
      } else {
        venueWebsite.trailingAnchor.constraint(equalTo: imageView!.centerXAnchor, constant: -10).isActive = true
      }
      venueWebsite.addTarget(self, action: #selector(openWebsite), for: .touchUpInside)
      elementAboveFour = venueWebsite
    }
    
    if let tips = venue.tips, let groups = tips.groups, let allTips = groups.first {
      for tip in allTips.items {
        let tipLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 90))
        let tipText = tip.text
        tipLabel.text = "\"\(tipText!)\""
        tipLabel.textColor = .black
        tipLabel.textAlignment = .center
        tipLabel.font = .systemFont(ofSize: 16)
        tipLabel.adjustsFontSizeToFitWidth = true
        tipLabel.minimumScaleFactor = 0.75
        tipLabel.numberOfLines = 0
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        tipsViewsArray.append(tipLabel)
      }
      tipsView = UIStackView(arrangedSubviews: tipsViewsArray)
      contentView.addSubview(tipsView)
      tipsView.axis = .vertical
      tipsView.alignment = .center
      tipsView.distribution = .equalSpacing
      tipsView.spacing = 25
      tipsView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        tipsView.topAnchor.constraint(equalTo: elementAboveFour!.bottomAnchor, constant: 30),
        tipsView.centerXAnchor.constraint(equalTo: elementAbove!.centerXAnchor),
        tipsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
        tipsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
        tipsView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height)
      ])
    }

  }
  
  @IBAction func openWebsite() {
    guard let url = stateController?.selectedVenueDetails.value?.url else { return }
    UIApplication.shared.open(NSURL(string: url)! as URL)
  }
  
  @IBAction func callVenue() {
    guard let phone = stateController?.selectedVenueDetails.value?.contact.phone else { return }
    UIApplication.shared.open(NSURL(string: "tel://\(phone)")! as URL)
  }
  
  @IBAction func openMainPhoto() {
    let fullScreenVC = FullScreenPhotoView()
    fullScreenVC.photo = self.venueImage
    present(fullScreenVC, animated: true, completion: nil)
  }

}
