//
// Created 13/01/2022
// 

import Foundation

struct Picture: Identifiable, Hashable {
  let id: String
  let picture: String?
  let detailLinks: String
  let description: String?
  let userName: String
  let userPicture: String?
  let likes: Int
  }
