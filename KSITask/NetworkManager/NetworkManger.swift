//
//  NetworkManger.swift
//  KSITask
//
//  Created by Bedo on 09/06/2023.

import Foundation
import Moya
import RealmSwift
enum ResoneError :String,Error{
    case invaldURL               = "This URL invalid request."
    case invalidData             = "The data received from the server was invalid. Please try again."
}

protocol Networkable {
    var provider: MoyaProvider<APIService> { get }

    func getAllProduct(completion: @escaping (Result<ProductsInfo, ResoneError>) -> ())
}

class NetworkManager: Networkable {
    func getAllProduct(completion: @escaping (Result<ProductsInfo, ResoneError>) -> ()) {
        request(target: .getProductsData, completion: completion)
    }
    
    
    var provider = MoyaProvider<APIService>(plugins: [NetworkLoggerPlugin()])

}

private extension NetworkManager {
    private func request<T: Decodable>(target: APIService, completion: @escaping (Result<T, ResoneError>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch  {
                    completion(.failure(.invalidData))
                }
            case .failure(_):
                completion(.failure(.invalidData))
            }
        }
    }
}
