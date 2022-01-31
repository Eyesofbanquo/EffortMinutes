//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/30/22.
//

import Foundation
import RealmSwift

public class EMCategoryRO: Object {
  @Persisted(primaryKey: true) public var id: Int = 0
  @Persisted public var name: String = ""
  @Persisted public var effortMinutes: Int = 0
  
  public var structured: EMCategory {
    EMCategory(name: self.name, effortMinutes: self.effortMinutes)
  }
  
  public convenience init(fromCategory category: EMCategory, atIndex index: Int) {
    self.init()
    self.id = index
    self.name = category.name
    self.effortMinutes = category.effortMinutes
  }
}
