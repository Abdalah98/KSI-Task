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
    var imageProductBehavior              = BehaviorRelay<String>(value: "")

    //private let modelSubject             = PublishSubject<ProductsData>()
        
    private let dataSubject = BehaviorSubject<[String]>(value: [])

    
    var dataObservable: Observable<[String]> {
        return dataSubject.asObservable()
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
        self.dataSubject.onNext(productsData.images ?? [])
        self.imageProductBehavior.accept(productsData.thumbnail ??
        "" )
        
    }
    
    
}
