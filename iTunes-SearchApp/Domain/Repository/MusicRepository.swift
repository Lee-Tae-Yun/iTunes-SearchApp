//
//  MusicRepository.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/28/25.
//
import RxSwift

protocol MusicRepository {
  func fetchMusic(query: String) -> Observable<[Music]>
}
