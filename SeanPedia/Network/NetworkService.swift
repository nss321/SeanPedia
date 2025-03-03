//
//  NetworkService.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit

import Alamofire
import RxSwift
import RxCocoa

enum TMDBRequest {
    case trending
    case images(id: Int)
    case credit(id: Int)
    case search(query: String, page: Int = 1)
    
    var baseURL: String {
        return Urls.baseURL()
    }
    
    var endpoint: URL {
        switch self {
        case .trending:
            return URL(string: Urls.trending())!
        case let .images(id):
            return URL(string: Urls.images(id: id))!
        case let .credit(id):
            return URL(string: Urls.credit(id: id))!
        case let .search(query, page):
            return URL(string: Urls.search(query: query, page: page))!
        }
    }
    
    var header: HTTPHeaders {
        return ["Authorization": APIKeys.accessToken]
    }
    
    var method: HTTPMethod {
        return .get
    }
}

enum APIError: String, Error {
    case invalidQuery = "잘못된 쿼리입니다."
    case unauthorizedAccess = "인증되지 않은 토큰입니다."
    case notFound = "잘못된 요청입니다."
    case systemError = "백엔드 잘못입니다."
    case unknownResponse = "알 수 없는 오류입니다."
}

final class NetworkService {
    static let shared = NetworkService()
    
    private init () { }
    
    func callMovieRequest<T: Decodable>(
        api: TMDBRequest,
        type: T.Type,
        completion: @escaping(T) -> Void,
        failureHandler: @escaping(TMDBError) -> Void
    ) {
        AF.request(api.endpoint,
                   method: api.method,
                   headers: api.header)
//        .responseString(completionHandler: { response in
//            debugPrint(response)
//        })
        .responseDecodable(of: T.self) { response in
//            debugPrint(response)
            switch response.result {
            case .success(let value):
//                dump(value)
                completion(value)
                break
            case .failure(let error):
                dump(error)
                if let errorData = response.data {
                    do {
                        let errorMessage = try JSONDecoder().decode(TMDBError.self, from: errorData)
                        failureHandler(errorMessage)
                    } catch {
                        print("catched")
                    }
                } else {
                    print("failed unwrapping errorData")
                }
            }
        }
    }
    
    func callMovieRequestWithSingle<T: Decodable>(
        api: TMDBRequest,
        type: T.Type
    ) -> Single<Result<T, APIError>> {
        return Single.create { value in
            AF.request(api.endpoint, method: api.method, headers: api.header)
                .validate(statusCode: 200...299)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let result):
                        dump(result)
                        value(.success(.success(result)))
                    case .failure(let error):
                        if let status = response.response?.statusCode {
                            switch status {
                            case 400:
                                value(.success(.failure(APIError.invalidQuery)))
                            case 403:
                                value(.success(.failure(APIError.unauthorizedAccess)))
                            case 404:
                                value(.success(.failure(APIError.notFound)))
                            case 500:
                                value(.success(.failure(APIError.systemError)))
                            default:
                                value(.success(.failure(APIError.unknownResponse)))
                            }
                        }
                        dump(error)
                    }
                }
            return Disposables.create {
                print("영화 요청 끝")
            }
        }
    }
    
}
