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
    
    let sectionTitles = ["队列和任务", "GCD优先级、信号量", "队列的循环、挂起、恢复", "GCD其他方法"]
    let taskNames = [
        ["并发队列异步任务（控制台打印）", "串行队列异步任务（控制台打印）", "主队列异步任务（控制台打印）", "全局队列异步任务（控制台打印）", "并发队列同步任务（控制台打印）", "串行队列同步任务（控制台打印）", "主队列同步任务（死锁）", "全局队列同步任务（控制台打印）", "线程间通讯-从子线程回到主线程"],
        ["服务优先级", "信号量"],
        ["循环-快速迭代（控制台打印）", "挂起和恢复（控制台打印）"],
        ["任务只执行一次-单例（控制台打印）", "延时执行-DispatchTime（控制台打印）", "延时执行-DispatchWallTime（控制台打印）", "队列组（控制台打印）"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDatasource UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskNames[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if(cell == nil) {
            cell = UITableViewCell()
            cell?.textLabel?.text = taskNames[indexPath.section][indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
        if(header == nil) {
            header = UITableViewHeaderFooterView()
            let label = UILabel()
            label.frame = CGRect(x: 20, y: 0, width: 320, height: 40)
            label.text = sectionTitles[section]
            label.font = UIFont.boldSystemFont(ofSize: 18)
            header?.addSubview(label)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0) {
            switch indexPath.row {
            case 0:
                conAsync()
            case 1:
                serAsync()
            case 2:
                mainAsync()
            case 3:
                globalAsync()
            case 4:
                conSync()
            case 5:
                serSync()
            case 6:
                mainSync()
            case 7:
                globalSync()
            case 8:
                returnToMain()
            default:
                print(indexPath.row)
            }
        } else if(indexPath.section == 1) {
            switch indexPath.row {
            case 0:
                QoS()
            case 1:
                semaphore()
            default:
                break
            }
        } else if(indexPath.section == 2) {
            switch indexPath.row {
            case 0:
                dispatchApply()
            case 1:
                suspendAndResume()
            default:
                break
            }
            
        } else {
            switch indexPath.row {
            case 0:
                self.runOnce()
            case 1:
                delayDispatchTime()
            case 2:
                deplyDispatchWallTime()
            case 3:
                queueGroup()
            default:
                print(indexPath.row)
            }
        }
        
    }
    
    // MARK: - 队列和任务
    // 并发异步
    func conAsync() {
        let concurrentQueue = DispatchQueue(label: "Concurrent", attributes: .concurrent)
        for i in 0...10 {
            concurrentQueue.async {
                print("this is NO.\(i), current thread name is \(Thread.current)")
            }
        }
    }
    
    // 串行异步
    func serAsync() {
        let serialQueue = DispatchQueue(label: "Serial")
        for i in 0...10 {
            serialQueue.async {
                print("this is NO.\(i), current thread name is \(Thread.current)")
            }
        }
    }
    
    // 主队列异步
    func mainAsync() {
        let mainQueue = DispatchQueue.main
        for i in 0...10 {
            mainQueue.async {
                print("this is NO.\(i), current thread name is \(Thread.current)")
            }
        }
    }
    
    // 全局队列异步
    func globalAsync() {
        let globalQueue = DispatchQueue.global()
        for i in 0...10 {
            globalQueue.async {
                print("this is NO.\(i), current thread name is \(Thread.current)")
            }
        }
    }
    
    // 并发同步
    func conSync() {
        let concurrentQueue = DispatchQueue(label: "Concurrent", attributes: .concurrent)
        for i in 0...10 {
            concurrentQueue.sync {
                print("this is NO.\(i), current thread name is \(Thread.current)")
            }
        }
    }
    
    // 串行同步
    func serSync() {
        let serialQueue = DispatchQueue(label: "Serial")
        for i in 0...10 {
            serialQueue.sync {
                print("this is NO.\(i), current thread name is \(Thread.current)")
            }
        }
    }
    
    // 主队列同步
    func mainSync() {
        let mainQueue = DispatchQueue.main
        for i in 0...10 {
            mainQueue.sync {
                print("this is NO.\(i), current thread name is \(Thread.current)")
            }
        }
    }
    
    // 全局队列同步
    func globalSync() {
        let globalQueue = DispatchQueue.global()
        for i in 0...10 {
            globalQueue.sync {
                print("this is NO.\(i), current thread name is \(Thread.current)")
            }
        }
    }
    
    // 回到主线程（异步下载显示图片实例）
    func returnToMain() {
        let downloadImgVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "downloadImgVc")
        self.navigationController?.pushViewController(downloadImgVc, animated: true)
    }
    
    //MARK: - 服务优先级 信号量
    func QoS() {
        // 优先级从高到低 userInteractive、userInitiated、default、utility、background、unspecified
        // 指定Qos 这里分别用三种方式指定
        // 方式1
        let userInteractiveQueue = DispatchQueue(label: "userInteractive", qos: .userInteractive)
        let defaultQueue = DispatchQueue(label: "default", qos: .default)
        let conQueue = DispatchQueue(label: "con", attributes: .concurrent)
        for i in 0...5 {
            userInteractiveQueue.async {
                print("userInteractive ====> \(i)")
            }
            
            defaultQueue.async {
                print("defaultQueue ====> \(i)")
            }
            
            // 方式2
            DispatchQueue.global(qos: .unspecified).async {
                print("unspecified ====> \(i)")
            }
            DispatchQueue.global(qos: .userInitiated).async {
                print("userInitiated ====> \(i)")
            }
            
            // 方式3
            conQueue.async(qos: .utility) {
                print("utility ====> \(i)")
            }
            conQueue.async(qos: .background) {
                print("background ====> \(i)")
            }
        }
    }
    
    func semaphore() {
        let semaphore = DispatchSemaphore(value: 1)
        for i in 0...10 {
            DispatchQueue.global().async {
                semaphore.wait()
                print("\(i)")
                
                semaphore.signal()
            }
        }
    }
    
    // MARK: - 队列的循环、挂起、恢复
    func dispatchApply() {
        DispatchQueue.global().async {
            DispatchQueue.concurrentPerform(iterations: 10, execute: { (index) in
                print("this is NO.\(index), thread=\(Thread.current)")
            })
            
            DispatchQueue.main.async {
                print("Done")
            }
        }
    }
    
    func suspendAndResume() {
        // 先挂起显示结果的任务 图片下载完成后恢复
        print("开始任务")
        let globalQueue = DispatchQueue(label: "ShowResult")
        globalQueue.suspend()
        globalQueue.async {
            print("图片下载完成")
        }
        
        let concurrentQueue = DispatchQueue(label: "Concurrent", attributes: .concurrent)
        concurrentQueue.async {
            if let url = URL.init(string: "https://placebeard.it/800/800") {
                do {
                    print("正在下载，请稍后...")
                    _ = try Data(contentsOf: url)
                    
                    DispatchQueue.main.async {
                        globalQueue.resume()
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // MARK: - GCD 其他方法
    func runOnce() {
        SingleTon.shared.func1()
    }
    
    // asyncAfter DispatchTime 延时执行
    func delayDispatchTime() {
        print("开始执行\(NSDate())")
        // asyncAfter 并不是在指定时间后执行任务处理，而是在指定时间后把任务追加到queue里面。因此会有少许延迟。注意，我们不能（直接）取消我们已经提交到 asyncAfter 里的代码。
        // dispatch_time用于计算相对时间,当设备睡眠时，dispatch_time也就跟着睡眠了,
        let time: DispatchTimeInterval = .seconds(3)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + time, execute: {
            print("相对延时3秒后执行\(NSDate())")
        })
    }
    
    // asyncAfter DispatchWallTime 延时执行
    func deplyDispatchWallTime() {
        print("开始执行\(NSDate())")
        
        let walltime = DispatchWallTime.now() + 3.0
        
        //wallDeadline需要一个DispatchWallTime类型。创建DispatchWallTime类型，需要timespec的结构体。
        DispatchQueue.global().asyncAfter(wallDeadline: walltime) {
            print("绝对延时3秒后执行\(NSDate())")
        }
    }
    
    
    func queueGroup() {
        let globalQueue = DispatchQueue.global()
        let group = DispatchGroup()
        
        globalQueue.async(group: group, execute: {
            print("执行任务1")
        })
        
        globalQueue.async(group: group, execute: {
            print("执行任务2")
        })
        
        globalQueue.async(group: group, execute: {
            print("执行任务3")
        })
        
        globalQueue.async(group: group, execute: {
            print("执行任务4")
        })
        
        group.notify(queue: globalQueue) {
            print("任务全部完成")
        }
    }
    
    
    
    


}

