//
//  FXSlider.swift
//  ExchangeIOS
//
//  Created by Dong on 2019/4/23.
//  Copyright © 2019 orangeblock. All rights reserved.
//

import UIKit

@IBDesignable
public class FXSlider: UIControl {
    
    /// 进度条
    private let trackLayer = CAShapeLayer()
    /// 滑块
    private let sliderCircleLayer = CAShapeLayer()
    /// 节点数组
    private var trackCirclesArray = [CAShapeLayer]()
    
    /// 开始点击位置
    private var startTouchPosition = CGPoint.zero
    /// 滑块开始的位置
    private var startSliderPosition = CGPoint.zero
    
    /// 进度条颜色
    @IBInspectable
    public var trackColor:UIColor = UIColor.lightGray {
        didSet{
            self.setNeedsLayout()
        }
    }
    /// 进度条选中颜色
    @IBInspectable
    public var selectedTrackColor:UIColor = UIColor.blue {
        didSet{
            self.setNeedsLayout()
        }
    }
    /// 节点数量
    @IBInspectable
    public var trackCirclesCount:UInt = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// 滑动的数值 0 ~ 1
    @IBInspectable
    public var value:Double = 0.0 {
        didSet {
            changeSliderPosition()
        }
    }
    
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createSublayers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSublayers()
    }
    
    // MARK: - 创建子视图
    /// 创建子视图
    private func createSublayers() {
        
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 2
        trackLayer.strokeEnd = 0
        self.layer.addSublayer(trackLayer)
        
        sliderCircleLayer.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        sliderCircleLayer.position = CGPoint(x: 10.5, y: self.bounds.midY)
        sliderCircleLayer.backgroundColor = UIColor.white.cgColor
        sliderCircleLayer.cornerRadius = 12.5
        sliderCircleLayer.shadowColor = UIColor.gray.cgColor
        sliderCircleLayer.shadowOffset = CGSize(width: 1, height: 1)
        sliderCircleLayer.shadowOpacity = 1
        self.layer.addSublayer(sliderCircleLayer)
        
    }
        
    // MARK: 设置子视图约束
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        sliderCircleLayer.position.y = self.bounds.midY
        
        trackLayer.backgroundColor = trackColor.cgColor
        trackLayer.strokeColor = selectedTrackColor.cgColor
        
        trackLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 2)
        trackLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let path = UIBezierPath.init()
        path.move(to: CGPoint(x: 0, y: 1))
        path.addLine(to: CGPoint(x: self.bounds.width, y: 1))
        trackLayer.path = path.cgPath
        
        
        if trackCirclesCount > 1 {
            let stepWidth = self.bounds.width / CGFloat(trackCirclesCount - 1)
            for i in 0..<trackCirclesCount {
                let trackCircle: CAShapeLayer
                if i < trackCirclesArray.count {
                    trackCircle = trackCirclesArray[Int(i)]
                }else {
                    trackCircle = CAShapeLayer()
                    trackCircle.frame = CGRect(x: 0, y: 0, width: 4, height: 4)
                    trackCircle.cornerRadius = 2
                    trackCircle.backgroundColor = trackColor.cgColor
                    self.layer.insertSublayer(trackCircle, above: trackLayer)
                    trackCirclesArray.append(trackCircle)
                }
                trackCircle.position = CGPoint(x: stepWidth * CGFloat(i), y: self.bounds.midY)
            }
        }
        
        changeSliderPosition()
    }
    
    // MARK: - Event
    // MARK: 转换PositionX 为 Value
    private func transformPositionX(_ positionX:CGFloat) -> Double {
        if positionX <= 10.5 {
            return 0
        }
        if positionX >= self.bounds.width - 10.5 {
            return 1
        }
        return Double(positionX / self.bounds.width)
    }
    
    // MARK: 转换Value 为 PositionX
    private func transformValue(_ value:Double) -> CGFloat {
        if value <= 0 {
            return 10.5
        }
        if value >= 1 {
            return self.bounds.width - 10.5
        }
        return CGFloat(value) * self.bounds.width
    }
    
    // MARK: 改变滑块位置
    private func changeSliderPosition() {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        trackLayer.strokeEnd = CGFloat(value)
        sliderCircleLayer.position.x = transformValue(value)
        CATransaction.commit()
        
        for (i ,trackCircle) in trackCirclesArray.enumerated() {
            trackCircle.backgroundColor = value >= Double(i)/Double(trackCirclesArray.count - 1) ? selectedTrackColor.cgColor : trackColor.cgColor
        }
    }
    
    // MARK: - Touchs
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        startTouchPosition = touch.location(in: self)
        startSliderPosition = sliderCircleLayer.position
        
        if sliderCircleLayer.frame.contains(startTouchPosition) {
            return true
        }else {
            for (i ,trackCircle) in trackCirclesArray.enumerated() {
                let rect = CGRect(x: trackCircle.frame.origin.x - 10.5 ,
                                  y: trackCircle.frame.origin.y - 10.5,
                                  width: trackCircle.frame.size.width + 21,
                                  height: trackCircle.frame.size.height + 21)
                if rect.contains(startTouchPosition) {
                    self.value = Double(i)/Double(trackCirclesArray.count - 1)
                    self.sendActions(for: .valueChanged)
                    return false
                }
            }
        }
        
        return false
    }
    
    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let positionX = startSliderPosition.x - (startTouchPosition.x - touch.location(in: self).x)
        let limitPositionX = min(max(10.5, positionX), self.bounds.width - 10.5)
        
        let value = transformPositionX(limitPositionX)
        self.value = value
        self.sendActions(for: .valueChanged)
        return true
    }
    
}
