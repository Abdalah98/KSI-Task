//
//  SearchVC.swift
//  KSITask
//
//  Created by Bedo on 10/06/2023.
//

import UIKit
import RxSwift
import RxCocoa

class SearchVC: UIViewController,UISearchBarDelegate {
    let vm = SearchViewModel()
    
    @IBOutlet weak var collctionView: UICollectionView!
    let disposeBag = DisposeBag()
    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureDataCollection()
        subscribeToLoading()
        subscribeToShowAlert()
        subscribeToResponseProduct()
        subscribeToProductSelection()
        configureSearch()
        bindToSearchValue()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProduct()
        navigationController?.navigationBar.isHidden = false
    }
    // add search in  navigationItem
    fileprivate func configureSearch() {
        searchController.searchBar.placeholder = "Search Here"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func bindToSearchValue() {
        searchController.searchBar.rx.text
            .distinctUntilChanged()
            .bind(to:vm.searchValueObserver)
            .disposed(by: disposeBag)
        searchController.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { () in
            })
            .disposed(by: self.disposeBag)

        searchController.searchBar.rx.textDidEndEditing
            .subscribe(onNext: { () in
            })
            .disposed(by: self.disposeBag)

    }
   
    
    func configureDataCollection(){
      
        collctionView.delegate = self
      
      // Layout
      let layout = collctionView.collectionViewLayout as? UICollectionViewFlowLayout
             layout?.sectionInset = UIEdgeInsets(top: 20, left: 16 , bottom: 15, right: 16 )
      
      let nibImage = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        collctionView.register(nibImage, forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }
}
//ProductCollectionViewCell

// MARK: - UiCollectionView
extension SearchVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 16
  }



  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: (collectionView.bounds.width / 2 ) - 24   , height:  300 )
    }
    
    //CollectionViewCell
  
    // Show Activity Loading
    func subscribeToLoading() {
        vm.loadingObserver.subscribe(onNext: { (isLoading) in
           if isLoading {
               self.showLoadingView()
           } else {
               self.dismissLoadingView()
           }}).disposed(by: disposeBag)
    }
    
    // Show Alert Massege
    func subscribeToShowAlert() {
        vm.showAlertObserver.subscribe(onNext: { (title) in
           // self.view.makeToast(title)
        }).disposed(by: disposeBag)
    }
    
    // fetch data
    func getProduct() {
        vm.fetchProducts()
    }
   
    // MARK: UICollectionView
    func subscribeToResponseProduct() {
        self.vm.userProductsModelObservable.bind(to: self.collctionView.rx.items(cellIdentifier:  "ProductCollectionViewCell",  cellType:  ProductCollectionViewCell.self)) { row, product, cell in
            cell.set(product)
        }.disposed(by: disposeBag)
    }
    
    // when i itemSelected in  CollectionView pass data
        func subscribeToProductSelection() {
            Observable
                .zip(collctionView.rx.itemSelected, collctionView.rx.modelSelected(ProductsData.self))
                .bind { [weak self] selectedIndex, product in
                    guard let self = self else{return}
                    let vc = DetailsVC()
                    vc.productData = product
                    self.navigationController?.pushViewController(vc, animated: true)
                }.disposed(by: disposeBag)
        }
}

