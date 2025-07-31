//
//  WinterViewCell.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/30/25.
//
import SnapKit
import Then
import UIKit

class WinterViewCell: UICollectionViewCell {
  static let identifier: String = "WinterViewCell"

  private let imageView = UIImageView().then {
    $0.contentMode = .scaleToFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 8
  }

  private let titleLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 16)
    $0.textColor = .label
    $0.numberOfLines = 2
  }

  private let artistLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = .secondaryLabel
    $0.numberOfLines = 1
  }

  private let collectionLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = .secondaryLabel
    $0.numberOfLines = 1
  }

  // 셀 초기화 시 UI 요소 등록 및 제약조건 설정
  override init(frame: CGRect) {
    super.init(frame: frame)

    setUI()
    setConstraints()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // UI 추가
  private func setUI() {
    [imageView, titleLabel, artistLabel, collectionLabel].forEach { contentView.addSubview($0) }
  }

  //  레이아웃 설정
  private func setConstraints() {
    imageView.snp.makeConstraints {
      $0.leading.top.equalToSuperview().offset(8)
      $0.bottom.equalToSuperview().inset(8)
      $0.width.equalTo(imageView.snp.height)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.top).inset(2)
      $0.leading.equalTo(imageView.snp.trailing).offset(8)
      $0.trailing.equalToSuperview().inset(8)
    }

    artistLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4)
      $0.leading.trailing.equalTo(titleLabel)
    }

    collectionLabel.snp.makeConstraints {
      $0.top.equalTo(artistLabel.snp.bottom).offset(4)
      $0.leading.trailing.equalTo(titleLabel)
      $0.bottom.lessThanOrEqualToSuperview().inset(8)
    }
  }

  // 전달받은 데이터를 셀 UI에 반영
  func configure(with winter: Music) {
    if let url = URL(string: winter.artworkUrl100) {
      imageView.af.setImage(withURL: url)
    }
    titleLabel.text = winter.trackName
    artistLabel.text = winter.artistName
    collectionLabel.text = winter.collectionName
  }
}
