//
// Created 13/01/2022
// 

import Foundation
import Combine

class SearchWorker: NetworkClient {

  func fetch(text: String) -> AnyPublisher<SearchResult, NetworkError> {
    let parameters = [
      "query": text,
      "per_page": "50",
      "orientation": "portrait"
    ]
    return request(route: .search, method: .get, parameters: parameters)
  }
}
