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
  private lazy var searchTextRelay = BehaviorRelay<String>(value: "")

  let container = DIContainer()
  lazy var searchResultsVC = container.makeSearchViewController(query: self.searchTextRelay)
  // 서치바
  lazy var searchController = UISearchController(searchResultsController: searchResultsVC).then {
    $0.obscuresBackgroundDuringPresentation = false // 배경 흐림 제거
    $0.searchBar.placeholder = "영화, 팟캐스트"
  }

  private lazy var musicCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
    $0.backgroundColor = .systemBackground
    $0.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
    $0.register(SpringViewCell.self, forCellWithReuseIdentifier: SpringViewCell.identifier)
    $0.register(SummerViewCell.self, forCellWithReuseIdentifier: SummerViewCell.identifier)
    $0.register(AutumnViewCell.self, forCellWithReuseIdentifier: AutumnViewCell.identifier)
    $0.register(WinterViewCell.self, forCellWithReuseIdentifier: WinterViewCell.identifier)

    $0.showsVerticalScrollIndicator = false
  }

  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setUpNavigationBar()
    setUI()
    setConstraints()
    musicCollectionView.dataSource = self

    viewModel.action.accept(.loadMusic)
    bindViewModel()

    searchController.searchBar.rx.text.orEmpty
      .bind(to: searchTextRelay)
      .disposed(by: disposeBag)
  }

  private func setUpNavigationBar() {
    navigationItem.title = "Music" // 네비게이션 타이틀
    navigationController?.navigationBar.prefersLargeTitles = true // 대제목을 선호한다고 설정
    navigationItem.largeTitleDisplayMode = .automatic // 상황에 따라 large, inline 자동 전환
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false // 항상 검색바 보이게
  }

  // MARK: - SetUPUI
  private func setUI() {
    [musicCollectionView].forEach {view.addSubview($0) }
  }

  private func setConstraints() {
    musicCollectionView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func bindViewModel() {
    viewModel.state
      .observe(on: MainScheduler.instance) // UI 갱신은 메인 스레드에서
      .subscribe(onNext: { state in
        print("받은 음악 데이터:", state.music)
        self.musicCollectionView.reloadData()
      })
      .disposed(by: disposeBag)
  }

  private func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { sectionIndex, environment in
      switch sectionIndex {
      case 0:
        return self.springSectionLayout()
      case 1:
        return self.summerSectionLayout()
      case 2:
        return self.autumnSectionLayout()
      case 3:
        return self.winterSectionLayout()
      default:
        return self.springSectionLayout()
      }
    }
  }
  // 카드형
  private func springSectionLayout() -> NSCollectionLayoutSection {
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(380))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [header]
    section.orthogonalScrollingBehavior = .groupPagingCentered
    section.interGroupSpacing = 16
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
    return section
  }

  // 세로 리스트형
  private func summerSectionLayout() -> NSCollectionLayoutSection {
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / 3.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 3)
    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [header]
    section.orthogonalScrollingBehavior = .groupPagingCentered
    section.interGroupSpacing = 8
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
    return section
  }

  private func autumnSectionLayout() -> NSCollectionLayoutSection {
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / 3.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 3)
    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [header]
    section.orthogonalScrollingBehavior = .groupPagingCentered
    section.interGroupSpacing = 8
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
    return section
  }

  private func winterSectionLayout() -> NSCollectionLayoutSection {
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / 3.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 3)
    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [header]
    section.orthogonalScrollingBehavior = .groupPagingCentered
    section.interGroupSpacing = 8
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
    return section
  }
}


// MARK: - DataSource
extension HomeViewController: UICollectionViewDataSource {
  // 섹션 수
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 4
  }

  // 섹션별 셀 수
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0:
      return viewModel.currentState.music["봄"]?.count ?? 0
    case 1:
      return viewModel.currentState.music["여름"]?.count ?? 0
    case 2:
      return viewModel.currentState.music["가을"]?.count ?? 0
    case 3:
      return viewModel.currentState.music["겨울"]?.count ?? 0
    default:
      return 0
    }
  }

  // 헤더
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionHeader else {
      return UICollectionReusableView()
    }

    guard let header = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as? HeaderView else {
      print("❌ HeaderView 타입 캐스팅 실패")
      return UICollectionReusableView()
    }
    let sectionTitles = ["🌸 봄", "☀️ 여름", "🍂 가을", "❄️ 겨울"]
    header.configure(title: sectionTitles[indexPath.section])
    return header
  }

  // 섹션별 아이템
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.section {
    case 0:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpringViewCell.identifier, for: indexPath) as? SpringViewCell else {
        print("❌ SpringViewCell 타입 캐스팅 실패")
        return UICollectionViewCell()
      }
      guard let item = viewModel.currentState.music["봄"]?[indexPath.item] else { return cell }
      cell.configure(with: item)
      return cell
    case 1:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SummerViewCell.identifier, for: indexPath) as? SummerViewCell else {
        print("❌ SummerViewCell 타입 캐스팅 실패")
        return UICollectionViewCell()
      }
      guard let item = viewModel.currentState.music["여름"]?[indexPath.item] else { return cell }
      cell.configure(with: item)
      return cell
    case 2:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AutumnViewCell.identifier, for: indexPath) as? AutumnViewCell else {
        print("❌ AutumnViewCell 타입 캐스팅 실패")
        return UICollectionViewCell()
      }
      guard let item = viewModel.currentState.music["가을"]?[indexPath.item] else { return cell }
      cell.configure(with: item)
      return cell
    case 3:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WinterViewCell.identifier, for: indexPath) as? WinterViewCell else {
        print("❌ WinterViewCell 타입 캐스팅 실패")
        return UICollectionViewCell()
      }
      guard let item = viewModel.currentState.music["겨울"]?[indexPath.item] else { return cell }
      cell.configure(with: item)
      return cell
    default:
      fatalError("섹션 에러입니다애용")
    }
  }
}
