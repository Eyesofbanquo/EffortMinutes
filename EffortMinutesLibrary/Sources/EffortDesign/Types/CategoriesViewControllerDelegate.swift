//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/1/22.
//

import Foundation
import EffortModel
import UIKit

public enum CategoriesViewDelegateAction {
  case add, remove
}

/* The view conforms to this*/
public protocol CategoriesViewControllerDelegate: AnyObject {
  func performAction(_ action: CategoriesViewDelegateAction, forCategory category: EMCategory)
  func reload()
  var projection: AnyObject { get }
  init(backgroundColor: UIColor)
}
