//
//  UIRingLoaderView.swift
//  iOS-Test
//
//  Created by Daniil on 31.12.2023.
//

import UIKit

final class UIRingLoaderView: UIView {

    public var lineWidth: CGFloat = 5.0
    public var strokeColor: UIColor = UIColor.systemPink
    public var duration: CFTimeInterval = 0.8

    private let shapeLayer = CAShapeLayer()
    private var path = UIBezierPath()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func configure() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = 30.0
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi

        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0.0
        shapeLayer.lineCap = .round

        layer.addSublayer(shapeLayer)

    }

    public func startAnimating() {
        self.configure()
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let eraseAnimation = CABasicAnimation(keyPath: "strokeStart")
        eraseAnimation.beginTime = duration / 2
        eraseAnimation.duration = duration / 2
        eraseAnimation.fromValue = 0.0
        eraseAnimation.toValue = 1.0
        eraseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation, eraseAnimation]
        animationGroup.duration = duration
        animationGroup.repeatCount = .infinity

        shapeLayer.add(animationGroup, forKey: "stroke")
    }
    
    public func stopAnimating(){
        shapeLayer.removeAllAnimations()
    }
}
