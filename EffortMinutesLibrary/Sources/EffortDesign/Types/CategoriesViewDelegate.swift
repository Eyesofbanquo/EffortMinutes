//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/1/22.
//

import Foundation
import EffortModel

public protocol CategoriesViewDelegate: AnyObject {
  var categories: [EMCategory] { get }
  func categoryView(_ categoryView: CategoriesViewControllerDelegate, didSelectCategory category: EMCategory)

}
