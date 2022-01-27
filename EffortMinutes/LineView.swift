//
//  RankView.swift
//  CircleBuns
//
//  Created by Markim Shaw on 1/10/22.
//

import Foundation
import UIKit

final class LineView: UIView {
  
  let maxValue: Double
  let lineWidth: Double
  let strokeColor: UIColor
  let shapeLayer: CAShapeLayer = CAShapeLayer()
  
  init(maxValue: Double,
       lineWidth: Double = 10.0,
       strokeColor: UIColor = .black) {
    self.maxValue = maxValue
    self.lineWidth = lineWidth
    self.strokeColor = strokeColor
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
//    commonInit()
    backgroundColor = .clear
  }
  
  override func draw(_ rect: CGRect) {
    /* STroke the bottom path*/
    let bottomPath = UIBezierPath()
    bottomPath.move(to: CGPoint(x: bounds.midX, y: maxValue))
    bottomPath.addLine(to: CGPoint(x: bounds.midX, y: 0.0))
    bottomPath.close()
    bottomPath.lineWidth = lineWidth
    strokeColor.set()
    bottomPath.stroke()
    
//    let topPath = UIBezierPath()
//    topPath.move(to: CGPoint(x: frame.midX, y: maxValue))
//    topPath.addLine(to: CGPoint(x: frame.midX, y: 0.0))
//    topPath.close()
//    topPath.lineWidth = 5.0
//    UIColor.green.set()
//    topPath.stroke()
  }
//  
  func commonInit() {
    
    layer.addSublayer(shapeLayer)
    shapeLayer.strokeColor = strokeColor.cgColor
    shapeLayer.lineWidth = lineWidth
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
//    let bottomPath = UIBezierPath()
//    bottomPath.move(to: CGPoint(x: bounds.midX, y: maxValue))
//    bottomPath.addLine(to: CGPoint(x: bounds.midX, y: 0.0))
//    bottomPath.close()
//
//    shapeLayer.path = bottomPath.cgPath
//
  }
  
  required init?(coder: NSCoder) {
    maxValue = 0.0
    lineWidth = 0.0
    strokeColor = .black
    super.init(coder: coder)
  }
}
