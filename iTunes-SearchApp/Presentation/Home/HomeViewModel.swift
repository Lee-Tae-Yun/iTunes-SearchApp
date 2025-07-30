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
        var newState = self?.stateRelay.value
        newState?.music = music
        if let state = newState {
          self?.stateRelay.accept(state)
        }
      }, onError: { [weak self] error in
        var newState = self?.stateRelay.value
        newState?.errorMessage = error.localizedDescription
        if let state = newState {
          self?.stateRelay.accept(state)
        }
      })
      .disposed(by: disposeBag)
  }
}
