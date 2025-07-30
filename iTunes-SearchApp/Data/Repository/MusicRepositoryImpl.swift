//
//  MusicRepositoryImpl.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/28/25.
//
import RxSwift

final class MusicRepositoryImpl: MusicRepository {
  private let apiService = APIService()

  func fetchMusic(query: String) -> Observable<[Music]> {
    let url = "https://itunes.apple.com/search"
    let parameters = [
      "term": query,
      "media": "music"
    ]

    return apiService.fetch(url: url, parameters: parameters)
      .map { (response: MusicResponse) in
        response.results
      }
  }
}
