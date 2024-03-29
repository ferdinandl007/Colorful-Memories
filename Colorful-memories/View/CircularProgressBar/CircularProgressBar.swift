//
//  CircularProgressBar.swift
//  Colorful-memories
//
//  Created by Ferdinand Lösch on 31/03/2020.
//  Copyright © 2020 Ferdinand Lösch. All rights reserved.
//

import UIKit

class CircularProgressBar: UIView {
    var currentTime: Double = 0
    var previousProgress: Double = 0

    // MARK: awakeFromNib

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        label.text = "0"
        labelPercent.text = "%"
        labelComplete.text = "complete"
    }

    // MARK: Public

    public var lineWidth: CGFloat = 15 {
        didSet {
            foregroundLayer.lineWidth = lineWidth
            backgroundLayer.lineWidth = lineWidth - (0.20 * lineWidth)
        }
    }

    public var labelSize: CGFloat = 30 {
        didSet {
            label.font = UIFont.systemFont(ofSize: labelSize)
            label.sizeToFit()
            configLabel()
        }
    }

    public var labelPercentSize: CGFloat = 10 {
        didSet {
            labelPercent.font = UIFont.systemFont(ofSize: labelPercentSize)
            labelPercent.sizeToFit()
            configLabelPercent()
        }
    }

    public var labelCompleteSize: CGFloat = 10 {
        didSet {
            labelComplete.font = UIFont.systemFont(ofSize: labelCompleteSize)
            labelComplete.sizeToFit()
            configLabelComplete()
        }
    }

    public var safePercent: Int = 100 {
        didSet {
            setForegroundLayerColorForSafePercent()
        }
    }

    public func setProgress(to progressConstant: Double, withAnimation: Bool) {
        var progress: Double {
            if progressConstant > 1 { return 1 }
            else if progressConstant < 0 { return 0 }
            else { return progressConstant }
        }

        foregroundLayer.strokeEnd = CGFloat(progress)

        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = previousProgress
            animation.toValue = progress
            animation.duration = 2
            foregroundLayer.add(animation, forKey: "foregroundAnimation")
        }

        previousProgress = progress
        currentTime = 0

        DispatchQueue.main.async {
            self.label.text = "\(Int(progress * 100))"
            self.setForegroundLayerColorForSafePercent()
            self.configLabel()
            self.configLabelPercent()
            self.configLabelComplete()
        }
    }

    // MARK: Private

    private var label = UILabel()
    private var labelPercent = UILabel()
    private var labelComplete = UILabel()
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private let pulsatingLayer = CAShapeLayer()
    private var radius: CGFloat {
        if frame.width < frame.height { return (frame.width - lineWidth) / 2 }
        else { return (frame.height - lineWidth) / 2 }
    }

    private var pathCenter: CGPoint { return convert(center, from: superview) }
    private func makeBar() {
        layer.sublayers = nil
        drawPulsatingLayer()
        animatePulsatingLayer()
        drawBackgroundLayer()
        drawForegroundLayer()
    }

    private func drawBackgroundLayer() {
        let path = UIBezierPath(arcCenter: pathCenter, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        backgroundLayer.path = path.cgPath
        backgroundLayer.strokeColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.fillColor = UIColor.white.cgColor
        layer.addSublayer(backgroundLayer)
    }

    private func drawForegroundLayer() {
        let startAngle = (-CGFloat.pi / 2)
        let endAngle = 2 * CGFloat.pi + startAngle

        let path = UIBezierPath(arcCenter: pathCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        foregroundLayer.lineCap = CAShapeLayerLineCap.round
        foregroundLayer.path = path.cgPath
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor
        foregroundLayer.strokeEnd = 0

        layer.addSublayer(foregroundLayer)
    }

    private func drawPulsatingLayer() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = lineWidth
        pulsatingLayer.fillColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pulsatingLayer.lineCap = CAShapeLayerLineCap.round
        pulsatingLayer.position = pathCenter
        layer.addSublayer(pulsatingLayer)
    }

    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")

        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity

        pulsatingLayer.add(animation, forKey: "pulsing")
    }

    private func makeLabel(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = UIFont.systemFont(ofSize: labelSize)
        label.sizeToFit()
        label.center = CGPoint(x: pathCenter.x, y: pathCenter.y - 10)
        return label
    }

    private func makeLabelPercent(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = UIFont.systemFont(ofSize: labelPercentSize)
        label.sizeToFit()
        label.textColor = UIColor.lightGray
        label.center = CGPoint(x: pathCenter.x + (label.frame.size.width / 2) + 10, y: pathCenter.y - 15)
        return label
    }

    private func makeLabelComplete(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = UIFont.systemFont(ofSize: labelCompleteSize)
        label.sizeToFit()
        label.textColor = UIColor.lightGray
        label.center = CGPoint(x: pathCenter.x, y: pathCenter.y + (label.frame.size.height / 2))
        return label
    }

    private func configLabel() {
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.sizeToFit()
        label.center = CGPoint(x: pathCenter.x, y: pathCenter.y - 10)
    }

    private func configLabelPercent() {
        labelPercent.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        labelPercent.sizeToFit()
        labelPercent.center = CGPoint(x: pathCenter.x + (label.frame.size.width / 2) + 10, y: pathCenter.y - 15)
    }

    private func configLabelComplete() {
        labelComplete.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        labelComplete.sizeToFit()
        labelComplete.center = CGPoint(x: pathCenter.x, y: pathCenter.y + (label.frame.size.height / 2))
    }

    private func setForegroundLayerColorForSafePercent() {
        foregroundLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    private func setupView() {
        makeBar()
        addSubview(label)
        addSubview(labelPercent)
        addSubview(labelComplete)
    }

    // Layout Sublayers
    private var layoutDone = false
    override func layoutSublayers(of _: CALayer) {
        if !layoutDone {
            let tempText = label.text
            setupView()
            label.text = tempText
            layoutDone = true
        }
    }
}
