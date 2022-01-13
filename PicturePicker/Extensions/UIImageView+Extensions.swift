//
// Copyright (c) 2022  All rights reserved.
// 

import UIKit

extension UIImageView {
  func load(str: String) {
    if let url = URL(string: str) {
      let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else { return }

        DispatchQueue.main.async {
          self.image = UIImage(data: data)
        }
      }

      task.resume()
    }
  }
}
