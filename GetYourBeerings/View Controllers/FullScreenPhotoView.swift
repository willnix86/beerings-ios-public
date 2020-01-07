import UIKit

class FullScreenPhotoView: UIViewController {
  var imageView: UIImageView!
  var scrollView: UIScrollView!
  var imageViewBottomConstraint: NSLayoutConstraint!
  var imageViewLeadingConstraint: NSLayoutConstraint!
  var imageViewTopConstraint: NSLayoutConstraint!
  var imageViewTrailingConstraint: NSLayoutConstraint!
  var photo: UIImage!
  
  override func viewDidLoad() {
    self.view.backgroundColor = .black
    scrollView = UIScrollView()
    self.view.addSubview(scrollView)
    scrollView.delegate = self
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
    ])
    
    imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    if let photo = photo {
      imageView.image = photo
    }
    scrollView.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
    imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
    imageViewLeadingConstraint = imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
    imageViewTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
    NSLayoutConstraint.activate([
      imageViewTopConstraint,
      imageViewBottomConstraint,
      imageViewLeadingConstraint,
      imageViewTrailingConstraint,
    ])
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    updateMinZoomScaleForSize(view.bounds.size)
    updateConstraintsForSize(view.bounds.size)
  }
}

//MARK:- Sizing
extension FullScreenPhotoView {
  func updateMinZoomScaleForSize(_ size: CGSize) {
    if let image = imageView.image {
      let widthScale = size.width / image.size.width
      let heightScale = size.height / image.size.height
      let minScale = min(widthScale, heightScale)
      scrollView.minimumZoomScale = minScale
      scrollView.zoomScale = minScale
    }
  }
  
  func updateConstraintsForSize(_ size: CGSize) {
    let yOffset = max(0, (size.height - scrollView.contentSize.height) / 2)
    imageViewTopConstraint.constant = yOffset
    imageViewBottomConstraint.constant = yOffset

    let xOffset = max(0, (size.width - scrollView.contentSize.width) / 2)
    imageViewLeadingConstraint.constant = xOffset
    imageViewTrailingConstraint.constant = xOffset
    
    view.layoutIfNeeded()
  }
}

//MARK:- UIScrollViewDelegate
extension FullScreenPhotoView: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    updateConstraintsForSize(view.bounds.size)
  }
}
