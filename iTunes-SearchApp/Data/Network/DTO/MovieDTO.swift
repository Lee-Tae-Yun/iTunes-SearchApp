//
//  MovieDTO.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 8/4/25.
//
import Foundation

struct MovieResponseDTO: Decodable {
  let results: [MovieDTO]
}

struct MovieDTO: Decodable {
  let trackName: String         // 영화 제목
  let artistName: String        // 감독 또는 제작자
  let longDescription: String   // 영화 설명
  let primaryGenreName: String  // 장르
  let releaseDate: String       // 출시일
  let artworkUrl100: String     // 포스터 썸네일
  let artworkUrl512: String?    // 포스터 썸네일 512X512

  func toDomain() -> Movie {
    return Movie(
      trackName: trackName,
      artistName: artistName,
      longDescription: longDescription,
      primaryGenreName: primaryGenreName,
      releaseDate: formattedDate(from: releaseDate),
      artworkUrl100: artworkUrl100,
      artworkUrl512: artworkUrl100.replacingOccurrences(of: "100x100", with: "512x512")
    )
  }

  private func formattedDate(from string: String) -> String {
    let formatter = ISO8601DateFormatter()
    guard let date = formatter.date(from: string) else {
      return "날짜 정보 없음"
    }

    let displayFormatter = DateFormatter()
    displayFormatter.dateFormat = "yyyy-MM-dd"
    return displayFormatter.string(from: date)
  }
}
