//
//  ProductDetailViewController.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/3/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    // NavigationView
    
    @IBOutlet weak var lblTitleNav: UILabel!
    @IBOutlet weak var lblMoneyCountNav: UILabel!
    
    @IBOutlet weak var lblNumCart: UILabel!
    
    @IBOutlet weak var carouselView: UIView!
    @IBOutlet weak var scrollCarouselView: UIScrollView!
    @IBOutlet weak var stackCarouselView: UIStackView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    // Main info View
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductCode: UILabel!
    @IBOutlet weak var productStateView: UIView!
    
    @IBOutlet weak var lblProductState: UILabel!
    @IBOutlet weak var lblSellPrice: UILabel!
    @IBOutlet weak var lblOldPrice: UILabel!
    @IBOutlet weak var discountView: CustomGradientView!
    @IBOutlet weak var lblDiscountPercent: UILabel!
    
    // More info View
    @IBOutlet weak var btnProductDescriber: UIButton!
    @IBOutlet weak var btnTechInfo: UIButton!
    @IBOutlet weak var btnComparingPrice: UIButton!
    @IBOutlet weak var moreInfoContainerView: UIView!
    @IBOutlet weak var tabbarSublineConstrant: NSLayoutConstraint!
    @IBOutlet weak var tabbarSubline: UIView!
    
    // ADD Cart View
    @IBOutlet weak var countMoneyView: CustomGradientView!
    @IBOutlet weak var lblCounterCart: UILabel!
    @IBOutlet weak var lblCountMoney: UILabel!
    
    // Related CollectionView
    @IBOutlet weak var relatedCollectionView: UICollectionView!
    
    
    // MARK: - Lets
    let productDetailFacade = ProductDetailFacade()
    
    // MARK: - Vars
    // Page moreinfo View
    var viewControllers: [UIViewController]!
    var pageViewController: UIPageViewController!
    
    var lstRelatedProducts = [ProductDTO]()
    var skuValue: String?
    var realPrice: Int?
    var countProduct: Int = 0
    var countOfMoney: String = ""
    
    // MARK: - Life Circles
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
          self.tabbarSubline.transform = CGAffineTransform(translationX: self.view.bounds.width / 3.0, y: 0)
        self.tabbarSubline.alpha = 1
    }
    
    
    // MARK: - Inits
    func initUI(){
        lblNumCart.makeCorner(lblNumCart.frame.width / 2)
        productStateView.makeCorner()
        tabbarSubline.makeCorner(1.0)
        setupPageController()
        
        // register CollectionView cell
        relatedCollectionView.register(UINib(nibName: "RelatedItemCell", bundle: nil), forCellWithReuseIdentifier: "RelatedItemCell")
    }
    
    
    func initData(){
        getProductDetail(_sku: self.skuValue.value())
    }
    
    
    // MARK: - Services
    func getProductDetail(_sku: String){
        productDetailFacade.getProductDetail(sku: _sku, completion: { (product) in
            
            self.fillImagesToCarousel(product.images.filter{$0.url.value() != ""})
            DispatchQueue.main.async {
                self.fillDataForMainInfoView(product)
            }
        }) { (error) in
            
        }
    }
    
    // MARK: - Functions
    func fillImagesToCarousel(_ lstUrlImage: [ImageProductDTO]) {
        let lstUrl = lstUrlImage.sorted(by: {(Int($0.priority.value()) ?? 0) < (Int($1.priority.value()) ?? 0)})
        var lstImage = [UIImage]()
        if lstUrl.count == 0{
            lstImage.append(UIImage(named: Constants.DEFAULT_IMG) ?? UIImage())
        }
        
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
                }
                
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
                        var indexScroll = 1
                        var way = true
                        
                        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (myTimer) in
                            UIView.animate(withDuration: 1, animations: {
                                self.scrollCarouselView.contentOffset = CGPoint(x: self.scrollCarouselView.frame.width * CGFloat(indexScroll), y: 0)
                            })
                            //                                    self.pageControll.currentPage = i
                            if indexScroll == lstImage.count - 1 {
                                way = false
                            }
                            if indexScroll == 0{
                                way = true
                            }
                            
                            if way{
                                indexScroll += 1
                            }else{
                                indexScroll -= 1
                            }
                        })
                    }else{
                        self.pageControll.isHidden = true
                    }
                }
            }
        }
    }

    
    func fillDataForMainInfoView(_ product: ProductDTO){
        // Name
        lblProductName.text = product.displayName.value().isEmpty ? product.name.value() : product.displayName.value()
        lblTitleNav.text = lblProductName.text
        
        // Sell Price
        if let real = Int(product.price.sellPrice.value()){
            realPrice = real
        }
        let sellPrice = Int(product.price.sellPrice.value())?.formatMoney.value()
        if sellPrice.value() != ""{
            lblSellPrice.text = "\(sellPrice.value())đ"
        }else{
            lblSellPrice.text = sellPrice.value()
        }
        lblMoneyCountNav.text = lblSellPrice.text
        
        // Product Code
        lblProductCode.text = product.sku.value()
        
        // Product State
        if let totalAvailable = Int(product.totalAvailable.value()){
            lblProductState.text = "Còn \(totalAvailable) sản phẩm"
        }else{
            lblProductState.text = "Tạm hết hàng"
        }
        
        
        // Discount view
        if let sellPrice = Int(product.price.sellPrice.value()), let oldPrice = Int(product.price.supplierSalePrice.value()){
            if oldPrice - sellPrice == 0{
                discountView.isHidden = true
                lblOldPrice.isHidden = true
            }else{
                // oldPrice
                if product.price.supplierSalePrice.value() != ""{
                    discountView.isHidden = false
                    lblOldPrice.isHidden = false
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: product.price.supplierSalePrice.value())
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
                    
                    lblOldPrice.attributedText = attributeString
                    
                    // count the percent of Discount
                    let percent = CGFloat(oldPrice - sellPrice) / CGFloat(oldPrice)
                    lblDiscountPercent.text = "-\(Double(round(100*percent)/100))%"
                }else{
                    discountView.isHidden = true
                    lblOldPrice.isHidden = true
                }
                
            }
        }else{
            discountView.isHidden = true
            lblOldPrice.isHidden = true
        }
        
    }
    
    
    // MARK: - Actions
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func didSelectMoreInfo(_ sender: UIButton) {
        // Clear Title Color
        btnProductDescriber.setTitleColor(#colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1), for: .normal)
        btnTechInfo.setTitleColor(#colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1), for: .normal)
        btnComparingPrice.setTitleColor(#colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1), for: .normal)
        
        sender.setTitleColor(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), for: .normal)
        
        if sender == btnProductDescriber{
            pageViewController.setViewControllers([viewControllerAtIndex(0)!], direction: .forward, animated: true, completion: nil)
            UIView.animate(withDuration: 0.3) {
                self.tabbarSubline.transform = .identity
//                self.tabbarSublineConstrant.constant = 0
            }
        }
        if sender == btnTechInfo{
            pageViewController.setViewControllers([viewControllerAtIndex(1)!], direction: .forward, animated: true, completion: nil)
            UIView.animate(withDuration: 0.3) {
                self.tabbarSubline.transform = CGAffineTransform(translationX: self.view.bounds.width / 3.0, y: 0)
//                self.tabbarSublineConstrant.constant = self.view.bounds.width / 3.0
            }
        }
        if sender == btnComparingPrice{
            pageViewController.setViewControllers([viewControllerAtIndex(2)!], direction: .forward, animated: true, completion: nil)
            UIView.animate(withDuration: 0.3) {
                self.tabbarSubline.transform = CGAffineTransform(translationX: 2 * self.view.bounds.width / 3.0, y: 0)
            }
        }
    }
    
    // Actions to add or remove number of Products
    @IBAction func removeProductAction(_ sender: Any) {
        if self.countProduct > 0{
            countProduct -= 1
            countMoneyToPay()
        }
    }
    
    @IBAction func addProductAction(_ sender: Any) {
        countProduct += 1
        countMoneyToPay()
    }
    
    
    func countMoneyToPay() {
        lblCounterCart.text = String(countProduct)
        if realPrice != nil{
            let countMony = countProduct * realPrice!
            lblCountMoney.text = "\(countMony.formatMoney.value())đ"
        }else{
            lblCountMoney.text = ""
        }
    }
    
    
}

extension ProductDetailViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / self.scrollCarouselView.frame.width)
        pageControll.currentPage = index
    }
}

