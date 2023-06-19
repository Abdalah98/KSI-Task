//
//  ProductsInfoObject.swift
//  KSITask
//
//  Created by Bedo on 19/06/2023.
//

import Foundation
import RealmSwift
 
class ProductsInfoObject: Object {
    @Persisted var products: List<ProductsDataObject>
    @Persisted var total: Int
    @Persisted var skip: Int
    @Persisted var limit: Int
}

class ProductsDataObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var descriptionText: String?
    @Persisted var price: Int?
    @Persisted var discountPercentage: Double?
    @Persisted var rating: Double?
    @Persisted var stock: Int?
    @Persisted var brand: String?
    @Persisted var category: String?
    @Persisted var thumbnail: String?
    @Persisted var images: List<String>?
    
    func toRealmObject() -> ProductsDataObject {
        return self
    }
}

