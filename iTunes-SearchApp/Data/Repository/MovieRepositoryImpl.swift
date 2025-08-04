//
//  MovieRepositoryImpl.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/30/25.
//
import RxSwift

final class MovieRepositoryImpl: MovieRepository {
  private let apiService = APIService()

  func fetchMovie(query: String) -> Observable<[Movie]> {
    let url = "https://itunes.apple.com/search"
    let parameters = [
      "term": query,
      "media": "movie"
    ]

    return apiService.fetch(url: url, parameters: parameters)
      .map { (response: MovieResponseDTO) in
        response.results.map { $0.toDomain() }
      }
  }
}
