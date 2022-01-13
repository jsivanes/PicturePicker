// Copyright (c) 2022  All rights reserved.
// 

import Foundation
import Combine

class TodayWorker: NetworkClient {

  var cancellable: AnyCancellable?

  func fetch() -> AnyPublisher<[Photo], NetworkError> {
    let parameters = [
      "per_page":"50"
    ]
    return request(route: .today, method: .get, parameters: parameters)
  }
}
