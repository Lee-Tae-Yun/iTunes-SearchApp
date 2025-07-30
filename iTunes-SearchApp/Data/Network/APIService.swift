//
//  APIService.swift
//  iTunes-SearchApp
//
//  Created by 이태윤 on 7/28/25.
//
import Foundation
import RxSwift
import Alamofire

final class APIService {
  func fetch<T: Decodable>(url: String, parameters: [String: String]) -> Observable<T> {
    return Observable.create { observer in
      let request = AF.request(url, parameters: parameters)
        .responseDecodable(of: T.self) { response in
          switch response.result {
          case .success(let value):
            observer.onNext(value)
            observer.onCompleted()
          case .failure(let error):
            observer.onError(error)
            print("API Error: \(error)")
          }
        }

      return Disposables.create {
        request.cancel()
      }
    }
  }
}
