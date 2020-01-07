//
// SortOptionsView.swift
//  GetYourBeerings
//
//  Created by Will Nixon on 10/24/19.
//  Copyright © 2019 Will Nixon. All rights reserved.
//

import UIKit
import RadioGroup

class SortOptionsView: UIView {
  var title: String!
  var options: [String]!
  var radioGroup: RadioGroup!
  
  convenience init(title: String, options: [String]) {
    self.init()
    self.title = title
    self.options = options
    initViews()
  }
  
  func initViews() {
    let sortTitle = UILabel()
    self.addSubview(sortTitle)
    sortTitle.text = self.title
    sortTitle.textAlignment = .center
    sortTitle.textColor = .black
    sortTitle.font = .boldSystemFont(ofSize: 18)
    sortTitle.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      sortTitle.topAnchor.constraint(equalTo: self.topAnchor),
      sortTitle.heightAnchor.constraint(equalToConstant: 20),
      sortTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      sortTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      sortTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
    
    radioGroup = RadioGroup(titles: self.options)
    self.addSubview(radioGroup)
    radioGroup.selectedIndex = 0
    radioGroup.isVertical = false
    radioGroup.isButtonAfterTitle = false
    radioGroup.tintColor = UIColor(red: 252/255, green: 126/255, blue: 42/255, alpha: 1.0)
    radioGroup.titleColor = .black
    radioGroup.buttonSize = 22.0
    radioGroup.spacing = 12
    radioGroup.itemSpacing = 8
    radioGroup.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      radioGroup.topAnchor.constraint(equalTo: sortTitle.bottomAnchor, constant: 10),
      radioGroup.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      radioGroup.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75)
    ])
  }
}
