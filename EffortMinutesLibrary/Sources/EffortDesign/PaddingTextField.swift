//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/7/22.
//

import Foundation
import UIKit

class PaddingTextField : UITextField {
  
  struct Padding {
    var sidePadding: CGFloat
    var topPadding: CGFloat
  }
  
  let padding: Padding
  
  public init(cornerRadius: CGFloat,
              borderWidth: CGFloat,
              borderColor: CGColor,
              padding: Padding = Padding(sidePadding: Constants.sidePadding, topPadding: Constants.topPadding)) {
    self.padding = padding
    super.init(frame: .zero)
    
    //set your border style here
    self.layer.cornerRadius = cornerRadius
    // Add borderWidth as otherwise you are having a 0 point wide border
    self.layer.borderWidth = borderWidth
    self.layer.borderColor = borderColor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  struct Constants {
    static let sidePadding: CGFloat = 10
    static let topPadding: CGFloat = 8
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(
      x: bounds.origin.x + padding.sidePadding,
      y: bounds.origin.y + padding.topPadding,
      width: bounds.size.width - padding.sidePadding * 2,
      height: bounds.size.height - padding.topPadding * 2
    )
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return self.textRect(forBounds: bounds)
  }
  
}
