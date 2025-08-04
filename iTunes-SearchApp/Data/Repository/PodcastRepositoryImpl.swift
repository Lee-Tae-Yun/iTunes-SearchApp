//
//  PodcastRepositoryImpl.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/30/25.
//
import RxSwift

final class PodcastRepositoryImpl: PodcastRepository {
  private let apiService = APIService()

  func fetchPodcast(query: String) -> Observable<[Podcast]> {
    let url = "https://itunes.apple.com/search"
    let parameters = [
      "term": query,
      "media": "podcast"
    ]

    return apiService.fetch(url: url, parameters: parameters)
      .map { (response: PodcastResponseDTO) in
        response.results.map { $0.toDomain() }
      }
  }
}
