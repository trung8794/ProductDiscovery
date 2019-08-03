//
//  ProductsViewController.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/3/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {

    @IBOutlet weak var searchNavigationView: UIView!
    @IBOutlet weak var searchTableView: UITableView!
    
    // MARK: - Life Circles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        AppUtils.callCustomApi("https://listing-stg.services.teko.vn/api/search/?channel=pv_online&visitorId=&q=&terminal=CP01&_page=1&_limit=20", completeAction: { (resultJson) in
            
        }) { (errorStr) in
            
        }
    }


    
    // MARK: - Init Functions
    func initUI(){
        searchNavigationView.makeCorner()
        initTableView()
    }
    
    func initTableView(){
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        // Register Cell for Search TableView
        searchTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        
        // Auto resize UItableViewCell
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.estimatedRowHeight = 130.0
    }

}


// MARK: Functions for UItableview Delegate and Datasource
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell
        cell?.configCell()
        return cell ?? UITableViewCell()
    }
    
    
}
