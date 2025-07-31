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
  let trackName: String       // 곡 제목
  let artistName: String      // 아티스트 이름
  let collectionName: String?  // 앨범 이름
  let artworkUrl100: String   // 썸네일
  let previewUrl: String      // 미리 듣기 URL
}
