//
//  ViewController.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/28/25.
//

import UIKit
import Then
import SnapKit

class HomeViewController: UIViewController {
  
  // 서치바
  private let searchController = UISearchController(searchResultsController: nil).then {
    $0.obscuresBackgroundDuringPresentation = false // 배경 흐림 제거
    $0.searchBar.placeholder = "영화, 팟캐스트"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setUpNavigationBar()
    setUpUI()
    setUpConstraints()
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
}
