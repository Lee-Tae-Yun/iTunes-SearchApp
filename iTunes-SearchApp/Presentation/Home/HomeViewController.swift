//
//  ViewController.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/28/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
  private let viewModel: HomeViewModel
  private let disposeBag = DisposeBag()

  // 서치바
  private let searchController = UISearchController(searchResultsController: nil).then {
    $0.obscuresBackgroundDuringPresentation = false // 배경 흐림 제거
    $0.searchBar.placeholder = "영화, 팟캐스트"
  }

  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setUpNavigationBar()
    setUpUI()
    setUpConstraints()

    viewModel.action.accept(.loadMusic)
    bindViewModel()
  }

  private func setUpNavigationBar() {
    navigationItem.title = "Music" // 네비게이션 타이틀
    navigationController?.navigationBar.prefersLargeTitles = true // 대제목을 선호한다고 설정
    navigationItem.largeTitleDisplayMode = .automatic // 상황에 따라 large ↔︎ inline 자동 전환
    navigationItem.searchController = searchController // 이게 핵심!
    navigationItem.hidesSearchBarWhenScrolling = false // 항상 검색바 보이게
  }
  
  private func setUpUI() {

  }

  private func setUpConstraints() {

  }

  private func bindViewModel() {
    viewModel.state
      .observe(on: MainScheduler.instance) // UI 갱신은 메인 스레드에서
      .subscribe(onNext: { [weak self] state in
        print("받은 음악 데이터:", state.music)
      })
      .disposed(by: disposeBag)
  }
}
