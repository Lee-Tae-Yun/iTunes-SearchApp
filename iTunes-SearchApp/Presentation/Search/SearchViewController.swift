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
  private let queryObservable: Observable<String>

  // 서치바
  private let searchController = UISearchController(searchResultsController: nil).then {
    $0.obscuresBackgroundDuringPresentation = false // 배경 흐림 제거
    $0.searchBar.placeholder = "영화, 팟캐스트"
  }

  private lazy var serachCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
    $0.backgroundColor = .systemBackground
    $0.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
    $0.register(MovieViewCell.self, forCellWithReuseIdentifier: MovieViewCell.identifier)
    $0.register(PodcastViewCell.self, forCellWithReuseIdentifier: PodcastViewCell.identifier)

    $0.showsVerticalScrollIndicator = false
  }

  init(query: Observable<String>, viewModel: SearchViewModel) {
    self.viewModel = viewModel
    self.queryObservable = query
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
    serachCollectionView.dataSource = self


    bindViewModel()
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
    [serachCollectionView].forEach {view.addSubview($0) }
  }

  private func setConstraints() {
    serachCollectionView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func bindViewModel() {
    queryObservable
      .map {
        .search($0)
      }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    viewModel.state
      .observe(on: MainScheduler.instance) // UI 갱신은 메인 스레드에서
      .subscribe(onNext: { state in
        print("받은 데이터:", state.results)
        self.serachCollectionView.reloadData()
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
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(380))
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

}

// MARK: - DataSource
extension SearchViewController: UICollectionViewDataSource {
  // 섹션 수
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 0
  }

  // 섹션별 셀 수
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
  }

  // 섹션별 아이템
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return UICollectionViewCell()
  }
}
