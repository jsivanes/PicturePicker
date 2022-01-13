//
// Copyright (c) 2022  All rights reserved.
// 

import Foundation
import Combine

public extension URLRequest {
  enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
  }
}

public enum ApiRoute {
  case today
  case details(String)
  case link(String)
  case search

  var path: String {
    switch self {
    case .today: return "\(Environment.basePath)/photos"
    case .details(let id): return "\(Environment.basePath)/photos/\(id)"
    case .link(let value): return value
    case .search: return "\(Environment.basePath)/search/photos"
    }
  }
}

public enum NetworkError: Error {
  case decodeError
  case urlError
  case badResponse
  case failure

  var message: String {
      return "Impossible de se connecter au service."
  }
}

struct CustomDecoder {
  var decoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }
}

public protocol NetworkClient {
  func request<T: Decodable>(route: ApiRoute, method: URLRequest.HTTPMethod, parameters: [String: String]?) -> AnyPublisher<T, NetworkError>
}

extension NetworkClient {
  func request<T: Decodable>(route: ApiRoute, method: URLRequest.HTTPMethod, parameters: [String: String]?) -> AnyPublisher<T, NetworkError> {
    guard var urlComponent = URLComponents(string: route.path) else {
      return Fail(error: NetworkError.urlError).eraseToAnyPublisher()
    }
    let queryItems = parameters?.map({ URLQueryItem(name: $0.key, value: $0.value) })
    urlComponent.queryItems = queryItems

    guard let url = urlComponent.url else {
      return Fail(error: NetworkError.urlError).eraseToAnyPublisher()
    }

    var request = URLRequest(url: url)
    request.addValue("v1", forHTTPHeaderField: "Accept-Version")
    request.addValue("Client-ID \(Environment.accesToken)", forHTTPHeaderField: "Authorization")
    let urlSession = URLSession.shared
    return urlSession
      .dataTaskPublisher(for: request)
      .tryMap() { element -> Data in
        guard let httpResponse = element.response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
                print(String(data: element.data, encoding: .utf8) ?? "")
                throw NetworkError.badResponse
              }
        return element.data
      }
      .decode(type: T.self, decoder: CustomDecoder().decoder)
      .mapError({ error -> NetworkError in
        print(error)
        if let networkError = error as? NetworkError {
          return networkError
        } else if (error as? DecodingError) != nil {
          return NetworkError.decodeError
        } else {
          return NetworkError.failure
        }
      })
      .eraseToAnyPublisher()
  }
}
