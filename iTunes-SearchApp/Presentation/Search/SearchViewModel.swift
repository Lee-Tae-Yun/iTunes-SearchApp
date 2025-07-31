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

    private let stateRelay = BehaviorRelay<State>(value: State())
    private let disposeBag = DisposeBag()
    private let searchUseCase:SearchUseCase

    init(searchUseCase: SearchUseCase) {
      self.searchUseCase = searchUseCase
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
