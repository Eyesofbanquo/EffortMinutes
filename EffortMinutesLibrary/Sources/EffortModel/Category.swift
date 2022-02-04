//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/28/22.
//

import Foundation

public struct EMCategory: Hashable {
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine("\(id):\(name)")
  }
  
  /// The ID here is supplied manually upon creation. This ID isn't the same as the auto incremented ID from `EMCategoryRO`
  public let id: Int
  public let name: String
  public let effortMinutes: Int
  
  public init(id: Int, name: String, effortMinutes: Int) {
    self.id = id
    self.name = name
    self.effortMinutes = effortMinutes
  }
  
  public static func ==(_ lhs: EMCategory, _ rhs: EMCategory) -> Bool {
    return lhs.id == rhs.id
  }
}
