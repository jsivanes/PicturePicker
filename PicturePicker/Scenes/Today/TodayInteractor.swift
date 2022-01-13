//
//  Copyright (c) 2022 Molotov. All rights reserved.
//

import Foundation
import Combine

protocol TodayBusinessLogic {
  func fetch()
}

protocol TodayDataStore { }

final class TodayInteractor: TodayBusinessLogic, TodayDataStore {

  var presenter: TodayPresentationLogic?
  private let worker: TodayWorker

  var cancellable: AnyCancellable?

  init(presenter: TodayPresentationLogic) {
    worker = TodayWorker()
    self.presenter = presenter
  }

  func fetch() {
    cancellable = worker.fetch()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
      if case .failure(let error) = completion {
        self?.presenter?.present(error)
      }
    } receiveValue: { [weak self] photos in
      self?.presenter?.present(photos)
    }

  }
}
