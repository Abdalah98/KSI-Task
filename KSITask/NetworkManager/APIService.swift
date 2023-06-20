//
//  APIService.swift
//  KSITask
//
//  Created by Bedo on 09/06/2023.

import Foundation
import Moya

enum APIService {
    case getProductsData
}

extension APIService: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://run.mocky.io/v3") else { fatalError("erro url") }
        return url
    }
    
    var path: String {
        switch self {
        case .getProductsData:
            return "/9677ed07-93eb-42a6-9e26-5a9cbbca658f"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
}
