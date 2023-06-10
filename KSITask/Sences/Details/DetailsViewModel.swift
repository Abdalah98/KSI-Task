//
//  DetailsViewModel.swift
//  KSITask
//
//  Created by Bedo on 10/06/2023.
//

import Foundation
import RxCocoa
import RxSwift
class DetailsViewModel {
    
    var pricseProductBehavior              = BehaviorRelay<String>(value: "")
    var titleProductBehavior              = BehaviorRelay<String>(value: "")
    var detailsProductBehavior              = BehaviorRelay<String>(value: "")
    var nameProductBehavior              = BehaviorRelay<String>(value: "")
    private let modelSubject             = PublishSubject<ProductsData>()
        
    private  var userProductsModelSubject = PublishSubject<[String]>()
    
    var  userProductsModelObservable: Observable<[String]> {return userProductsModelSubject}
    
    func receiveModel(_ model: ProductsData) {
        modelSubject.onNext(model)
    }
    
    func observeModel() -> Observable<ProductsData> {
        return modelSubject.asObservable()
    }
    init() {
        
    }
    func fetchProducts(productsData:ProductsData) {
        // to show Activity
        // fetch data and call api
        guard let price = productsData.price  else {return}
        
        self.pricseProductBehavior.accept("$ \(price)")
        self.titleProductBehavior.accept(productsData.category ?? "")
        self.detailsProductBehavior.accept(productsData.description ?? "")
        self.nameProductBehavior.accept(productsData.title )
        self.userProductsModelSubject.onNext(productsData.images ?? [])

        
    }
    
    
}
