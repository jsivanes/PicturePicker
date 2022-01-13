// Copyright (c) 2022  All rights reserved.
// 

import Foundation

struct Photo: Decodable {
  let id: String
  let urls: Urls
  let links: Links
  let likes: Int
  let description: String?
  let user: User
  let relatedCollections: RelatedPhotos?
  let views: Int?
  let downloads: Int?
}

struct Urls: Decodable {
  let raw: String?
  let full: String?
  let regular: String?
  let small: String?
  let medium: String?
  let large: String?
}

struct Links: Decodable {
  enum CodingKeys: String, CodingKey {
    case detail = "self"
    case photos
  }
  let detail: String
  let photos: String?
}

struct User: Decodable {
  let id: String
  let username: String
  let name: String?
  let firstName: String?
  let lastName: String?
  let bio: String?
  let links: Links
  let profileImage: Urls
}

struct RelatedPhotos: Decodable {
  let results: [Collection]
}

struct Collection: Decodable {
  let coverPhoto: Photo
}

struct SearchResult: Decodable {
  let total: Int
  let results: [Photo]
}
