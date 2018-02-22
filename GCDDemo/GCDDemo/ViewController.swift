//
//  ViewController.swift
//  GCDDemo
//
//  Created by Nino on 2018/2/22.
//  Copyright © 2018年 Nino. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var gcdTableView: UITableView!
    
    let cellIdentifier = "Cell"
    
    let taskNames = ["globalQuene + 异步任务", "mainQuene + 异步任务", "异步下载一张图片并显示", "相对时间延时执行", "绝对时间延时执行"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDatasource UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if(cell == nil) {
            cell = UITableViewCell()
            cell?.textLabel?.text = taskNames[indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            globalAsyn()
        case 1:
            mainAsyn()
        case 2:
            downloadImage()
        case 3:
            delayDispatchTime()
        case 4:
            deplyDispatchWallTime()
        default:
            print(indexPath.row)
        }
    }
    
    // MARK: - 具体任务
    func globalAsyn() {
        let globalQueue = DispatchQueue.global()
        for i in 0...10 {
            globalQueue.async {
                print("this is NO.\(i), current thread name is \(Thread.current)")
            }
        }
    }
    
    func mainAsyn() {
        let mainQueue = DispatchQueue.main
        for i in 0...10 {
            mainQueue.async {
                print("this is NO.\(i), current thread name is \(Thread.current)")
            }
        }
    }
    
    func downloadImage() {
        let downloadImgVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "downloadImgVc")
        self.navigationController?.pushViewController(downloadImgVc, animated: true)
    }
    
    func delayDispatchTime() {
        let time = DispatchTimeInterval.seconds(3)
        let delayTime = DispatchTime.now() + time
        DispatchQueue.global().asyncAfter(deadline: delayTime, execute: { 
            Thread.current.name = "相对延时3秒后执行"
            print("Thread Name: \(String(describing: Thread.current.name!))\n dispatch_time: Deplay \(time) seconds.\n")
        })
    }
    
    func deplyDispatchWallTime() {
        let delayTimeInterval = Date().timeIntervalSinceNow + 2
        let nowTimespec = timespec(tv_sec: __darwin_time_t(delayTimeInterval), tv_nsec:0)
        let delayWallTime = DispatchWallTime(timespec: nowTimespec)
        
        DispatchQueue.global().asyncAfter(wallDeadline: delayWallTime) {
            Thread.current.name = "绝对延时2秒后执行"
            print("Thread Name: \(String(describing: Thread.current.name!))\n dispatchWalltime: Deplay \(delayTimeInterval) seconds.\n")
        }
    }
    


}

