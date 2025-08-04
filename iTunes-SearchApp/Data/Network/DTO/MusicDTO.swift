//
//  MusicDTO.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 8/4/25.
//
struct MusicResponseDTO: Decodable {
  let results: [MusicDTO]
}

struct MusicDTO: Decodable {
  let trackName: String       // 곡 제목
  let artistName: String      // 아티스트 이름
  let collectionName: String?  // 앨범 이름
  let artworkUrl100: String   // 썸네일
  let artworkUrl512: String?   // 썸네일 512X512
  let previewUrl: String      // 미리 듣기 URL

  func toDomain() -> Music {
    return Music(
      trackName: trackName,
      artistName: artistName,
      collectionName: collectionName,
      artworkUrl100: artworkUrl100,
      artworkUrl512: artworkUrl100.replacingOccurrences(of: "100x100", with: "512x512"),
      previewUrl: previewUrl
    )
  }
}
