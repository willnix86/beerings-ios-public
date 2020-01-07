//
//  RatingIcon.swift
//  GetYourBeerings
//
//  Created by Will Nixon on 11/3/19.
//  Copyright © 2019 Will Nixon. All rights reserved.
//

import UIKit

class RatingIcon: UIView {
  var ratingImageName: String!
  
  convenience init(ratingImage: String){
    self.init()
    self.ratingImageName = ratingImage
    initView()
  }
  
  func initView() {
    let ratingImage = UIImageView(image: UIImage(named: self.ratingImageName))
    ratingImage.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratingImage.widthAnchor.constraint(equalToConstant: 25),
      ratingImage.heightAnchor.constraint(equalToConstant: 25)
    ])
    self.addSubview(ratingImage)
  }

}
