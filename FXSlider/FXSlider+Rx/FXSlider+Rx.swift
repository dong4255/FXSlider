//
//  FXSlider+Rx.swift
//  FXSlider
//
//  Created by Dong on 2019/4/29.
//  Copyright © 2019 dong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


extension Reactive where Base: FXSlider {
    
    /// Reactive wrapper for `value` property.
    public var value: ControlProperty<Double> {
        return base.rx.controlProperty(editingEvents: [.valueChanged],
        getter: { slider in
            slider.value
        }, setter: { slider, value in
            slider.value = value
        })
    }
    
}
