//
//  NetworkManger.swift
//  KSITask
//
//  Created by Bedo on 09/06/2023.

import Foundation
import Moya
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
        if !ReachabilityManager.shared.isConnected { // Check network connectivity
            // Fetch data from Core Data
            // Modify the below line to match your Core Data model and manager class
            let coreDataManager = CoreDataManager()
            let results = coreDataManager.fetchAllProducts() // Assuming you have a method in CoreDataManager to fetch all products
            
            if let results = results as? T {
                completion(.success(results))
            } else {
                completion(.failure(.invalidData))
            }
            return
        }
        
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    
                    // Save data to Core Data
                    // Modify the below line to match your Core Data model and manager class
                    let coreDataManager = CoreDataManager()
                    coreDataManager.saveProducts(results as! [ProductsData]) // Assuming you have a method in CoreDataManager to save products
                    
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

import Foundation
import SystemConfiguration
import CoreData

class ReachabilityManager {
    static let shared = ReachabilityManager()
    
    private init() { }
    
    var isConnected: Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return isReachable && !needsConnection
    }
}

class CoreDataManager {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourDataModelName")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                print("Failed to load Core Data stack: \(error)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save Core Data context: \(error)")
            }
        }
    }
    
    func saveProducts(_ products: [ProductsData]) {
        let context = persistentContainer.viewContext
        for product in products {
            let entity = NSEntityDescription.entity(forEntityName: "ProductEntity", in: context)!
            let productEntity = NSManagedObject(entity: entity, insertInto: context)
            
            productEntity.setValue(product.title, forKey: "name")
            productEntity.setValue(product.price, forKey: "price")
            // Set other attributes accordingly
            
            // Save the context
            saveContext()
        }
    }
    
    func fetchAllProducts() -> [ProductsData]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        
        do {
            let productEntities = try context.fetch(fetchRequest)
            let products = productEntities.map { Product(name: $0.title, price: $0.price) }
            return products
        } catch {
            print("Failed to fetch products from Core Data: \(error)")
            return nil
        }
    }
}
