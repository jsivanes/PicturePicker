//
//  Copyright (c) 2022 Molotov. All rights reserved.
//

import Foundation
import UIKit

protocol DetailsPresentationLogic {
  func present(_ photo: Photo, picture: UIImage)
  func present(_ error: NetworkError)
}

final class DetailsPresenter: DetailsPresentationLogic {

  private weak var display: DetailsDisplayLogic?

  init(display: DetailsDisplayLogic?) {
    self.display = display
  }

  func present(_ photo: Photo, picture: UIImage) {
    var items = [DetailsScene.Item]()
    items.append(DetailsScene.Item(picture: nil, pictureImage: picture))
    if let related = photo.relatedCollections {
      items.append(contentsOf:
                    related.results
                    .compactMap({ $0.coverPhoto.urls.small })
                    .map({ DetailsScene.Item(picture: $0, pictureImage: nil)}))
    }
    display?.display(DetailsScene
                      .ViewModel(items: items,
                                 views: photo.views ?? 0,
                                 downloads: photo.downloads ?? 0))
  }

  func present(_ error: NetworkError) {
    display?.display(error.message)
  }
}
