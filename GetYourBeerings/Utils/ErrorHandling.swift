//
//  ErrorHandling.swift
//  Get Your Beerings
//
//  Created by Will Nixon on 10/22/19.
//  Copyright © 2019 Will Nixon. All rights reserved.
//

import Foundation
import UIKit

class ErrorManager {
  
  class func showAlert(title: String?, message: String?, vc: UIViewController?) {
    var error: UIAlertController!

    error = UIAlertController(
      title: title ?? "Error",
      message: message ?? "",
      preferredStyle: .alert
    )
    error.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
      error.dismiss(animated: true, completion: nil)
    }))
    vc?.present(error, animated: true, completion: nil)
  }
  
}
