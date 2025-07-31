//
//  MovieRepository.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/30/25.
//
import RxSwift

protocol MovieRepository {
  func fetchMovie(query: String) -> Observable<[Movie]>
}
