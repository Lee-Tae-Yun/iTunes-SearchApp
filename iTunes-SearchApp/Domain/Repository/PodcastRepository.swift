//
//  PodcastRepository.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/30/25.
//
import RxSwift

protocol PodcastRepository {
  func fetchPodcast(query: String) -> Observable<[Podcast]>
}
