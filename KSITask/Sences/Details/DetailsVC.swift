//
//  DetailsVC.swift
//  KSITask
//
//  Created by Bedo on 09/06/2023.
//

import UIKit
import RxSwift
import RxCocoa


class DetailsVC: UIViewController {
    @IBOutlet weak var imageSelect: UIImageView!
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var ViewImag: UIView!
    @IBOutlet weak var collctionView: UICollectionView!
    
    @IBOutlet weak var priceLabl: UILabel!
    @IBOutlet weak var descLabl: UILabel!
    @IBOutlet weak var detailsLabl: UILabel!
    @IBOutlet weak var nameLabl: UILabel!
    
    var productData:ProductsData? = nil
    let disposeBag = DisposeBag()
    let vm = DetailsViewModel()
    var selectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        vm.receiveModel(productData!)

        subscribeToResponseProduct()
        subscribeToProductSelection()
        ViewImag.shadow()
        configureDataCollection()
        vm.pricseProductBehavior.asObservable().map{ $0}.bind(to: self.priceLabl.rx.text ).disposed(by: disposeBag)
        vm.titleProductBehavior.asObservable().map{ $0}.bind(to: self.descLabl.rx.text ).disposed(by: disposeBag)
        vm.nameProductBehavior.asObservable().map{ $0}.bind(to: self.nameLabl.rx.text ).disposed(by: disposeBag)
        vm.detailsProductBehavior.asObservable().map{ $0}.bind(to: self.detailsLabl.rx.text ).disposed(by: disposeBag)
    }
   
    @IBAction func backDidPrssed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func adtoFavDidPressed(_ sender: Any) {
    }
    
    @IBAction func radMorDidPressed(_ sender: Any) {
    }
    
    @IBAction func addToCartDidPressed(_ sender: Any) {
    }
    
    
    func configureDataCollection(){
        collctionView.delegate = self
        
        // Layout
        
        let layout = collctionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 0, left: 10 , bottom: 0, right: 0 )

        
        let nibImage = UINib(nibName: "PhotosCollectionViewCell", bundle: nil)
        collctionView.register(nibImage, forCellWithReuseIdentifier: "PhotosCollectionViewCell")
    }
}
// MARK: - UiCollectionView
extension DetailsVC : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{


    // MARK: UICollectionView
    func subscribeToResponseProduct() {
        self.vm.userProductsModelObservable.bind(to: self.collctionView.rx.items(cellIdentifier:  "PhotosCollectionViewCell",  cellType:  PhotosCollectionViewCell.self)) { row, product, cell in
           cell.set(set: product)
            print(product,"mmmm")
            cell.viewProduct.borderColor = self.selectedIndex == row ? .black : .gray
            
        }.disposed(by: disposeBag)
    }
    
    // when i itemSelected in  CollectionView pass data
    func subscribeToProductSelection() {
        Observable
            .zip(collctionView.rx.itemSelected, collctionView.rx.modelSelected(String.self))
            .bind { [weak self] selectedIndex, product in
                guard let self = self else{return}
                self.showSelectedImage(product)
            }.disposed(by: disposeBag)
    }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: 70  , height:  70 )
    
  }
    func showSelectedImage(_ image: String?) {
        guard let imagePath = image, let url = URL(string: imagePath) else {
            imageSelect.image = nil
            return
        }
        
        imageSelect.kf.setImage(with: url)
    }
    

}
