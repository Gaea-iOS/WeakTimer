//
//  DownCounter.swift
//  Pods
//
//  Created by 王小涛 on 2017/6/26.
//
//

import Foundation

public class DownCounter {
    
    private var step: Int = 1
    private var left: Int = 60
    
    var isCounting: Bool = false
    
    private weak var target: AnyObject?
    private var timer: Timer?
    
    var down: ((Int) -> Void)?
    var done: (() -> Void)?
    
    public init(step: Int = 1, target: AnyObject?) {
        self.target = target
    }
    
    public func start(count: Int) {
        
        self.stop()
        
        guard let target = target else {
            return
        }
        
        isCounting = true
        left = count
        
        timer = Timer.every(interval: TimeInterval(step), target: target) { [weak self] timer in
            
            guard let `self` = self else {return}
            
            guard self.target != nil else {
                self.stop()
                return
            }
            
            self.left -= 1
            
            self.down?(self.left)
            
            if self.left <= 0 {
                self.done?()
                self.stop()
            }
        }
    }
    
    private func stop() {
        isCounting = false
        timer?.invalidate()
    }
}

