//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/29/22.
//

import Foundation
import UIKit

public class BallView: UIView  {
  
  let size: CGSize
  
  public init(size: CGSize = CGSize(width: 22, height: 22),
              color: UIColor = .init(hexString: "#80CED7"),
              lineWidth: CGFloat = 1.0,
              opacity: Float = 1.0) {
    self.size = size
    super.init(frame: .zero)
    
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    var path = UIBezierPath()
    path = UIBezierPath(ovalIn: CGRect(origin: .zero,
                                       size: size))
    
    let shape = CAShapeLayer()
    shape.path = path.cgPath
    shape.fillColor = color.cgColor
    shape.lineWidth = lineWidth
    view.layer.addSublayer(shape)
    
    view.layer.opacity = opacity
    addSubview(view)
  }
  
  override public var intrinsicContentSize: CGSize {
    self.size
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
