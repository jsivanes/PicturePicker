//
//  Copyright (c) 2022 Molotov. All rights reserved.
//

import Foundation

protocol SearchPresentationLogic {
  func present(_ photos: [Photo])
  func present(_ error: NetworkError)
}

final class SearchPresenter: SearchPresentationLogic {

  private weak var display: SearchDisplayLogic?

  init(display: SearchDisplayLogic?) {
    self.display = display
  }

  func present(_ photos: [Photo]) {
    let todayPhotos = photos.map({
      Picture(id: $0.id,
              picture: $0.urls.regular,
              detailLinks: $0.links.detail,
              description: $0.description,
              userName: $0.user.username,
              userPicture: $0.user.profileImage.large,
              likes: $0.likes
      ) })
    let model = SearchScene.ViewModel(picture: todayPhotos)
    display?.display(model)
  }

  func present(_ error: NetworkError) {
    display?.display(error.message)
  }
}
