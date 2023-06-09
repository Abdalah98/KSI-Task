//
//  HomeViewModel.swift
//  KSITask
//
//  Created by Bedo on 09/06/2023.
//

import Foundation
import RxCocoa
import RxSwift
class HomeViewModel {
    var countProductBehavior              = BehaviorRelay<String>(value: "")
    private  var showAlertBehavior    = BehaviorRelay<String>(value: "")
    private  var loadingBehavior      = BehaviorRelay<Bool>(value: false)
    private  let searchValue          = BehaviorRelay<String>(value: "")
    private  var isCollectionHidden   = BehaviorRelay<Bool>(value: false)

    private  var userProductsModelSubject = PublishSubject<[ProductsData]>()
    private  let networkManager        =  NetworkManager()
    
    let filterModelObservable: Observable<[ProductsData]>
    var searchValueObserver: AnyObserver<String?> { searchValueBehavior.asObserver() }
    private let searchValueBehavior = BehaviorSubject<String?>(value: "")
    var  userProductsModelObservable: Observable<[ProductsData]> {return userProductsModelSubject}
    var loadingObserver: Observable<Bool>{ return loadingBehavior.asObservable()}
    var showAlertObserver: Observable<String>{return showAlertBehavior.asObservable()}
    var showSearchValueObserver: Observable<String>{return searchValue.asObservable()}
    var isCollectionHiddenObservable: Observable<Bool> {return isCollectionHidden.asObservable()}
    
    //    init(networkManager: NetworkManager = NetworkManager()) {
    //        self.networkManager = networkManager
    //    }
    
    init() {
        filterModelObservable = Observable.combineLatest(
            searchValueBehavior
                .map { $0 ?? "" }
                .startWith("ds")
                .throttle(.milliseconds(500), scheduler: MainScheduler.instance),userProductsModelSubject
        )
        .map { searchValue, photos in
            searchValue.isEmpty ? photos : photos.filter { $0.title.lowercased().contains(searchValue.lowercased()) }
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
                self.countProductBehavior.accept("\(products.products?.count ?? 0) products found")
                if  products.products?.count ?? 0  > 0 {
                    self.userProductsModelSubject.onNext(products.products ?? [])
                    self.isCollectionHidden.accept(false)
                }else{
                    self.isCollectionHidden.accept(true)
                }
            case .failure(let error):
                self.showAlertBehavior.accept(error.rawValue)
                self.isCollectionHidden.accept(true)
            }
                    })
                }
            //    func updateUserInterface() {
            //        switch Network.reachability.status {
            //        case .unreachable:
            //            fetchPhotos()
            //        case .wwan:
            //            fetchPhotos()
            //        case .wifi:
            //            fetchPhotos()
            //        }
            //    }
            
        }
        
 
