//
//  Copyright (c) 2022 Molotov. All rights reserved.
//

import Foundation
import Combine
import UIKit

protocol DetailsBusinessLogic {
  func fetch()
}

protocol DetailsDataStore {
  var link: String? { get set }
  var selectedPicture: UIImage? { get set }
}

final class DetailsInteractor: DetailsBusinessLogic, DetailsDataStore {

  var link: String?
  var selectedPicture: UIImage?
  var cancellable: AnyCancellable?
  let worker: DetailsWorker

  private let presenter: DetailsPresentationLogic

  init(presenter: DetailsPresentationLogic) {
    self.worker = DetailsWorker()
    self.presenter = presenter
  }

  func fetch() {
    guard let link = link, let picture = selectedPicture else { return }
    cancellable?.cancel()
    cancellable = worker.fetchDetails(link: link)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] completion in
        if case .failure(let error) = completion {
          self?.presenter.present(error)
        }
      }, receiveValue: { [weak self] photo in
        self?.presenter.present(photo, picture: picture)
      })
  }
}
