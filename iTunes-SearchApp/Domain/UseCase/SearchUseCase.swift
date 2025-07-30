//
//  SearchUseCase.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/28/25.
//
import RxSwift
struct SearchResult {
  let movies: [Movie]
  let podcasts: [Podcast]
}

final class SearchUseCase {
  private let movieRepository: MovieRepository
  private let podcastRepository: PodcastRepository

  init(movieRepository: MovieRepository, podcastRepository: PodcastRepository) {
    self.movieRepository = movieRepository
    self.podcastRepository = podcastRepository
  }

  func search(query: String) -> Observable<SearchResult> {
    let movieObs = movieRepository.fetchMovie(query: query)
    let podcastObs = podcastRepository.fetchPodcast(query: query)

    return Observable.zip(movieObs, podcastObs)
      .map { SearchResult(movies: $0, podcasts: $1) }
  }
}
