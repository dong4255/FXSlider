//
//  ViewController.swift
//  FXSliderDemo
//
//  Created by MAC on 2019/10/28.
//  Copyright © 2019 dong. All rights reserved.
//

import UIKit
import FXSlider

class ViewController: UIViewController {
    
    @IBOutlet weak var slider: FXSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func sliderValueChanged(_ sender: FXSlider) {
        print(sender.value)
    }
    
    @IBAction func testButtonAction(_ sender: UIButton) {
        slider.value = 0.5
    }
    
}

