//
//  PodcastDTO.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 8/4/25.
//
import Foundation

struct PodcastResponseDTO: Decodable {
  let results: [PodcastDTO]
}

struct PodcastDTO: Decodable {
  let collectionName: String    // 팟캐스트 이름
  let artistName: String        // 제작자
  let releaseDate: String?      // 최근 업데이트 날자
  let artworkUrl100: String     // 썸네일
  let artworkUrl512: String?    // 썸네일 512X512
  let primaryGenreName: String? // 장르

  func toDomain() -> Podcast {
    return Podcast(
      collectionName: collectionName,
      artistName: artistName,
      releaseDate: formattedDate(from: releaseDate),
      artworkUrl100: artworkUrl100,
      artworkUrl512: artworkUrl100.replacingOccurrences(of: "100x100", with: "512x512"),
      primaryGenreName: primaryGenreName
    )
  }

  private func formattedDate(from string: String?) -> String? {
    guard let string = string else { return nil }
    let formatter = ISO8601DateFormatter()
    guard let date = formatter.date(from: string) else {
      return "날짜 정보 없음"
    }

    let displayFormatter = DateFormatter()
    displayFormatter.dateFormat = "yyyy-MM-dd"
    return displayFormatter.string(from: date)
  }
}
