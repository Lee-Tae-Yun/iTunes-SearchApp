//
//  SearchViewController.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/28/25.
//
import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class SearchViewController: UIViewController {
  private let viewModel: SearchViewModel
  private let disposeBag = DisposeBag()
  private let queryRelay: BehaviorRelay<String>

  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 24, weight: .bold)
  }

  private lazy var searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
    $0.backgroundColor = .systemBackground
    $0.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
    $0.register(MovieViewCell.self, forCellWithReuseIdentifier: MovieViewCell.identifier)
    $0.register(PodcastViewCell.self, forCellWithReuseIdentifier: PodcastViewCell.identifier)
    $0.register(EmptyViewCell.self, forCellWithReuseIdentifier: EmptyViewCell.identifier)

    $0.showsVerticalScrollIndicator = false
  }

  init(query: BehaviorRelay<String>, viewModel: SearchViewModel) {
    self.viewModel = viewModel
    self.queryRelay = query
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setUI()
    setConstraints()
    searchCollectionView.dataSource = self

    bindViewModel()
  }

  // MARK: - SetUPUI
  private func setUI() {
    [titleLabel, searchCollectionView].forEach {view.addSubview($0) }
  }

  private func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
      $0.leading.trailing.equalToSuperview().inset(16)
    }

    searchCollectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func bindViewModel() {
    queryRelay
      .subscribe(onNext: { query in
        print("🔍 전달받은 검색어: \(query)")
      })
      .disposed(by: disposeBag)

    queryRelay
      .bind(to: titleLabel.rx.text)
      .disposed(by: disposeBag)

    queryRelay
      .map {
        .search($0)
      }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    viewModel.state
      .observe(on: MainScheduler.instance) // UI 갱신은 메인 스레드에서
      .subscribe(onNext: { state in
        print("받은 영화 데이터:", state.movieresults)
        print("받은 팟캐스트 데이터:", state.podcastresults)
        print("받은 데이터", state)

        self.searchCollectionView.reloadData()
      })
      .disposed(by: disposeBag)
  }

  private func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { sectionIndex, environment in
      switch sectionIndex {
      case 0:
        return self.MovieSectionLayout()
      case 1:
        return self.PodcastSectionLayout()
      default:
        return self.MovieSectionLayout()
      }
    }
  }

  private func MovieSectionLayout() -> NSCollectionLayoutSection {
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    var groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(600))
    if viewModel.currentState.movieresults.isEmpty {
      groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(100))
    }
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [header]
    section.orthogonalScrollingBehavior = .groupPagingCentered
    section.interGroupSpacing = 16
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
    return section
  }

  private func PodcastSectionLayout() -> NSCollectionLayoutSection {
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / 5.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(500))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 5)
    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [header]
    section.orthogonalScrollingBehavior = .groupPagingCentered
    section.interGroupSpacing = 8
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
    return section
  }

}
// TODO: - 디퍼블데이터소스 변경하기

// MARK: - DataSource
extension SearchViewController: UICollectionViewDataSource {
  // 섹션 수
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }

  // 섹션별 셀 수
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0:
      // 검색 결과가 없을경우
      if viewModel.currentState.movieresults.isEmpty {
        return 1
      } else {
        return viewModel.currentState.movieresults.count
      }
    case 1:
      // 검색 결과가 없을경우
      if viewModel.currentState.podcastresults.isEmpty {
        return 1
      } else {
        return viewModel.currentState.podcastresults.count
      }
    default:
      return 1
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
    let sectionTitles = ["🎥 Movie", "📻 Poadcast"]
    header.configure(title: sectionTitles[indexPath.section])
    return header
  }

  // 섹션별 아이템
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.section {
    case 0:
      // 검색결과가 없을경우
      if viewModel.currentState.movieresults.isEmpty {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyViewCell.identifier, for: indexPath) as? EmptyViewCell else {
          print("❌ EmptyViewCell 타입 캐스팅 실패")
          return UICollectionViewCell()
        }
        return cell
      } else {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieViewCell.identifier, for: indexPath) as? MovieViewCell else {
          print("❌ MovieViewCell 타입 캐스팅 실패")
          return UICollectionViewCell()
        }
        let item = viewModel.currentState.movieresults[indexPath.item]
        cell.configure(with: item)
        return cell
      }

    case 1:
      // 검색결과가 없을경우
      if viewModel.currentState.podcastresults.isEmpty {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyViewCell.identifier, for: indexPath) as? EmptyViewCell else {
          print("❌ EmptyViewCell 타입 캐스팅 실패")
          return UICollectionViewCell()
        }
        return cell
      } else {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PodcastViewCell.identifier, for: indexPath) as? PodcastViewCell else {
          print("❌ PodcastViewCell 타입 캐스팅 실패")
          return UICollectionViewCell()
        }
        let item = viewModel.currentState.podcastresults[indexPath.item]
        cell.configure(with: item)
        return cell
      }

    default:
      fatalError("섹션 에러입니다애용")
    }
  }
}
