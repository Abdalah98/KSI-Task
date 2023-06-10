//
//  ProductCollectionViewCell.swift
//  KSITask
//
//  Created by Bedo on 09/06/2023.
//

import UIKit
import Kingfisher
class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var namProductLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var dtailsProudctLabel: UILabel!
    @IBOutlet weak var priceLabl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func set(_ product: ProductsData){
        namProductLabel.text = product.title
        guard let price = product.price else {return}
        priceLabl.text = "$\(price)"
        dtailsProudctLabel.text = product.description
        productImage.kf.setImage(with: URL(string: product.thumbnail ?? ""))
    }
    @IBAction func favoirateDidPrssed(_ sender: Any) {
    }
}
