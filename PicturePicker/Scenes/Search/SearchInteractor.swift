//
//  Copyright (c) 2022 Molotov. All rights reserved.
//

import Foundation
import Combine

protocol SearchBusinessLogic {
  func fetch(_ text: String)
}

protocol SearchDataStore { }

final class SearchInteractor: SearchBusinessLogic, SearchDataStore {

  private let presenter: SearchPresentationLogic
  private let worker: SearchWorker
  private var cancellable: AnyCancellable?

  init(presenter: SearchPresentationLogic) {
    self.worker = SearchWorker()
    self.presenter = presenter
  }

  func fetch(_ text: String) {
    cancellable?.cancel()
    cancellable = worker.fetch(text: text)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: {[weak self] completion in
        if case .failure(let error) = completion {
          self?.presenter.present(error)
        }
      }, receiveValue: {[weak self] searchValue in
        self?.presenter.present(searchValue.results)
      })
  }
}
