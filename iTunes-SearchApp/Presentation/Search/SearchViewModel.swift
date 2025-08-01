//
//  SearchViewModel.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/28/25.
//
import RxSwift
import RxRelay

final class SearchViewModel {
  let action = PublishRelay<Action>()
  var state: Observable<State> {
    stateRelay.asObservable()
  }

  var currentState: State {
    return stateRelay.value
  }

  private let stateRelay = BehaviorRelay<State>(value: State())
  private let disposeBag = DisposeBag()
  private let searchUseCase:SearchUseCase

  init(searchUseCase: SearchUseCase) {
    self.searchUseCase = searchUseCase
    bind()
  }

  enum Action {
    case search(String)
  }

  struct State {
    var movieresults: [Movie] = []
    var podcastresults: [Podcast] = []
    var searchResult: [SearchResult] = []
    var errorMessage: String?
  }

  private func handle(_ action: Action) {
    switch action {
    case .search(let query):
      fetchSearch(for: query)
    }
  }

  private func bind() {
    action
      .subscribe(onNext: { [weak self] action in
        self?.handle(action)
      })
      .disposed(by: disposeBag)
  }

  private func fetchSearch(for query: String) {
    searchUseCase.search(query: query)
      .subscribe(onNext: { [weak self] results in
        guard var newState = self?.stateRelay.value else { return }
        newState.movieresults = results.movies
        newState.podcastresults = results.podcasts
        newState.searchResult = [results]
        self?.stateRelay.accept(newState)
      }, onError: { [weak self] error in
        guard var newState = self?.stateRelay.value else { return }
        newState.errorMessage = error.localizedDescription
        self?.stateRelay.accept(newState)
      })
      .disposed(by: disposeBag)
  }

}
