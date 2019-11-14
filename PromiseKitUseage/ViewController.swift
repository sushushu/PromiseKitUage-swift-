//
//  ViewController.swift
//  PromiseKitUseage
//
//  Created by Aiagain on 2019/11/14.
//  Copyright © 2019 Aiagain. All rights reserved.
//

import UIKit
import PromiseKit


class ViewController: UIViewController {
    
    @objc var m_button = UIButton.init(type: .custom)
    @objc dynamic var m_titleNum = 1 // 必须要加@objc关键词以及对象标记为dynamic,因为Swift 4不再自动给NSObject的子类添加@objec
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ui_init()
        
        // TODO: 以下三种方法对应三种拓展，直接调用即可
        
//        PromiseNSURLSessionrDemo()
        
        //        urlSessionGet()
        
        PromiseKVODemo()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        m_titleNum -= 1
        m_button.setTitle(String(m_titleNum), for: .normal)
    }
    
    
    /// PromiseKit Foundation拓展之NSNotificationCenter的使用
    private func PromiseNotificaCenterDemo() {
        // 先批量注册通知
        let _ = [PromiseNotificaCenterFactorty(name: "第0个通知") , PromiseNotificaCenterFactorty(name: "第1个通知") ,  PromiseNotificaCenterFactorty(name: "第2个通知")]
        
        // 开始发起通知
        NotificationCenter.default.post(name: Notification.Name(rawValue: "kNotificationKey"), object: self,
                                        userInfo: ["value1":"aigain.com", "value2" : 8600])
    }
    

    /// PromiseKit Foundation拓展之NSURLSession的使用
    private func PromiseNSURLSessionrDemo() {
        //创建URLRequest对象
        let request = URLRequest(url: URL(string:"https://httpbin.org/get?foo=bar")!)
        
        // 原生的网络请求
        let task = URLSession.shared.dataTask(with: request) { ( data, urlRespone, error) in
            if !(data == nil) && (error == nil)  {
                print(self.unPack(data: data!))
            }
        }
        task.resume()
        
        
        // Promise的做法
        _ = URLSession.shared.dataTask(.promise, with: request)
            .validate()
            .done { data, response in
                print(self.unPack(data: data))
        }
    }
    
    
    /// PromiseKit Foundation拓展之KVO的使用
    private func PromiseKVODemo() {
        Timer.scheduledTimer(timeInterval: 1, target: self,
                             selector: #selector(changeMessage),
                             userInfo: nil, repeats: true)  //定时器
        

        // 系统原生的做法
        self.addObserver(self, forKeyPath: "m_titleNum", options: .new, context: nil)
        
        // promise的做法
        PromiseObserve()
    }
    
    // 系统原生的做法,监听
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("系统原生的做法监听到了 \(change![NSKeyValueChangeKey.newKey]!)")
    }

    // promise的做法
    func PromiseObserve() {
        self.observe(.promise, keyPath: #keyPath(m_titleNum)).done { value in
            print(" PromiseObserve + \(value ?? "") ")
            //继续观察
            self.PromiseObserve()
        }
    }
    
    
    private func unPack(data:Data) -> Any {
        return try! JSONSerialization.jsonObject(with: data as Data, options:.mutableContainers)
    }
    
    @objc func changeMessage() {
        m_titleNum += 1
        m_button.setTitle(String(m_titleNum), for: .normal)
        print("定时器： \(m_titleNum)")
    }
     
    private func ui_init() {
        m_button.layer.cornerRadius = 10
        m_button.backgroundColor = UIColor.systemTeal
        m_button.frame = CGRect.init(x: 100, y: 200, width: 100, height: 100)
        m_button.setTitle("0", for: .normal)
        m_button.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        self.view.addSubview(m_button)
    }
    
    @objc private func onClick() {
        m_titleNum += 1
        m_button.setTitle(String(m_titleNum), for: .normal)
    }
}




