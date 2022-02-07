//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/6/22.
//

import Foundation
import UIKit

public class KeyboardHandler {
  
  var view: UIView
  var y: CGFloat
  
  public init(forView view: inout UIView, beginningPointY y: CGFloat) {
    self.view = view
    self.y = y
    
  }
  
  
  public func setup() {
    /* For handling keyboard events */
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      if view.frame.origin.y == y {
        self.view.frame.origin.y = (view.frame.origin.y) - (keyboardSize.height + 8.0)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
      }
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      if view.frame.origin.y != y {
        self.view.frame.origin.y = (view.frame.origin.y) + (keyboardSize.height + 8.0)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
      }
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

  }
}
