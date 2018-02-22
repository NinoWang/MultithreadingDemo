//
//  ImageLoadOperation.swift
//  NSOperationDemo
//
//  Created by Nino on 2017/12/28.
//  Copyright © 2017年 Nino. All rights reserved.
//

import UIKit

class ImageLoadOperation: Operation {
    let item: Item
    var dataTask: URLSessionDataTask?
    let complete: (UIImage?) -> Void
    
    init(forItem: Item, execute: @escaping (UIImage?) -> Void) {
        item = forItem
        complete = execute
        super.init()
    }
    // 私有变量 是否执行中
    fileprivate var _executing: Bool = false
    
    override var isExecuting: Bool {
        get { return _executing }
        set {
            if newValue != _executing {
                willChangeValue(forKey: "isExecuting")
                _executing = newValue
                didChangeValue(forKey: "isExecuting")
            }
        }
    }
    
    // 私有变量 是否已完成
    fileprivate var _finished: Bool = false
    
    override var isFinished: Bool {
        get { return _finished }
        set {
            if newValue != _finished {
                willChangeValue(forKey: "isFinished")
                _finished = newValue
                didChangeValue(forKey: "isFinished")
            }
        }
    }
    
    override var isAsynchronous: Bool {
        get { return true }
    }
    
    override func start() {
        if !isCancelled {
            isExecuting = true
            isFinished = false
        } else {
            isFinished = true
        }
        
        if let url = item.imageUrl() {
            let dataTask = URLSession.shared.dataTask(with: url, completionHandler: { [weak self](data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    self?.endOperationWith(image: image)
                } else {
                    self?.endOperationWith(image: nil)
                }
            })
            
            dataTask.resume()
        } else {
            self.endOperationWith(image: nil)
        }
    }
    
    override func cancel() {
        if !isCancelled {
            cancleOperation()
        }
    }
    
    func startOperation() {
        completeOperation()
    }
    
    func cancleOperation() {
        dataTask?.cancel()
    }
    
    func completeOperation() {
        if isExecuting && !isFinished {
            isExecuting = false
            isFinished = true
        }
    }
    
    func endOperationWith(image: UIImage?) {
        if !isCancelled {
            complete(image)
            completeOperation()
        }
    }
    
    

}
