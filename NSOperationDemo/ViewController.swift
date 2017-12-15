//
//  ViewController.swift
//  NSOperationDemo
//
//  Created by Nino on 2017/11/10.
//  Copyright © 2017年 Nino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var detailVc: OperationDetailViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OperationDetailViewController") as? OperationDetailViewController
    }

    @IBAction func basic(_ sender: Any) {
        detailVc?.operationType = OperationType.basic
        self.navigationController?.pushViewController(detailVc!, animated: true)
    }

    @IBAction func priority(_ sender: Any) {
        detailVc?.operationType = OperationType.priority
        self.navigationController?.pushViewController(detailVc!, animated: true)
    }
    
    @IBAction func dependency(_ sender: Any) {
        detailVc?.operationType = OperationType.dependency
        self.navigationController?.pushViewController(detailVc!, animated: true)
    }
    
    
}

