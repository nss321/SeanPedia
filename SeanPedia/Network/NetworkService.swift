//
//  NetworkService.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit
import Alamofire

enum TMDBRequest {
    case trending
    case images(id: Int)
    case credit(id: Int)
    
    var baseURL: String {
        return Urls.baseURL()
    }
    
    var endpoint: URL {
        switch self {
        case .trending:
            return URL(string: Urls.trending())!
        case let .images(id):
            return URL(string: Urls.images(id: id))!
        case let .credit(id: id):
            return URL(string: Urls.credit(id: id))!
        }
    }
    
    var header: HTTPHeaders {
        return ["Authorization": APIKeys.accessToken]
    }
    
    var method: HTTPMethod {
        return .get
    }
}

final class NetworkService {
    static let shared = NetworkService()
    
    private init () { }
    
    func callPhotoRequest<T: Decodable>(
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
}
