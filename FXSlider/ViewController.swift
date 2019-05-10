//
//  ViewController.swift
//  FXSlider
//
//  Created by Dong on 2019/4/29.
//  Copyright © 2019 dong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var slider: FXSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        slider.selectedTrackColor = .green
        
        _ = slider.rx.value.subscribe(onNext: { (value) in
//            print("rx:\(value)")
        })
        
    }

    @IBAction func sliderValueChanged(_ sender: FXSlider) {
        
        print(sender.value)
    }
    
    
    
    @IBAction func testButtonAction(_ sender: UIButton) {
        
        slider.value = 0.5
    }
    
}

