//
//  Movie.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/30/25.
//
struct MovieResponse: Decodable {
  let resultCount: Int
  let results: [Movie]
}

struct Movie: Decodable {
  let TrackName: String         // 영화 제목
  let artistName: String        // 감독 또는 제작자
  let longDescription: String   // 영화 설명
  let primaryGenreName: String  // 장르
  let releaseDate: String       // 출시일
  let artworkUrl100: String     // 포스터 썸네일
  let previewUrl: String        // 예고편 URL
}
