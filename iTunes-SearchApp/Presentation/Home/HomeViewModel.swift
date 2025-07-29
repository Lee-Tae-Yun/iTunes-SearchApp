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

  init() {
    bind()
  }

  enum Action {

  }

  struct State {

  }

  private func handle(_ action: Action) {
    switch action {

    }
  }

  private func bind() {
    action
      .subscribe(onNext: { [weak self] action in
        self?.handle(action)
      })
      .disposed(by: disposeBag)
  }
}
