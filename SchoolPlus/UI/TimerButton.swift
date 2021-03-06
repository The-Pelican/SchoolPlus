//
//  TimerButton.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/11.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class TimerButton: UIButton {
    
    typealias ClickedClosure = (_ sender: UIButton) -> Void

    var clickedBlock: ClickedClosure?
    
    private var countdownTimer: Timer?
        /// 计时器是否开启(定时器开启的时机)
    var isCounting = false {
        willSet {
                  // newValue 为true表示可以计时
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime(_:)), userInfo: nil, repeats: true)
                    
                } else {
                    // 定时器停止时，定时器关闭时(销毁定时器)
                    countdownTimer?.invalidate()
                   countdownTimer = nil
               }
                // 判断按钮的禁用状态 有新值 按钮禁用 无新值按钮不禁用
                 self.isEnabled = !newValue
            }
        }
        
        /// 剩余多少秒
        var remainingSeconds: Int = 60 {
            willSet {
                self.setTitle("\(newValue) s", for: .normal)
                if newValue <= 0 {
                    self.setTitle("重新获取", for: .normal)
                    isCounting = false
                }
            }
        }
        
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            // 初始化
            self.setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // 配置UI
        func setupUI() -> Void {
            
            self.setTitle(" 获取验证码 ", for:.normal)
            self.setTitleColor(UIColor.black, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            self.backgroundColor = UIColor.white
            self.layer.cornerRadius = 12
            self.layer.masksToBounds = true
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor.black.cgColor
            self.addTarget(self, action: #selector(sendButtonClick(_:)), for: .touchUpInside)
        }
       
        // MARK: 点击获取验证码
        // 按钮点击事件(在外面也可以再次定义点击事件,对这个不影响,会并为一个执行)
        @objc func sendButtonClick(_ btn:UIButton) {
            
            // 开启计时器
            self.isCounting = true
           // 设置重新获取秒数
          self.remainingSeconds = 60
           
            // 调用闭包
           if clickedBlock != nil {
               self.clickedBlock!(btn)
           }
          
        }
       
        // 开启定时器走的方法
        @objc func updateTime(_ btn:UIButton) {
            remainingSeconds -= 1
        }
        



}
