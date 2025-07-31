//
//  Podcast.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/30/25.
//
struct PodcastResponse: Decodable {
  let resultCount: Int
  let results: [Podcast]
}

struct Podcast: Decodable {
  let collectionName: String    // 팟캐스트 이름
  let artistName: String        // 제작자
  let feedUrl: String           // RSS 피드 주소
  let releaseDate: String       // 최근 업데이트 날자
  let artworkUrl100: String     // 썸네일
  let primaryGenreName: String  // 장르

  var artworkUrl512: String {
    return artworkUrl100.replacingOccurrences(of: "100x100", with: "512x512")
  }
}
