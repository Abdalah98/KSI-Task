//
//  HomeVC.swift
//  KSITask
//
//  Created by Bedo on 09/06/2023.
//

import UIKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {

    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var countProductLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    let vm = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureDataCollection()

        subscribeToLoading()
        subscribeToShowAlert()
        subscribeToResponseProduct()
        bindLabelToViewModel()
        subscribeToProductSelection()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        getProduct()

    }
    @IBAction func filterDidPrassed(_ sender: Any) {
    }
    

    @IBAction func sortDidPrassed(_ sender: Any) {
    }
   
    @IBAction func searchDidPrassed(_ sender: Any) {
        navigationController?.pushViewController(SearchVC(), animated: true)
    }
   
    
    func bindLabelToViewModel() {
        vm.countProductBehavior.asObservable().map{ $0}.bind(to: self.countProductLabel.rx.text ).disposed(by: disposeBag)
    }
    
    func configureDataCollection(){
      
      collectionView.delegate = self
      
      // Layout
      let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
             layout?.sectionInset = UIEdgeInsets(top: 20, left: 16 , bottom: 15, right: 16 )
      
      let nibImage = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        collectionView.register(nibImage, forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }
}
//ProductCollectionViewCell

// MARK: - UiCollectionView
extension HomeVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{


  
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
        self.vm.userProductsModelObservable.bind(to: self.collectionView.rx.items(cellIdentifier:  "ProductCollectionViewCell",  cellType:  ProductCollectionViewCell.self)) { row, product, cell in
            cell.set(product)
        }.disposed(by: disposeBag)
    }
    
    // when i itemSelected in  CollectionView pass data
    func subscribeToProductSelection() {
        Observable
            .zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(ProductsData.self))
            .bind { [weak self] selectedIndex, product in
                guard let self = self else{return}
                let vc = DetailsVC()
                vc.productData = product
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
    }
}


import UIKit
extension  UIViewController {
    func showLoadingView(){DispatchQueue.main.async {
        //self.view.makeToastActivity(.center)
        
    }}
    func dismissLoadingView(){DispatchQueue.main.async {
     //   self.view.hideToastActivity()
        
    }}
}
