//
//  SearchBarWithPrompt.swift
//  Get Your Beerings
//
//  Created by Will Nixon on 10/20/19.
//  Copyright © 2019 Will Nixon. All rights reserved.
//

import UIKit

class SearchBarWithPrompt: UIView {
  var prompt: UILabel!
  var promptText: String!
  var searchBar: UISearchBar!
  var cancelButton: UIButton!
  
  convenience init(prompt: String) {
    self.init()
    self.promptText = prompt
    initView()
  }
  
  func initView() {
    prompt = UILabel()
    prompt.text = promptText!
    prompt.textColor = .black
    prompt.textAlignment = .center
    prompt.adjustsFontSizeToFitWidth = true
    prompt.numberOfLines = 1
    self.addSubview(prompt)
    prompt.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      prompt.topAnchor.constraint(equalTo: self.topAnchor),
      prompt.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      prompt.heightAnchor.constraint(equalToConstant: 30),
      prompt.widthAnchor.constraint(equalTo: self.widthAnchor)
    ])
    
    searchBar = UISearchBar()
    searchBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    searchBar.searchTextField.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
    searchTextField?.textColor = .black
    self.addSubview(searchBar)
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: prompt.bottomAnchor, constant: 5),
      searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      searchBar.heightAnchor.constraint(equalToConstant: 40)
    ])

  }

}
