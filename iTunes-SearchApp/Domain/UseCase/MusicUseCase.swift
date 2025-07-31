//
//  MusicUseCase.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/30/25.
//
import RxSwift

final class MusicUseCase {
  private let repository: MusicRepository
  private let keywords = ["봄", "여름", "가을", "겨울"]

  init(repository: MusicRepository) {
    self.repository = repository
  }

  func fetch() -> Observable<[String: [Music]]> {
    let requests = keywords.map { keyword in
      repository.fetchMusic(query: keyword).map { (keyword, $0) }
    }

    return Observable.zip(requests)
      .map { Dictionary(uniqueKeysWithValues: $0) }
  }
}
