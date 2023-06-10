//
//  PhotosCollectionViewCell.swift
//  KSITask
//
//  Created by Bedo on 10/06/2023.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewProduct: UIView!
    @IBOutlet weak var imageProduct: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func set  (set:String){
        imageProduct.kf.setImage(with: URL(string: set))
    }
}
