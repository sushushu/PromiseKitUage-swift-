//
//  PromiseNotificaCenterFactorty.swift
//  PromiseKitUseage
//
//  Created by Aiagain on 2019/11/14.
//  Copyright © 2019 Aiagain. All rights reserved.
//

import Foundation

class PromiseNotificaCenterFactorty : NSObject {
    var name:String = ""
    
    init(name:String){
        super.init()
        
        self.name = name
        
        //开始观察
        beginObserver()
    }
    
    //开始观察
    func beginObserver() {
        // 监听名字为kNotificationKey的通知
        NotificationCenter.default.observe(once: Notification.Name(rawValue: "kNotificationKey")).done { notification in
            // TODO: get notification, do your job
            let userInfo = notification.userInfo as! [String: AnyObject]
            if (userInfo.isEmpty) {
                return;
            }
            
            if ((userInfo["value1"]) != nil) {
                print("\(self.name) 获取到通知，value1数据是 \(userInfo["value1"]!)")
            }
            
            if ((userInfo["value2"]) != nil) {
                print("\(self.name) 获取到通知，value2数据是 \(userInfo["value2"]!)")
            }
            
            print("\(self.name) 执行完毕\n\n\n")
            
            // 需要注意Promise的做法只会观察一次，如果需要继续观察，要手动再次注册self.beginObserver()
            self.beginObserver()
        }
    }
}

