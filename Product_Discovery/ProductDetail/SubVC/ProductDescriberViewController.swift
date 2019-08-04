//
//  ProductDescriberViewController.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/4/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import UIKit

class ProductDescriberViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.makeCorner(10.0)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
