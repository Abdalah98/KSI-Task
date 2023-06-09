//
//  DetailsVC.swift
//  KSITask
//
//  Created by Bedo on 09/06/2023.
//

import UIKit

class DetailsVC: UIViewController {
    
    var productData:ProductsData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
   print(productData)
        
    }


    @IBAction func backDidPrssed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
