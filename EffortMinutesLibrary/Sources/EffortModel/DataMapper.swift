//
//  File.swift
//  
//
//  Created by Markim Shaw on 1/30/22.
//

import Foundation
import RealmSwift

public class DataMapper: Store {
  
  public enum Error: Swift.Error {
    case databaseError
    case objectNotFound
  }
  
  public var realm: Realm!
  public var categories: Results<EMCategoryRO>!
  public var categoriesArray: [EMCategoryRO] {
    guard let mappedCategories = (categories.map { $0 }) else { return [] }
    return Array(mappedCategories)
  }
  
  var incrementer: IncrementerRO!
  
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
  
  public func addCategory(_ category: EMCategory, atIndex index: Int) throws {
    let realmCategory = EMCategoryRO(fromCategory: category, atIndex: index)
    do {
      try realm.write {
        /* Save category object */
        realm.add(realmCategory)
      }
    } catch {
      throw NSError()
    }
  }
  
  public func removeCategory(_ category: EMCategory) throws {
    guard let savedCategory = realm.object(ofType: EMCategoryRO.self, forPrimaryKey: category.id) else {
      throw Error.objectNotFound
    }
    do {
      try realm.write {
        realm.delete(savedCategory)
      }
    } catch {
      throw NSError()
    }
  }
}
