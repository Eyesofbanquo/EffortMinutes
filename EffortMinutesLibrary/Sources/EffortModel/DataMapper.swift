//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/30/22.
//

import Foundation
import RealmSwift

public class DataMapper: Store {
  var realm: Realm!
  var incrementer: IncrementerRO!
  public var categories: Results<EMCategoryRO>!
  
  public var categoriesArray: [EMCategoryRO] {
    guard let mappedCategories = (categories.map { $0 }) else { return [] }
    return Array(mappedCategories)
  }
  
  public init(realm: Realm = try! Realm()) {
    self.realm = realm
    if incrementer == nil {
      let newIncrementer = IncrementerRO()
      try? realm.write {
        realm.add(newIncrementer)
        incrementer = newIncrementer
      }
    } else {
      incrementer = realm.objects(IncrementerRO.self).first
    }
    categories = realm.objects(EMCategoryRO.self)
  }
  
  public func addCategory(_ category: EMCategory) throws {
    let currentIndex = incrementer.currentIncrement
    let realmCategory = EMCategoryRO(fromCategory: category, atIndex: currentIndex)
    
    do {
      try realm.write {
        /* Increment the incrementer */
        self.incrementer.currentIncrement += 1
        
        /* Save category object */
        realm.add(realmCategory)
      }
    } catch {
      throw NSError()
    }
  }
}
