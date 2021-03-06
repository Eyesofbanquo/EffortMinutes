//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/30/22.
//

import Foundation
import RealmSwift

public protocol GenericStore {
  associatedtype T: Object
  var objects: Results<T>! { get }
}

public protocol Store {
  var realm: Realm! { get }
  var categories: Results<EMCategoryRO>! { get }
  var categoriesArray: [EMCategoryRO] { get }
  func addCategory(_ category: EMCategory) throws
  func removeCategory(_ category: EMCategory) throws
}
