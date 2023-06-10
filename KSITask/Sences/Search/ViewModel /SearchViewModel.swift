//
//  SarchViewModel.swift
//  KSITask
//
//  Created by Bedo on 10/06/2023.
//

import Foundation
import RxCocoa
import RxSwift
class SearchViewModel {
    
    private  var showAlertBehavior    = BehaviorRelay<String>(value: "")
    private  var loadingBehavior      = BehaviorRelay<Bool>(value: false)
    private  let searchValue          = BehaviorRelay<String>(value: "")

    private  var userProductsModelSubject = PublishSubject<[ProductsData]>()
    private  let networkManager        =  NetworkManager()
    
    let filterModelObservable: Observable<[ProductsData]>
    var searchValueObserver: AnyObserver<String?> { searchValueBehavior.asObserver() }
    private let searchValueBehavior = BehaviorSubject<String?>(value: "")
    var  userProductsModelObservable: Observable<[ProductsData]> {return userProductsModelSubject}
    var loadingObserver: Observable<Bool>{ return loadingBehavior.asObservable()}
    var showAlertObserver: Observable<String>{return showAlertBehavior.asObservable()}
    var showSearchValueObserver: Observable<String>{return searchValue.asObservable()}
    
   
    
    init() {
        filterModelObservable = Observable.combineLatest(
            searchValueBehavior
                .map { $0 ?? "" }
                .startWith("ds")
                .throttle(.milliseconds(500), scheduler: MainScheduler.instance),userProductsModelSubject
        )
        .map { searchValue, producto in
            searchValue.isEmpty ? producto : producto.filter { $0.title.lowercased().contains(searchValue.lowercased()) }
        }
    }
    
    func fetchProducts() {
        // to show Activity
        // fetch data and call api
        loadingBehavior.accept(true)
        networkManager.getAllProduct (completion: { [weak self] result in
            
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            switch result {
            case .success(let products):
                    self.userProductsModelSubject.onNext(products.products ?? [])
            case .failure(let error):
                self.showAlertBehavior.accept(error.rawValue)
            }
                    })
                }
        }
        
 
