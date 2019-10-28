//
//  FXSlider.swift
//  ExchangeIOS
//
//  Created by Dong on 2019/4/23.
//  Copyright © 2019 orangeblock. All rights reserved.
//

import UIKit

@IBDesignable
@objc
open class FXSlider: UIControl {
    
    /// 缓冲进度条
    private let bufferTrackLayer = CAShapeLayer()
    private var bufferRealValue: Double = 0.0 {
        didSet {
            bufferTrackLayer.strokeEnd = CGFloat(bufferRealValue)
        }
    }
    
    /// 进度条
    private let trackLayer = CAShapeLayer()
    private let trackLayerHeight: CGFloat = 2
    /// 滑块
    private let sliderCircleView = UIImageView()
    
    /// 节点数组
    private var trackCirclesArray = [CAShapeLayer]()
    private let trackCircleWidth: CGFloat = 4
    
    /// 开始点击位置
    private var startTouchPosition = CGPoint.zero
    /// 滑块开始的位置
    private var startSliderPosition = CGPoint.zero
    /// trackLayer.strokeEnd 的真实值
    private var realValue: Double = 0.0 {
        didSet {
            changeSliderPosition()
        }
    }
    
/********************************************************************/
    
    
    
    /// 滑块大小
    @IBInspectable
    @objc
    open var sliderCircleSize: CGFloat = 20 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// 滑块颜色
    @IBInspectable
    @objc
    open var sliderCircleColor = UIColor.white {
        didSet {
            sliderCircleView.backgroundColor = sliderCircleColor
        }
    }
    
    /// 滑块图片
    @IBInspectable
    @objc
    open var sliderCircleImage: UIImage? {
        didSet {
            if sliderCircleImage != nil {
                sliderCircleView.backgroundColor = nil
                sliderCircleView.layer.cornerRadius = 0
            }
            sliderCircleView.image = sliderCircleImage?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    /// 缓冲进度条颜色
    @IBInspectable
    @objc
    open var bufferTrackColor: UIColor = UIColor.lightGray {
        didSet{
            self.setNeedsLayout()
        }
    }
    
    /// 进度条颜色
    @IBInspectable
    @objc
    open var trackColor: UIColor = UIColor.lightGray.withAlphaComponent(0.5) {
        didSet {
            self.setNeedsLayout()
        }
    }
    /// 进度条选中颜色
    @IBInspectable
    @objc
    open var selectedTrackColor: UIColor = UIColor.blue {
        didSet {
            self.setNeedsLayout()
        }
    }
    /// 节点数量
    @IBInspectable
    @objc
    open var trackCirclesCount: UInt = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// 缓冲进度数值 （最小值和最大值之间，非百分比）
    @IBInspectable
    @objc
    open var bufferValue: Double {
        get {
            return bufferRealValue * (maximumValue - minimumValue) + minimumValue
        }
        set {
            let value = min(max(minimumValue, newValue), maximumValue)
            if maximumValue == minimumValue {
                bufferRealValue = 0
            }else {
                bufferRealValue = (value - minimumValue) / (maximumValue - minimumValue)
            }
        }
    }
    
    /// 滑动的数值 （最小值和最大值之间，非百分比）
    @IBInspectable
    @objc
    open var value: Double {
        get {
            return realValue * (maximumValue - minimumValue) + minimumValue
        }
        set {
            let value = min(max(minimumValue, newValue), maximumValue)
            if maximumValue == minimumValue {
                realValue = 0
            }else {
                realValue = (value - minimumValue) / (maximumValue - minimumValue)
            }
        }
    }
    
    /// 最小值
    @IBInspectable
    @objc
    open var minimumValue: Double = 0.0 {
        didSet {
            if minimumValue > maximumValue {
                maximumValue = minimumValue
            }
            if minimumValue > value {
                value = minimumValue
            }
            self.setNeedsLayout()
        }
    }
    /// 最大值
    @IBInspectable
    @objc
    open var maximumValue: Double = 1.0 {
        didSet {
            if maximumValue < minimumValue {
                minimumValue = maximumValue
            }
            self.setNeedsLayout()
        }
    }
    
    @objc
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
        
        bufferTrackLayer.fillColor = UIColor.clear.cgColor
        bufferTrackLayer.lineWidth = trackLayerHeight
        bufferTrackLayer.strokeEnd = CGFloat(realValue)
        self.layer.addSublayer(bufferTrackLayer)
        
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = trackLayerHeight
        trackLayer.strokeEnd = CGFloat(realValue)
        self.layer.addSublayer(trackLayer)
        
        sliderCircleView.isUserInteractionEnabled = false
        sliderCircleView.frame = CGRect(x: 0, y: 0, width: sliderCircleSize, height: sliderCircleSize)
        sliderCircleView.layer.position = CGPoint(x: 0, y: self.bounds.midY)
        sliderCircleView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        sliderCircleView.backgroundColor = sliderCircleColor
        if sliderCircleView.image == nil {
            sliderCircleView.layer.cornerRadius = sliderCircleSize / 2.0
        }
        sliderCircleView.layer.shadowColor = UIColor.gray.cgColor
        sliderCircleView.layer.shadowOffset = CGSize(width: 1, height: 1)
        sliderCircleView.layer.shadowOpacity = 1
        self.addSubview(sliderCircleView)
        
    }
    
    // MARK: 设置子视图约束
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        sliderCircleView.frame.size = CGSize(width: sliderCircleSize, height: sliderCircleSize)
        if sliderCircleView.image == nil {
            sliderCircleView.layer.cornerRadius = sliderCircleSize / 2.0
        }
        sliderCircleView.layer.position.y = self.bounds.midY
        
        trackLayer.backgroundColor = UIColor.clear.cgColor
        trackLayer.strokeColor = selectedTrackColor.cgColor
        
        let trackLayerWidth = trackCirclesCount > 1 ? (self.bounds.width - trackCircleWidth) : self.bounds.width
        trackLayer.frame = CGRect(x: 0, y: 0, width: trackLayerWidth, height: trackLayerHeight)
        trackLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let path = UIBezierPath.init()
        path.move(to: CGPoint(x: 0, y: 1))
        path.addLine(to: CGPoint(x: trackLayerWidth, y: 1))
        trackLayer.path = path.cgPath
        trackLayer.strokeEnd = CGFloat(realValue)
        
        bufferTrackLayer.backgroundColor = trackColor.cgColor
        bufferTrackLayer.strokeColor = bufferTrackColor.cgColor
        bufferTrackLayer.frame = trackLayer.frame
        bufferTrackLayer.position = trackLayer.position
        bufferTrackLayer.path = path.cgPath
        bufferTrackLayer.strokeEnd = CGFloat(bufferRealValue)
        
        if trackCirclesCount > 1 {
            let stepWidth = trackLayer.bounds.width / CGFloat(trackCirclesCount - 1)
            for i in 0..<trackCirclesCount {
                let trackCircle: CAShapeLayer
                if i < trackCirclesArray.count {
                    trackCircle = trackCirclesArray[Int(i)]
                }else {
                    trackCircle = CAShapeLayer()
                    trackCircle.frame = CGRect(x: 0, y: 0, width: trackCircleWidth, height: trackCircleWidth)
                    trackCircle.cornerRadius = trackCircleWidth / 2.0
                    trackCircle.backgroundColor = trackColor.cgColor
                    trackLayer.addSublayer(trackCircle)
                    trackCirclesArray.append(trackCircle)
                }
                trackCircle.position = CGPoint(x: stepWidth * CGFloat(i), y: trackLayer.bounds.midY)
            }
        }
        
        changeSliderPosition()
    }
    
