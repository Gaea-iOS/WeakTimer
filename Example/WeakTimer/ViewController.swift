//
//  ViewController.swift
//  WeakTimer
//
//  Created by wangxiaotao on 06/06/2017.
//  Copyright (c) 2017 wangxiaotao. All rights reserved.
//

import UIKit
import WeakTimer

class ViewController: UIViewController {
    
    private lazy var downCounter: DownCounter = { [weak self] in
        let downCounter = DownCounter(target: self)
        return downCounter
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var button: UIButton!

    @IBAction func clickDownCounterButton(sender: UIButton) {
        sender.isEnabled = false
        downCounter.down = { left in
            sender.setTitle(String(left), for: .disabled)
        }
        downCounter.done = {
            sender.isEnabled = true
        }
        downCounter.start(count: 60)
    }
}

