//
//  EmptyViewCell.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 8/1/25.
//
import SnapKit
import Then
import UIKit

class EmptyViewCell: UICollectionViewCell {
  static let identifier: String = "EmptyViewCell"

  private let titleLabel = UILabel().then {
    $0.textAlignment = .center
    $0.text = "검색 결과가 없습니다."
    $0.font = UIFont.boldSystemFont(ofSize: 18)
    $0.textColor = .label
    $0.numberOfLines = 2
  }

  // 셀 초기화 시 UI 요소 등록 및 제약조건 설정
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(titleLabel)

    titleLabel.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

