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
        request(target: .getProductsData) { (result: Result<ProductsInfo, ResoneError>) in
            switch result {
            case .success(let productsInfo):
                let realm = try! Realm()
                try! realm.write {
                    let productsInfoObject = ProductsInfoObject()
                    productsInfoObject.products.append(objectsIn: productsInfo.products?.map({ $0.toRealmObject() }) ?? [])
                    productsInfoObject.total = productsInfo.total ?? 0
                    productsInfoObject.skip = productsInfo.skip ?? 0
                    productsInfoObject.limit = productsInfo.limit ?? 0
                    
                    realm.add(productsInfoObject, update: .all)
                }
                
                completion(.success(productsInfo))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure(_):
                completion(.failure(.invalidData))
            }
        }
    }
}

