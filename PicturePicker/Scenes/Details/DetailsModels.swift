//
//  Copyright (c) 2022 Molotov. All rights reserved.
//

import Foundation
import UIKit

enum DetailsScene {

  struct ViewModel: Equatable {
    let items: [Item]
    let views:  Int
    let downloads: Int
  }

  struct Item: Hashable {
    let id = UUID()
    let picture: String?
    let pictureImage: UIImage?
  }
}
