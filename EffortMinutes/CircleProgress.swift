//
//  CircleProgress.swift
//  CircleBuns
//
//  Created by Markim Shaw on 1/10/22.
//

import Foundation
import UIKit

protocol CircleProgressDelegate: AnyObject {
  func circleProgress(_ circleProgress: CircleProgress,
                      degress: Double)
}

final class CircleProgress: UIView {
  
  // MARK: - Properties -
  let radius: CGFloat
  let outlineColor: UIColor
  let lineWidth: CGFloat
  let ballRadius: CGFloat
  let ballColor: UIColor
  let maxValue: Double
  
  typealias CircleProgressArgs = (radius: CGFloat,
                                  outlineColor: UIColor,
                                  lineWidth: CGFloat,
                                  ballRadius: CGFloat,
                                  ballColor: UIColor,
                                  maxValue: Double)
  
  weak var delegate: CircleProgressDelegate?
  
  var ballView: UIView!
  
  init(args: CircleProgressArgs) {
    self.radius = args.radius
    self.outlineColor = args.outlineColor
    self.lineWidth = args.lineWidth
    self.ballColor = args.ballColor
    self.ballRadius = args.ballRadius
    self.maxValue = args.maxValue
    
    super.init(frame: CGRect(origin: .zero,
                             size: CGSize(width: radius * 2.0 + ballRadius * 2.0,
                                          height: radius * 2.0 + ballRadius * 2.0)))
    
    self.createCircluarPath()
    self.createBallView()
    self.createPanGesture()
    self.setInitialPosition()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    CGSize(width: radius * 2.0 + ballRadius * 2.0,
           height: radius * 2.0 + ballRadius * 2.0)
    
  }
  
  private func createCircluarPath() {
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX,
                                                     y: self.bounds.midY),
                                  radius: self.radius,
                                  startAngle: CGFloat(0),
                                  endAngle: CGFloat(Double.pi * 2),
                                  clockwise: true)
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = circlePath.cgPath
    
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = outlineColor.cgColor
    shapeLayer.lineWidth = lineWidth
    
    self.layer.addSublayer(shapeLayer)
  }
  
  private func createBallView() {
    ballView = UIView(frame: CGRect(x: 0.0,
                                    y: 0.0,
                                    width: ballRadius * 2.0,
                                    height: ballRadius * 2.0))
    ballView.center = self.center
    ballView.backgroundColor = .clear
    
    /* Create the ball*/
    let ballPath = UIBezierPath(arcCenter: CGPoint(x: ballView.bounds.midX,
                                                   y: ballView.bounds.midY),
                                radius: self.ballRadius,
                                startAngle: CGFloat(0),
                                endAngle: CGFloat(Double.pi * 2),
                                clockwise: true)
    
    let ballLayer = CAShapeLayer()
    ballLayer.path = ballPath.cgPath
    
    // Change the fill color
    ballLayer.fillColor = ballColor.cgColor
    ballView.layer.addSublayer(ballLayer)
    self.addSubview(ballView)
  }
  
  private func createPanGesture() {
    /* Create gesture recognizer */
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
    ballView.addGestureRecognizer(panGestureRecognizer)
  }
  
  private func setInitialPosition() {
    /* Set initial spot */
    let radius = 100.0
    let initialPoint = CGPoint(x: self.bounds.midX + (radius * cos(3 * Double.pi / 2)),
                               y: self.bounds.midY + (radius * sin(3 * Double.pi / 2)))
    ballView.center = initialPoint
  }
  
  @objc func didPan(_ sender: UIPanGestureRecognizer) {
    let location = sender.location(in: self)
    
    let boundedXFromCenterX = self.bounds.midX - location.x
    let boundedYFromCenterY = self.bounds.midY - location.y
    
    let angle = atan2(boundedYFromCenterY, boundedXFromCenterX)
    
    let boundedX = self.bounds.midX + (radius * -cos(Double(angle)))
    let boundedY = self.bounds.midY + (radius * -sin(Double(angle)))
    let boundedPoint = CGPoint(x: boundedX, y: boundedY)
    
    ballView.center = boundedPoint
    
    updateDelegate(usingAngle: angle)
  }
  
  private func updateDelegate(usingAngle angle: CGFloat) {
    let degrees = abs((Double(angle) * 180.0 / Double.pi) - 180.0)
    self.delegate?.circleProgress(self, degress: degrees)
  }
}
