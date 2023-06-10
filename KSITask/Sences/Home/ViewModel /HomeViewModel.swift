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

    private  var userProductsModelSubject = PublishSubject<[ProductsData]>()
    private  let networkManager        =  NetworkManager()
    
    var  userProductsModelObservable: Observable<[ProductsData]> {return userProductsModelSubject}
    var loadingObserver: Observable<Bool>{ return loadingBehavior.asObservable()}
    var showAlertObserver: Observable<String>{return showAlertBehavior.asObservable()}
    
   
    
    init() {
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
                }else{
                    self.showAlertBehavior.accept("error ")

                }
            case .failure(let error):
                self.showAlertBehavior.accept(error.rawValue)
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
        
 
