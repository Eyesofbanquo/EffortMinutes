//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/27/22.
//

import Foundation
import UIKit

public final class LineView: UIView {
  
  let maxValue: Double
  let lineWidth: Double
  let strokeColor: UIColor
  let shapeLayer: CAShapeLayer = CAShapeLayer()
  
  public init(maxValue: Double,
       lineWidth: Double = 10.0,
       strokeColor: UIColor = .black) {
    self.maxValue = maxValue
    self.lineWidth = lineWidth
    self.strokeColor = strokeColor
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .clear
  }
  
  override public func draw(_ rect: CGRect) {
    /* Stroke the path*/
    let bottomPath = UIBezierPath()
    bottomPath.move(to: CGPoint(x: bounds.midX, y: maxValue))
    bottomPath.addLine(to: CGPoint(x: bounds.midX, y: 0.0))
    bottomPath.close()
    bottomPath.lineWidth = lineWidth
    strokeColor.set()
    bottomPath.stroke()
  }
  
  func commonInit() {
    layer.addSublayer(shapeLayer)
    shapeLayer.strokeColor = strokeColor.cgColor
    shapeLayer.lineWidth = lineWidth
  }
  
  required init?(coder: NSCoder) {
    maxValue = 0.0
    lineWidth = 0.0
    strokeColor = .black
    super.init(coder: coder)
  }
}

