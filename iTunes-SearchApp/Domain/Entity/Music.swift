//
//  Music.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/28/25.
//
struct MusicResponse: Decodable {
  let resultCount: Int
  let results: [Music]
}

struct Music: Decodable {
  let artistName: String
  let collectionName: String
  let trackName: String
  let artworkUrl100: String
}
