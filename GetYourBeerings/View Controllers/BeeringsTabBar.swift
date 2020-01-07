//
//  BeeringsTabBarController.swift
//  Get Your Beerings
//
//  Created by Will Nixon on 10/19/19.
//  Copyright © 2019 Will Nixon. All rights reserved.
//

import UIKit

class BeeringsTabBar: UITabBarController {
  
  let mapVC = MapView()
  let resultsVC = ResultsView()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let mapItem = UITabBarItem()
    mapItem.image = UIImage(named: "map")
    mapItem.title = "Map"
    mapVC.tabBarItem = mapItem
    
    let resItem = UITabBarItem()
    resItem.image = UIImage(named: "results")
    resItem.title = "Results"
    resultsVC.tabBarItem = resItem
    
    self.viewControllers = [mapVC, resultsVC]
    self.selectedViewController = mapVC
    self.tabBar.barTintColor = UIColor(red: 255/255, green: 226/255, blue: 147/255, alpha: 1)
    self.tabBar.tintColor = .black
  }

}