    // MARK: - Event
    // MARK: 转换PositionX 为 Value
    private func transformPositionX(_ positionX:CGFloat) -> Double {
        if positionX <= 0 {
            return 0
        }
        if positionX >= self.bounds.width {
            return 1
        }
        return Double(positionX / self.bounds.width)
    }
    
    // MARK: 转换Value 为 PositionX
    private func transformValue(_ value:Double) -> CGFloat {
        let minX = CGFloat(0)
        let maxX = self.bounds.width
        if value <= 0 {
            return minX
        }
        if value >= 1 {
            return maxX
        }
        var x = CGFloat(value) * self.bounds.width
        x = min(max(x, minX), maxX)
        return x
    }
    
    // MARK: 改变滑块位置
    private func changeSliderPosition() {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        trackLayer.strokeEnd = CGFloat(realValue)
        sliderCircleView.layer.position.x = transformValue(realValue)
        sliderCircleView.layer.anchorPoint.x = CGFloat(realValue)
        CATransaction.commit()
        
        for (i ,trackCircle) in trackCirclesArray.enumerated() {
            trackCircle.backgroundColor = realValue >= Double(i)/Double(trackCirclesArray.count - 1) ? selectedTrackColor.cgColor : trackColor.cgColor
        }
    }
    
    // MARK: - Touchs
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if maximumValue == minimumValue { return false }
        
        startTouchPosition = touch.location(in: self)
        startSliderPosition = sliderCircleView.layer.position
        
        if sliderCircleView.layer.frame.contains(startTouchPosition) {
            return true
        }else {
            for (i ,trackCircle) in trackCirclesArray.enumerated() {
                let rect = CGRect(x: trackCircle.frame.origin.x - ((sliderCircleSize / 2.0) - (trackCircleWidth / 2.0)) ,
                                  y: trackCircle.frame.origin.y - ((sliderCircleSize / 2.0) - (trackCircleWidth / 2.0)),
                                  width: trackCircle.frame.size.width + (sliderCircleSize - trackCircleWidth),
                                  height: trackCircle.frame.size.height + ((sliderCircleSize - trackCircleWidth)))
                if rect.contains(startTouchPosition) {
                    self.realValue = Double(i)/Double(trackCirclesArray.count - 1)
                    self.sendActions(for: .valueChanged)
                    return false
                }
            }
        }
        
        return false
    }
    
    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if maximumValue == minimumValue { return false }
        
        let positionX = startSliderPosition.x - (startTouchPosition.x - touch.location(in: self).x)
        let limitPositionX = min(max(0, positionX), self.bounds.width)
        
        let value = transformPositionX(limitPositionX)
        if self.realValue != value {
            self.realValue = value
            self.sendActions(for: .valueChanged)
        }
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if let point = touch?.location(in: self) {
            if sliderCircleView.layer.frame.contains(point) {
                self.sendActions(for: .touchUpInside)
            }else {
                self.sendActions(for: .touchUpOutside)
            }
        }else {
            self.sendActions(for: .touchCancel)
        }
    }
    
    public override func cancelTracking(with event: UIEvent?) {
        self.sendActions(for: .touchCancel)
    }
    
}
