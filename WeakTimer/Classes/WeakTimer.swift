//
//  WeakTimer.swift
//  Pods
//
//  Created by 王小涛 on 2017/5/5.
//
//

import Foundation

private class WeakTimerProxy {

    private weak var _target: AnyObject?
    
    private let _block: (Timer) -> Void

    init(target: AnyObject, block: @escaping (Timer) -> Void) {
        _target = target
        _block = block
    }

    @objc func timerDidfire(timer: Timer) {

        if let _ = _target {
            _block(timer)
        }else {
            timer.invalidate()
        }
    }
}


extension Timer {
    
    public convenience init(timeInterval: TimeInterval, target: AnyObject, block: @escaping (Timer) -> Void, userInfo: Any?, repeats: Bool) {
        let proxy = WeakTimerProxy(target: target, block: block)
        self.init(timeInterval: timeInterval, target: proxy, selector: #selector(WeakTimerProxy.timerDidfire(timer:)), userInfo: userInfo, repeats: repeats)
    }

    public static func after(interval: TimeInterval, target: AnyObject, block: @escaping (Timer) -> Void) -> Timer {
        
        let timer = Timer(timeInterval: interval, target: target, block: block, userInfo: nil, repeats: false)
        timer.start()
        return timer
    }
    
    public static func every(interval: TimeInterval, target: AnyObject, block: @escaping (Timer) -> Void) -> Timer {
        
        let timer = Timer(timeInterval: interval, target: target, block: block, userInfo: nil, repeats: true)
        timer.start()
        return timer
    }
    
    
    /// Schedule this timer on the run loop
    ///
    /// By default, the timer is scheduled on the current run loop for the default mode.
    /// Specify `runLoop` or `modes` to override these defaults.

    public func start(runLoop: RunLoop = RunLoop.current, modes: RunLoopMode...) {

        // Common Modes包含default modes,modal modes,event Tracking modes.
        // 从NSTimer的失效性谈起（一）：关于NSTimer和NSRunLoop
        // https://yq.aliyun.com/articles/17710

        let modes = modes.isEmpty ? [.commonModes] : modes

        for mode in modes {
            runLoop.add(self, forMode: mode)
        }
    }
}