// MARK: - Page View for More Info view
extension ProductDetailViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func setupPageController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        
        viewControllers = [
            ProductDescriberViewController(nibName: "ProductDescriberViewController", bundle: nil),
            TechInfoViewController(nibName: "TechInfoViewController", bundle: nil),
            ComparingPriceViewController(nibName: "ComparingPriceViewController", bundle: nil)
        ]
        
        pageViewController.setViewControllers([viewControllerAtIndex(1)!], direction: .forward, animated: false, completion: nil)
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        moreInfoContainerView.addSubview(pageViewController.view)
        
        pageViewController!.view.frame = moreInfoContainerView.bounds
        pageViewController.didMove(toParent: self)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController)
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController)
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == viewControllers.count {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if (!completed)
        {
            return
        }
        
        let index = self.indexOfViewController(pageViewController.viewControllers!.first!)
        // Clear Title Color
        btnProductDescriber.setTitleColor(#colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1), for: .normal)
        btnTechInfo.setTitleColor(#colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1), for: .normal)
        btnComparingPrice.setTitleColor(#colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1), for: .normal)
        
        if index == 0{
            UIView.animate(withDuration: 0.3) {
                self.btnProductDescriber.setTitleColor(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), for: .normal)
                self.tabbarSubline.transform = .identity
                //                self.tabbarSublineConstrant.constant = 0
            }
        }
        
        if index == 1{
            UIView.animate(withDuration: 0.3) {
                self.btnTechInfo.setTitleColor(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), for: .normal)
                self.tabbarSubline.transform = CGAffineTransform(translationX: self.view.bounds.width / 3.0, y: 0)
                //                self.tabbarSublineConstrant.constant = self.view.bounds.width / 3.0
            }
        }
        
        if index == 2{
            UIView.animate(withDuration: 0.3) {
                self.btnComparingPrice.setTitleColor(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), for: .normal)
                self.tabbarSubline.transform = CGAffineTransform(translationX: 2 * self.view.bounds.width / 3.0, y: 0)
            }
        }
    }
}


// MARK: - Helpers
extension ProductDetailViewController {
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        if viewControllers.count == 0 || index >= viewControllers.count {
            return nil
        }
        return viewControllers[index]
    }
    
    func indexOfViewController(_ viewController: UIViewController) -> Int {
        return viewControllers.index(of: viewController) ?? NSNotFound
    }
}


// MARK: - CollectionView delegate Datasouce
extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstRelatedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedItemCell", for: indexPath) as! RelatedItemCell
        cell.configCell(lstRelatedProducts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160.0, height: collectionView.bounds.height)
    }
    
}

