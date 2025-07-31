//
//  DIContainer.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/30/25.
//

import Foundation

final class DIContainer {

  // MARK: - Repository
  let musicRepository: MusicRepository
  let movieRepository: MovieRepository
  let podcastRepository: PodcastRepository

  // MARK: - UseCase
  let musicUseCase: MusicUseCase
  let searchUseCase: SearchUseCase

  init() {
    self.musicRepository = MusicRepositoryImpl()
    self.musicUseCase = MusicUseCase(repository: musicRepository)
    self.movieRepository = MovieRepositoryImpl()
    self.podcastRepository = PodcastRepositoryImpl()
    self.searchUseCase = SearchUseCase(movieRepository: self.movieRepository, podcastRepository: self.podcastRepository)
  }

  // MARK: - ViewModel
  func makeHomeViewModel() -> HomeViewModel {
    return HomeViewModel(musicUseCase: musicUseCase)
  }

  func makeSearchViewModel() -> SearchViewModel {
    return SearchViewModel(searchUseCase: searchUseCase)
  }

  // MARK: - ViewController
  func makeHomeViewController() -> HomeViewController {
    let vc = HomeViewController(viewModel: makeHomeViewModel())
    return vc
  }
}
