//
// Copyright (c) 2022  All rights reserved.
// 

import Foundation
import Combine

final class DetailsWorker: NetworkClient {

  func fetchDetails(link: String) -> AnyPublisher<Photo, NetworkError> {
    return request(route: .link(link), method: .get, parameters: nil)
  }
}
