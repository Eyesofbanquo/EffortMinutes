//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/30/22.
//

import Foundation
import RealmSwift

public protocol Store {
  var categories: Results<EMCategoryRO>! { get }
  var categoriesArray: [EMCategoryRO] { get }
  func addCategory(_ category: EMCategory) throws
}
