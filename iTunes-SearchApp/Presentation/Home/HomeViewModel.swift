//
//  HomeViewModel.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/28/25.
//
import RxSwift
import RxRelay

final class HomeViewModel {
  let action = PublishRelay<Action>()
  var state: Observable<State> {
    stateRelay.asObservable()
  }
  
  var currentState: State {
    return stateRelay.value
  }

  private let stateRelay = BehaviorRelay<State>(value: State())
  private let disposeBag = DisposeBag()
  private let musicUseCase: MusicUseCase

  init(musicUseCase: MusicUseCase) {
    self.musicUseCase = musicUseCase
    bind()
  }

  enum Action {
    case loadMusic
  }

  struct State {
    var music: [String: [Music]] = [:]
    var errorMessage: String?
  }

  private func handle(_ action: Action) {
    switch action {
    case .loadMusic:
      fetchMusic()
    }
  }

  private func bind() {
    action
      .subscribe(onNext: { [weak self] action in
        self?.handle(action)
      })
      .disposed(by: disposeBag)
  }

  private func fetchMusic() {
    musicUseCase.fetch()
      .subscribe(onNext: { [weak self] music in
        guard var newState = self?.stateRelay.value else { return }
        newState.music = music
        self?.stateRelay.accept(newState)
      }, onError: { [weak self] error in
        guard var newState = self?.stateRelay.value else { return }
        newState.errorMessage = error.localizedDescription
        self?.stateRelay.accept(newState)
      })
      .disposed(by: disposeBag)
  }
}
