//
//  MovieViewCell.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/31/25.
//
import SnapKit
import Then
import UIKit

class MovieViewCell: UICollectionViewCell {
  static let identifier: String = "MovieViewCell"

  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 8
  }

  private let titleLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 18)
    $0.textColor = .label
    $0.numberOfLines = 2
  }

  private let artistLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 16)
    $0.textColor = .secondaryLabel
    $0.numberOfLines = 1
  }

  private let primaryGenreLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 16)
    $0.textColor = .secondaryLabel
    $0.numberOfLines = 1
  }

  private let releaseDateLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = .secondaryLabel
    $0.numberOfLines = 1
  }

  // 셀 초기화 시 UI 요소 등록 및 제약조건 설정
  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.backgroundColor = .clear
    contentView.layer.cornerRadius = 12
    contentView.layer.shadowColor = UIColor.black.cgColor
    contentView.layer.shadowOpacity = 0.1
    contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
    contentView.layer.shadowRadius = 4
    contentView.layer.masksToBounds = false

    setUI()
    setConstraints()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // UI 추가
  private func setUI() {
    [imageView, titleLabel, artistLabel, primaryGenreLabel, releaseDateLabel].forEach { contentView.addSubview($0) }
  }

  //  레이아웃 설정
  private func setConstraints() {
    imageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(8)
      $0.height.equalToSuperview().multipliedBy(0.7)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(8)
      $0.leading.trailing.equalTo(imageView)
    }

    artistLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4)
      $0.leading.trailing.equalTo(titleLabel)
    }

    primaryGenreLabel.snp.makeConstraints {
      $0.top.equalTo(artistLabel.snp.bottom).offset(4)
      $0.leading.trailing.equalTo(titleLabel)
    }

    releaseDateLabel.snp.makeConstraints {
      $0.top.equalTo(primaryGenreLabel.snp.bottom).offset(4)
      $0.leading.trailing.equalTo(titleLabel)
      $0.bottom.lessThanOrEqualToSuperview().inset(8)
    }
  }

  // 전달받은 데이터를 셀 UI에 반영
  func configure(with movie: Movie) {
    if let url = URL(string: movie.artworkUrl512) {
      imageView.af.setImage(withURL: url)
    }
    titleLabel.text = movie.trackName
    artistLabel.text = movie.artistName
    primaryGenreLabel.text = movie.primaryGenreName
    releaseDateLabel.text = movie.releaseDate
  }
}

