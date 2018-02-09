//
//  OperationDetailViewController.swift
//  NSOperationDemo
//
//  Created by Nino on 2017/11/10.
//  Copyright © 2017年 Nino. All rights reserved.
//

import UIKit
// 枚举 type
enum OperationType {
    case basic
    case priority
    case dependency
    case collection
}
class OperationDetailViewController: UIViewController {
    
    let imgW = Int(UIScreen.main.bounds.width - 20)
    
    let imgH = Int((UIScreen.main.bounds.height - 80)/4)
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var img3: UIImageView!
    
    @IBOutlet weak var img4: UIImageView!
    
    let operationQueue = OperationQueue()
    
    var imageViews: [UIImageView]?
    
    var operationType: OperationType?
    
    //MARK: - override
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let type = operationType else { return }
        switch type {
        case .basic:
            self.title = "basic"
            break
        case .priority:
            self.title = "priority"
            break
        case .dependency:
            self.title = "dependency"
            break
        default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        img1.image = nil;
        img2.image = nil;
        img3.image = nil;
        img4.image = nil;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // commit1
        
        imageViews = [img1, img2, img3, img4]
    }
    
    //MARK: - actions
    @IBAction func rightItemAction(_ sender: Any) {
        indicator.startAnimating()
        guard let type = operationType else { return }
        switch type {
        case .basic:
            startBasicDemo()
            break
        case .priority:
            startPriorityDemo()
            break
        case .dependency:
            startDependencyDemo()
            break
        default:
            break
        }
    }

}
//MARK: -  extension
extension OperationDetailViewController {
    fileprivate func startBasicDemo() {
        // 最大并行数 3
        operationQueue.maxConcurrentOperationCount = 3
        // 添加任务下载图片  在主线程刷新UI
        for imageView in imageViews! {
            operationQueue.addOperation {
                if let url = URL(string: "https://placebeard.it/\(self.imgW)/\(self.imgH)") {
                    do {
                        let image = UIImage(data:try Data(contentsOf: url))
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        // 等待所有操作完成,回到主线程停止刷新器
        DispatchQueue.global().async {
            [weak self] in
            self?.operationQueue.waitUntilAllOperationsAreFinished()
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
            }
        }
    }
    
    fileprivate func startPriorityDemo() {
        operationQueue.maxConcurrentOperationCount = 2
        var operations = [Operation]()
        
        for (index, imageView) in (imageViews?.enumerated())! {
            if let url = URL(string: "https://placebeard.it/\(self.imgW)/\(self.imgH)") {
                // 使用构造方法创建operation
                let operation = ConvenienceOperation(setImageView: imageView, withURL: url)
                
                //根据索引设置优先级
                switch index {
                case 0:
                    operation.queuePriority = .veryHigh
                case 1:
                    operation.queuePriority = .high
                case 2:
                    operation.queuePriority = .normal
                case 3:
                    operation.queuePriority = .low
                default:
                    operation.queuePriority = .veryLow
                }
                
                operations.append(operation)
            }
        }
        
        // 等待所有操作完成,回到主线程停止刷新器。
        DispatchQueue.global().async {
            [weak self] in
            self?.operationQueue.addOperations(operations, waitUntilFinished: true)
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
            }
        } 
    }
    
    fileprivate func startDependencyDemo() {
        operationQueue.maxConcurrentOperationCount = 4
        if let url = URL(string: "https://placebeard.it/\(self.imgW)/\(self.imgH)") {
            let operation1 = ConvenienceOperation(setImageView: img1, withURL: url)
            let operation2 = ConvenienceOperation(setImageView: img2, withURL: url)
            let operation3 = ConvenienceOperation(setImageView: img3, withURL: url)
            let operation4 = ConvenienceOperation(setImageView: img4, withURL: url)
            // 设置依赖关系 执行顺序为 4，3，2，1
            operation1.addDependency(operation2)
            operation2.addDependency(operation3)
            operation3.addDependency(operation4)
            
            // 等待所有操作完成,回到主线程停止刷新器。
            DispatchQueue.global().async {
                [weak self] in
                self?.operationQueue.addOperations([operation1, operation2, operation3, operation4], waitUntilFinished: true)
                DispatchQueue.main.async {
                    self?.indicator.stopAnimating()
                }
            }
        }
    }
}

class ConvenienceOperation: Operation {
    let url: URL
    let imageView: UIImageView
    
    init(setImageView: UIImageView, withURL: URL) {
        imageView = setImageView
        url = withURL
        super.init()
    }
    
    override func main() {
        do {
            // 当任务被取消的时候，立刻返回
            if isCancelled {
                return
            }
            let imageData = try Data(contentsOf: url)
            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                [weak self] in
                self?.imageView.image = image
            }
        } catch  {
            print(error)
        }
    }
}
