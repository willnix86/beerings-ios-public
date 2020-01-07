//
//  PhotosView.swift
//  GetYourBeerings
//
//  Created by Will Nixon on 11/7/19.
//  Copyright © 2019 Will Nixon. All rights reserved.
//

import UIKit

class PhotosView: UIViewController {
  
  var stateController: StateController!
  var venuePhotos: [Item] = []
  var collectionView: UICollectionView!
  let sectionInsets = UIEdgeInsets(top: 15.0, left: 20.0, bottom: 15.0, right: 20.0)
  let itemsPerRow: CGFloat = 2

  override func viewDidLoad() {
    super.viewDidLoad()
    initViews()
  }
  
  func initViews() {
    let contentView = UIView()
    self.view.addSubview(contentView)
    contentView.backgroundColor = .clear
    contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: self.view.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      contentView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      contentView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
    ])
    
    let photos = stateController.selectedVenuePhotos
    for photo in photos {
      self.venuePhotos.append(photo)
    }
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 150, height: 300)
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
    collectionView.backgroundColor = UIColor(red: 254/255, green: 225/255, blue: 147/255, alpha: 1.0)
    contentView.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
      collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }

}

extension PhotosView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.venuePhotos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath as IndexPath) as! PhotoCell
    let photo = self.venuePhotos[indexPath.item]
    var preffix = "https://fastly.4sqi.net/img/general/"
    if let suffix = photo.suffix, let width = photo.width, let height = photo.height {
      if let itemPrefix = photo.itemPrefix {
        preffix = itemPrefix
      }
      let urlString = "\(preffix)\(width)x\(height)\(suffix)"
      if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
          if let image = UIImage(data: data) {
            cell.imageView.image = image
          }
        }
      }
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
    guard let imageView = cell.imageView else { return }
    let newImageView = UIImageView(image: imageView.image)
    newImageView.frame = UIScreen.main.bounds
    newImageView.backgroundColor = .black
    newImageView.contentMode = .scaleAspectFit
    
    let fsVC = UIViewController()
    fsVC.view.addSubview(newImageView)
    present(fsVC, animated: true, completion: nil)
  }
  
}

extension PhotosView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
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
    return sectionInsets
  }
  
}

