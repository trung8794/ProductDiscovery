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
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - Lets
    let productListFacade = ProductListFacade()
    let estimateHeightOfCell : CGFloat = 130
    
    // MARK: - Vars
    var lstProducts = [ProductDTO]()
    var keyWord: String = ""
    var currentPage: Int = 1
    
    // Check loadmore for tableView
    var isLoadingData = false
    var isEndData = false
    
    // MARK: - Life Circles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        initData()
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
        searchTableView.estimatedRowHeight = estimateHeightOfCell
    }
    
    func initData(){
        // Init Product list wwith initial items and reload Table
       getListProducts()
    }

    // MARK: - Services
    func getListProducts(_keywords: String = "", _page: String = "1", _limit: String = "20"){
        isLoadingData = true
        productListFacade.getListProducts(keyWords: _keywords, page: _page, limit: _limit, completion: { (products) in
            if products.count > 0{
                self.lstProducts.append(contentsOf: products)
                // Reload TableView
                DispatchQueue.main.sync {
                    self.searchTableView.reloadData()
                }
                self.currentPage += 1
            }else{
                 self.isEndData = true
            }
            
            self.isLoadingData = false
        }) { (error) in
            self.isLoadingData = false
        }
    }
    
 
}


// MARK: - TextField Delegate
extension ProductsViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.lstProducts.removeAll()
        searchTableView.reloadData()
        
        // Search Product with Words
        self.currentPage = 1
        self.isEndData = false
        self.keyWord = textField.text.value()
        
        getListProducts(_keywords: textField.text.value(), _page: "1", _limit: "20")
        
        return true
    }
}


// MARK: Functions for UItableview Delegate and Datasource
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell
        cell?.configCell(lstProducts[indexPath.row])
        
        cell?.cacheImageForCell = { image in
            self.lstProducts[indexPath.row].cachedImages.removeAll()
            self.lstProducts[indexPath.row].cachedImages.append(image)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.contentSize.height > tableView.bounds.height + 50{
            let lastElement = lstProducts.count - 1
            if indexPath.row == lastElement && !isLoadingData && !isEndData{
                let pageStt = "\(self.currentPage)"
                self.getListProducts(_keywords: keyWord, _page: pageStt, _limit: "8")
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = ProductDetailViewController(nibName: "ProductDetailViewController", bundle: nil)
        detailVC.skuValue = lstProducts[indexPath.row].sku
        if lstProducts.count > 8{
            for index in 0...7{
                detailVC.lstRelatedProducts.append(lstProducts[index])
            }
        }else{
            detailVC.lstRelatedProducts = lstProducts
        }
        self.present(detailVC, animated: true, completion: nil)
    }
    
}
