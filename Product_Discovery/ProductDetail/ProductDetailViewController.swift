//
//  ProductDetailViewController.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/3/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var carouselView: UIView!
    @IBOutlet weak var scrollCarouselView: UIScrollView!
    @IBOutlet weak var stackCarouselView: UIStackView!
    @IBOutlet weak var pageControll: UIPageControl!
    // MARK: - Lets
    let productDetailFacade = ProductDetailFacade()
    
    // MARK: - Vars
    var skuValue: String?
//    var product = ProductDTO()

    
    // MARK: - Life Circles
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    
    // MARK: - Inits
    func initData(){
        getProductDetail(_sku: self.skuValue.value())
    }
    
    
    // MARK: - Services
    func getProductDetail(_sku: String){
        productDetailFacade.getProductDetail(sku: _sku, completion: { (product) in
            
        self.fillImagesToCarousel(product.images.filter{$0.url.value() != ""})
            
        }) { (error) in
            
        }
    }
    
    // MARK: - Functions
    func fillImagesToCarousel(_ lstUrlImage: [ImageProductDTO]) {
        let lstUrl = lstUrlImage.sorted(by: {(Int($0.priority.value()) ?? 0) < (Int($1.priority.value()) ?? 0)})
        var lstImage = [UIImage]()
        if lstUrl.count == 0{
            lstImage.append(UIImage(named: Constants.DEFAULT_IMG) ?? UIImage())
        }else{
            DispatchQueue.global().async {
                for index in 0..<lstUrl.count{
                    if index == 5{
                        break
                    }
                    
                    // DownloadImage with their URL
                    guard let url = URL(string: lstUrl[index].url.value() ) else{
                        continue
                    }
                    let data = try? Data(contentsOf: url)
                    if data != nil{
                        lstImage.append(UIImage(data: data!) ?? UIImage())
                    }
                }
                
                DispatchQueue.main.async {
                    if lstImage.count == 0{
                        lstImage.append(UIImage(named: Constants.DEFAULT_IMG) ?? UIImage())
                    }else {
                        for index in 0..<lstImage.count{
                            let imageView = UIImageView()
                            imageView.contentMode = .scaleAspectFit
                            imageView.image = lstImage[index]
                            
                           NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.scrollCarouselView.frame.width).isActive = true
                            
                            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.scrollCarouselView.frame.height).isActive = true
                            self.stackCarouselView.addArrangedSubview(imageView)
                           
                            
                            // Setup PageControll
                            self.pageControll.currentPage = 0
                            self.pageControll.numberOfPages = lstImage.count
                            
                            // AutoRunfor Scroll
                            if lstImage.count > 1{
                                self.pageControll.isHidden = false
                                var i = 1
                                var way = true
                                
                                Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (myTimer) in
                                    UIView.animate(withDuration: 1, animations: {
                                        self.scrollCarouselView.contentOffset = CGPoint(x: self.scrollCarouselView.frame.width * CGFloat(i), y: 0)
                                    })
//                                    self.pageControll.currentPage = i
                                    if i == lstImage.count - 1 {
                                        way = false
                                    }
                                    if i == 0{
                                        way = true
                                    }
                                    
                                    if way{
                                        i += 1
                                    }else{
                                        i -= 1
                                    }
                                })
                            }else{
                                self.pageControll.isHidden = true
                            }
                        }
                    }
                }
            }
        }
    }

    
    // MARK: - Actions
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension ProductDetailViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / self.scrollCarouselView.frame.width)
        pageControll.currentPage = index
    }
}
