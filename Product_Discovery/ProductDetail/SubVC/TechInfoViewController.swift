//
//  TechInfoViewController.swift
//  Product_Discovery
//
//  Created by Nguyễn Thành on 8/4/19.
//  Copyright © 2019 TrungNguyen. All rights reserved.
//

import UIKit

struct MoreDataDTO {
    var FeatureName: String?
    var Value: String?
}

class TechInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var lstMoreInfo = [MoreDataDTO(FeatureName: "Thương hiệu", Value: "Cooler Master"),
                       MoreDataDTO(FeatureName: "Bảo hành", Value: "36 tháng"),
                       MoreDataDTO(FeatureName: "Công suất", Value: "140W"),
                       MoreDataDTO(FeatureName: "Bộ nhớ đệm", Value: "8.25MB"),
//                       MoreDataDTO(FeatureName: "Phụ kiện đi kèm", Value: "Tai nghe"),
//                       MoreDataDTO(FeatureName: "Thông tin phụ", Value: "..."),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        containerView.makeCorner(10.0)
    }
    
    func initUI(){
        // Register Cell for Search TableView
        tableView.register(UINib(nibName: "MoreInfoCell", bundle: nil), forCellReuseIdentifier: "MoreInfoCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstMoreInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "MoreInfoCell") as! MoreInfoCell)
        if indexPath.row % 2 == 0{
            cell.containerView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9450980392, blue: 0.9529411765, alpha: 1)
        }else{
            cell.containerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        cell.lblName.text = lstMoreInfo[indexPath.row].FeatureName
        cell.lblValue.text = lstMoreInfo[indexPath.row].Value
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.HEIGHT_CELL_MORE_INFO)
    }
    

}
