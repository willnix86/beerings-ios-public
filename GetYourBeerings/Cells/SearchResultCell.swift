//
//  SearchResultCell.swift
//  GetYourBeerings
//
//  Created by Will Nixon on 10/23/19.
//  Copyright © 2019 Will Nixon. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
  var name: UILabel!
  var address: UILabel!
  var distance: UILabel!
  var postalCode: UILabel!
  var city: UILabel!
  var country: UILabel!
  var button: UIButton!
  
  required override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.name?.text = ""
    self.address?.text = ""
    self.city?.text = ""
    self.country?.text = ""
  }
  
  func initView() {
    let imageView = UIImageView()
    self.addSubview(imageView)
    imageView.image = UIImage(named: "BottleCap")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 80),
      imageView.widthAnchor.constraint(equalToConstant: 80),
      imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20)
    ])
    
    button = UIButton()
    self.addSubview(button)
    button.setImage(UIImage(named: "OpenVenue"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.heightAnchor.constraint(equalToConstant: 25),
      button.widthAnchor.constraint(equalToConstant: 25),
      button.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
    ])
    
    name = UILabel()
    self.contentView.addSubview(name)
    name.textColor = .black
    name.textAlignment = .center
    name.adjustsFontSizeToFitWidth = true
    name.minimumScaleFactor = 0.5
    name.numberOfLines = 2
    name.font = .boldSystemFont(ofSize: 20)
    name.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      name.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      name.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
      name.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20),
      name.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: -20)
    ])
    
    distance = UILabel()
    self.contentView.addSubview(distance)
    distance.textColor = .black
    distance.textAlignment = .center
    distance.font = .boldSystemFont(ofSize: 13)
    distance.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      distance.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      distance.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
      distance.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20),
      distance.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: -20)
    ])
    
    let addressView = UIView()
    self.contentView.addSubview(addressView)
    addressView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      addressView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      addressView.topAnchor.constraint(equalTo: distance.bottomAnchor, constant: 10),
      addressView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
      addressView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20),
      addressView.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: -20)
    ])
    
    country = UILabel()
    addressView.addSubview(country)
    country.textColor = .black
    country.textAlignment = .center
    country.adjustsFontSizeToFitWidth = true
    country.minimumScaleFactor = 0.5
    country.numberOfLines = 1
    country.font = .systemFont(ofSize: 15)
    country.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      country.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      country.bottomAnchor.constraint(equalTo: addressView.bottomAnchor),
      country.leadingAnchor.constraint(greaterThanOrEqualTo: addressView.leadingAnchor),
      country.trailingAnchor.constraint(greaterThanOrEqualTo: addressView.trailingAnchor)
    ])
    
    city = UILabel()
    addressView.addSubview(city)
    city.textColor = .black
    city.textAlignment = .center
    city.adjustsFontSizeToFitWidth = true
    city.minimumScaleFactor = 0.5
    city.numberOfLines = 1
    city.font = .systemFont(ofSize: 15)
    city.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      city.centerXAnchor.constraint(equalTo: addressView.centerXAnchor),
      city.bottomAnchor.constraint(equalTo: country.topAnchor, constant: -5),
      city.leadingAnchor.constraint(greaterThanOrEqualTo: addressView.leadingAnchor),
      city.trailingAnchor.constraint(greaterThanOrEqualTo: addressView.trailingAnchor)
    ])
    
    address = UILabel()
    addressView.addSubview(address)
    address.textColor = .black
    address.textAlignment = .center
    address.adjustsFontSizeToFitWidth = true
    address.minimumScaleFactor = 0.5
    address.numberOfLines = 1
    address.font = .systemFont(ofSize: 15)
    address.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      address.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      address.bottomAnchor.constraint(equalTo: city.topAnchor, constant: -5),
      address.leadingAnchor.constraint(greaterThanOrEqualTo: addressView.leadingAnchor),
      address.trailingAnchor.constraint(greaterThanOrEqualTo: addressView.trailingAnchor)
    ])
  
  }
}
